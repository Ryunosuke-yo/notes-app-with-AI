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
    @State var titleValue = ""
    @State var contentValue = ""
    @State var showFolderModal = false
    @State var folderValue = ""
    @Binding var noteId: UUID?
    var body: some View {
        ZStack {
            Color.primaryBlcak.ignoresSafeArea()
            VStack {
                TextField("Title", text: $titleValue)
                    .font(Font.mainFont(38))
                    .fontWeight(Font.Weight.medium)
                    .tracking(2)
                    .foregroundColor(.primaryWhite)
                    .padding([.top], 10)
                
                
                
                
                TextEditor(text: $contentValue)
                    .font(Font.mainFont(26))
                    .tracking(1.5)
                    .scrollContentBackground(.hidden)
                    .foregroundColor(.primaryWhite)
                    .background(Color.primaryBlcak)
                    .scrollBounceBehavior(.always)
                
                
                
                
                
                
            }
            .padding([.trailing, .leading], 20)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack(spacing: 20) {
                        
                        
                        Image(systemName: "square.and.arrow.up")
                            .resizable()
                            .frame(width: 20, height: 25)
                            .foregroundColor(.primaryWhite)
                        
                        Image(systemName: "folder")
                            .resizable()
                            .frame(width: 25, height: 25)
                            .foregroundColor(.primaryWhite)
                            .onTapGesture {
                                showFolderModal.toggle()
                                
                            }
                            .sheet(isPresented: $showFolderModal) {
                                
                                FolderModal(folderValue: $folderValue)
                            }
                        
                        
                        Text("Done")
                            .font(Font.mainFont(20))
                            .foregroundColor(.primaryWhite)
                            .onTapGesture {
                                saveNote()
                            }
                    }
                    .padding([.leading, .top], 20)
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Image(systemName: "chevron.left")
                        .resizable()
                        .frame(width: 10, height: 20)
                        .foregroundColor(.primaryWhite)
                        .onTapGesture {
                            print("pressed")
                            self.presentationMode.wrappedValue.dismiss()
                        }
                }
            }
            
        }
        .onAppear {
            if editMode.editMode {
                if let editNote = notes.first (where: {$0.id == noteId}){
                    titleValue = editNote.wrappedTitle
                    contentValue = editNote.wrappedContents
                }
                
                
            }
        }
    }
    
    func saveNote() {
        
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
        
        
        do {
            try moc.save()
            presentationMode.wrappedValue.dismiss()
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
