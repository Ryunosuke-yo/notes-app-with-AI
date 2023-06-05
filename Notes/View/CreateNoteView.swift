//
//  CreateNoteView.swift
//  Notes
//
//  Created by Ryunosuke Yokokawa on 2023-05-07.
//

import SwiftUI

class SheetManager: ObservableObject {
    @Published var fileNameState = ""
    @Published var fileUrlState: URL? = nil
}

struct CreateNoteView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment (\.managedObjectContext) var moc
    @EnvironmentObject private var editMode: EditMode
    @FetchRequest(sortDescriptors: [], animation: .easeInOut) var notes: FetchedResults<Note>
    @FetchRequest(sortDescriptors: [], animation: .easeInOut) var folders: FetchedResults<Folder>
    @State var titleValue = ""
    @State var contentValue = ""
    @State var showFolderModal = false
    @State var folderValue = ""
    @State var selectedColor = Color.primaryOrange
    @State var showColorSheet = false
    @Binding var noteId: UUID?
    @StateObject var sheetManager = SheetManager()
    @State var isSharePresented = false
    
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
                TextField("Title", text: $titleValue)
                    .font(Font.headerFont(34))
                    .fontWeight(Font.Weight.medium)
                    .tracking(2)
                    .foregroundColor(.primaryWhite)
                    .padding([.top], 10)
                
                
                
                
                TextEditor(text: $contentValue)
                    .font(Font.mainFont(17))
                    .tracking(1.5)
                    .scrollContentBackground(.hidden)
                    .foregroundColor(.primaryWhite)
                    .background(Color.primaryBlcak)
                    .scrollBounceBehavior(.always)
                
                
                
                
                
                
            }
            .sheet(isPresented: $isSharePresented, onDismiss: {
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
                    HStack(spacing: 20) {
                        Circle()
                            .fill(selectedColor)
                            .frame(width: 20, height: 20)
                            .onTapGesture {
                                showColorSheet.toggle()
                            }
                        Image(systemName: "square.and.arrow.up")
                            .resizable()
                            .frame(width: 20, height: 25)
                            .foregroundColor(.primaryWhite)
                            .onTapGesture {
                                if titleValue == "" {
                                    return
                                }
                                createTxtFile()
                            }
                        
                        
                    }
                    .padding([.leading, .top], 20)
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    HStack {
                        Image(systemName: "chevron.left")
                            .resizable()
                            .frame(width: 10, height: 20)
                            .foregroundColor(.primaryWhite)
                            .simultaneousGesture(TapGesture().onEnded {
                                if titleValue == "" && contentValue == "" {
                                    presentationMode.wrappedValue.dismiss()
                                    return
                                }
                                saveNote()
                                
                            })
                        
                        
                        
                    }
                    
                }
                
                ToolbarItem(placement: .principal) {
                    Text(folderValue == "" ? "All" : folderValue)
                        .foregroundColor(.secondaryWhite)
                        .tracking(1)
                        .font(Font.mainFont(20))
                        .padding([ .top], 25)
                        .onTapGesture {
                            showFolderModal.toggle()
                        }
                        .sheet(isPresented: $showFolderModal) {
                            FolderModal(folderValue: $folderValue)
                        }
                    
                }
            }
            
        }
        .sheet(isPresented: $showColorSheet) {
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(colorSelection, id: \.self) { color in
                    Circle()
                        .fill(color)
                        .frame(width: 40, height: 40)
                        .onTapGesture {
                            selectedColor = color
                            showColorSheet.toggle()
                        }
                }
            }
            .presentationDetents([.height(150)])
            .presentationBackground(Color.primaryGray)
            
        }
        .onAppear {
            if editMode.editMode {
                if let editNote = notes.first (where: {$0.id == noteId}){
                    titleValue = editNote.wrappedTitle
                    contentValue = editNote.wrappedContents
                    folderValue = editNote.wrappedFolder
                    selectedColor = getColorValue(colorString: editNote.wrappedColor)
                    
                    
                }
                
                
            }
        }
    }
    
    private func createTxtFile() {
        let fileName = "\(titleValue).txt"
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("Documents directory not found.")
            return
        }
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        sheetManager.fileNameState = fileName
        sheetManager.fileUrlState = fileURL
        do {
            try contentValue.write(to: fileURL, atomically: true, encoding: .utf8)
            isSharePresented.toggle()
        } catch {
            print("Failed to create text file. Error: \(error)")
        }
       
    }
    
    func saveNote() {
        if editMode.editMode {
            guard let noteToEdit = notes.first(where: {$0.id == noteId}) else {return}
            
            if let index = notes.firstIndex(of: noteToEdit) {
                let editNote = notes[index]
                editNote.title = titleValue
                editNote.contents = contentValue
                editNote.folder = folderValue
                editNote.color = getColorString(color: selectedColor)
            }
            
            do {
                try moc.save()
            } catch {
                print("An error occurred: \(error)")
            }
            
            presentationMode.wrappedValue.dismiss()
            return
            
        }
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let timestamp = formatter.string(from: date)
        
        let newNote = Note(context: moc)
        newNote.id = UUID()
        newNote.title = titleValue
        newNote.timestamp = timestamp
        newNote.contents = contentValue
        newNote.folder = folderValue
        newNote.color = getColorString(color: selectedColor)
        
        do {
            try moc.save()
            presentationMode.wrappedValue.dismiss()
        } catch {
            print("An error occurred: \(error)")
        }
    }
    
    
    private func getColorString(color: Color)-> String {
        switch selectedColor {
        case .primaryOrange :
            return NoteColors.orange.rawValue
        case .primaryPurple :
            return NoteColors.purple.rawValue
        case .primaryYellow :
            return NoteColors.yellow.rawValue
        case .primaryGreen :
            return NoteColors.green.rawValue
        default:
            return NoteColors.orange.rawValue
        }
    }
    
    private func getColorValue(colorString: String)-> Color {
        switch colorString {
        case NoteColors.orange.rawValue:
            return .primaryOrange
        case NoteColors.green.rawValue:
            return .primaryGreen
        case NoteColors.purple.rawValue:
            return .primaryPurple
        case NoteColors.yellow.rawValue:
            return . primaryYellow
        default:
            return .primaryOrange
        }
    }
    
}


struct ActivityViewController: UIViewControllerRepresentable {
    var activityItems: [Any]
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
    }
}

//struct CreateNoteView_Previews: PreviewProvider {
//    static var previews: some View {
//        CreateNoteView()
//    }
//}
