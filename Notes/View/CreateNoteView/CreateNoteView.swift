//
//  CreateNoteView.swift
//  Notes
//
//  Created by Ryunosuke Yokokawa on 2023-05-07.
//

import SwiftUI



struct CreateNoteView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment (\.managedObjectContext) var moc
    @EnvironmentObject private var editMode: EditMode
    @FetchRequest(sortDescriptors: [], animation: .easeInOut) var notes: FetchedResults<Note>
    @FetchRequest(sortDescriptors: [], animation: .easeInOut) var folders: FetchedResults<Folder>
    @Binding var noteId: UUID?
    @StateObject var sheetManager = SheetManager()
    @StateObject var viewModel = CreateNoteViewModel()
   
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]
    
    let colorSelection: [Color] = [
        .primaryGreen,
        .primaryOrange,
        .primaryPurple,
        .primaryYellow,
    ]
    var body: some View {
        ZStack {
            Color.primaryBlcak.ignoresSafeArea()
            VStack {
                TextField("Title", text: $viewModel.titleValue)
                    .font(Font.headerFont(34))
                    .fontWeight(Font.Weight.medium)
                    .tracking(2)
                    .foregroundColor(.primaryWhite)
                    .padding([.top], 10)
                
                
                
                
                TextEditor(text: $viewModel.contentValue)
                    .font(Font.mainFont(17))
                    .tracking(1.5)
                    .scrollContentBackground(.hidden)
                    .foregroundColor(.primaryWhite)
                    .background(Color.primaryBlcak)
                    .scrollBounceBehavior(.always)
            }
            .sheet(isPresented: $viewModel.isSharePresented, onDismiss: {
                if let removeUrl = sheetManager.fileUrlState {
                    do {
                        try FileManager.default.removeItem(at: removeUrl)
                    } catch {
                        print(error.localizedDescription, "when deleting txt")
                    }
                    
                }
            }, content: {
                ActivityViewController(activityItems: [sheetManager.fileUrlState])
                    .presentationDetents([.fraction(0.7), .large])
                    .ignoresSafeArea()
            })
            .padding([.trailing, .leading], 20)
            .navigationBarBackButtonHidden(true)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack(spacing: 30) {
                        Circle()
                            .fill(viewModel.selectedColor)
                            .frame(width: 20, height: 20)
                            .onTapGesture {
                                viewModel.showColorSheet.toggle()
                            }
                        Image(systemName: "square.and.arrow.up")
                            .resizable()
                            .frame(width: 20, height: 25)
                            .foregroundColor(.primaryWhite)
                            .onTapGesture {
                                if viewModel.titleValue == "" {
                                    return
                                }
                                createTxtFile()
                            }
                        
                        if editMode.editMode == true {
                            Image(systemName:  "trash")
                                .resizable()
                                .frame(width: 20, height: 23)
                                .foregroundColor(.recordRed)
                                .onTapGesture {
                                    viewModel.showDeleteAlert = true
                                }
                        }
                        
                    }
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    HStack {
                        Image(systemName: "chevron.left")
                            .resizable()
                            .frame(width: 10, height: 20)
                            .foregroundColor(.primaryWhite)
                            .padding([.leading, .trailing])
                        
                    }

                    .contentShape(Rectangle())
                    .simultaneousGesture(TapGesture().onEnded {
                        if viewModel.titleValue == "" && viewModel.contentValue == "" {
                            presentationMode.wrappedValue.dismiss()
                            return
                        }
                        saveNote()
                        
                    })
                    
                }
                
                ToolbarItem(placement: .principal) {
                    Text(viewModel.folderValue == "" ? "All" : viewModel.folderValue)
                        .foregroundColor(.secondaryWhite)
                        .tracking(1)
                        .font(Font.mainFont(20))
                        .onTapGesture {
                            viewModel.showFolderModal.toggle()
                        }
                        .sheet(isPresented: $viewModel.showFolderModal) {
                            FolderModal(folderValue: $viewModel.folderValue)
                        }
                        .padding([.leading], 10)
                    
                }
            }
            
        }
        .alert("Sure to delete?", isPresented: $viewModel.showDeleteAlert) {
            Button("delete", role: .destructive) {
                if let id = noteId {
                    deleteNote(noteId: id)
                    presentationMode.wrappedValue.dismiss()
                }
               
            }
            Button("Cancel", role:.cancel) {}
            
        }
        .sheet(isPresented: $viewModel.showColorSheet) {
            ColorSheetModal { color in
                viewModel.selectedColor = color
                viewModel.showColorSheet.toggle()
            }
            .presentationDetents([.height(150)])
            .presentationBackground(Color.primaryGray)
            
        }
        .onAppear {
            if editMode.editMode {
                if let editNote = notes.first (where: {$0.id == noteId}){
                    viewModel.titleValue = editNote.wrappedTitle
                    viewModel.contentValue = editNote.wrappedContents
                    viewModel.folderValue = editNote.wrappedFolder
                    viewModel.selectedColor = Color.getColorValue(colorString: editNote.wrappedColor)
                    
                    
                }
                
                
            }
        }
    }
    
    private func createTxtFile() {
        let fileName = "\(viewModel.titleValue).txt"
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("Documents directory not found.")
            return
        }
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        sheetManager.fileNameState = fileName
        sheetManager.fileUrlState = fileURL
        do {
            try viewModel.contentValue.write(to: fileURL, atomically: true, encoding: .utf8)
            viewModel.isSharePresented.toggle()
        } catch {
            print("Failed to create text file. Error: \(error)")
        }

    }
    
    func saveNote() {
        if editMode.editMode {
            guard let noteToEdit = notes.first(where: {$0.id == noteId}) else {return}
            
            if let index = notes.firstIndex(of: noteToEdit) {
                let editNote = notes[index]
                editNote.title = viewModel.titleValue
                editNote.contents = viewModel.contentValue
                editNote.folder = viewModel.folderValue
                editNote.color = Color.getColorString(color: viewModel.selectedColor)
               
            }
            
            saveContext()
            presentationMode.wrappedValue.dismiss()
            return
            
        }
            
            let date = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let timestamp = formatter.string(from: date)
            
            let newNote = Note(context: moc)
            newNote.id = UUID()
            newNote.title = viewModel.titleValue
            newNote.timestamp = timestamp
            newNote.contents = viewModel.contentValue
            newNote.folder = viewModel.folderValue
            newNote.color = Color.getColorString(color: viewModel.selectedColor)
            newNote.date = Date()
        
            
            do {
                try moc.save()
                presentationMode.wrappedValue.dismiss()
            } catch {
                print("An error occurred: \(error)")
            }
        }
    
    
    
    func deleteNote(noteId: UUID) {
        guard let noteToDelete = notes.first(where: {$0.id == noteId}) else {return}
        moc.delete(noteToDelete)
        saveContext()
    }
    
    func saveContext() {
        do {
            try moc.save()
        } catch {
            print("An error occurred: \(error)")
        }
    }
}




//struct CreateNoteView_Previews: PreviewProvider {
//    static var previews: some View {
//        CreateNoteView()
//    }
//}
