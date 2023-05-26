//
//  NoteView.swift
//  Notes
//
//  Created by Ryunosuke Yokokawa on 2023-05-01.
//

import SwiftUI

struct NoteView: View {
    @State private var seactText: String = ""
    @State private var showVoiceRec = false
    @State private var selectedFolder = ""
    @EnvironmentObject private var editMode:EditMode
    @State private var selectedNoteId: UUID? = nil
    @FetchRequest(sortDescriptors: [], animation: .easeInOut) var notes: FetchedResults<Note>
    @FetchRequest(sortDescriptors: [], animation: .easeInOut) var folders: FetchedResults<Folder>
    @Environment (\.managedObjectContext) var moc
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]
    var body: some View {
        ZStack {
            Color.primaryBlcak
                .ignoresSafeArea()
            VStack(spacing: 10) {
                ScrollView(.horizontal) {
                    HStack(spacing: 12) {
                        Text("All")
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                          
                            .cornerRadius(20)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .inset(by: 2)
                                    .stroke(getFolderStrokeColor(cuurentFolder: ""), lineWidth: 2)
                            )
                            .background(Color.primaryBlcak)
                            .foregroundColor(getFolderTextColor(cuurentFolder: ""))
                            .onTapGesture {
                                selectedFolder = ""
                            }
                        ForEach(folders, id: \.self) { item in
                            Text(item.folderName ?? "")
                                .padding(.horizontal, 20)
                                .padding(.vertical, 10)
                                .cornerRadius(20)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .inset(by: 2)
                                        .stroke(getFolderStrokeColor(cuurentFolder: item.wrappedFolderNeme), lineWidth: 2)
                                )
                                .background(Color.primaryBlcak)
                                .foregroundColor(getFolderTextColor(cuurentFolder: item.wrappedFolderNeme))
                                .onTapGesture {
                                    selectedFolder = item.wrappedFolderNeme
                                }
                            
                            
                        }
                    }
                    .padding(.leading, 10)
                    
                }
                .scrollIndicators(.hidden)
                .padding(.top, 15)
                
                
                
                
                
                ScrollView {
                    if (notes.count == 0) {
                        Text("No contents")
                            .font(Font.mainFont(20))
                            .tracking(0.2)
                            .foregroundColor(.primaryWhite)
                            .padding(.top, 20)
                    } else {
                        LazyVGrid(columns: columns, spacing: 2) {
                            ForEach(getNotesInFolder(), id: \.self) {
                                note in
                                NavigationLink(destination: CreateNoteView(noteId: $selectedNoteId)) {
                                    MemoGridItem(title: note.title ?? "", content: note.contents ?? "")
                                
                                }
                                .simultaneousGesture(TapGesture().onEnded {
                                    selectedNoteId = note.id
                                    editMode.editMode = true
                                })
                            }
                            
                            
                        }
                        .padding(.bottom, 80)
                    }
                }
                .onAppear {
                    if folders.count == 0 {
                        selectedFolder = ""
                    }
                }
            }
            
            
            VStack {
                Spacer()
                HStack {
                    
                    Spacer()
                    
                    VStack {
                        NavigationLink(destination: CreateNoteView(noteId:$selectedNoteId)) {
                            Image(systemName: "square.and.pencil")
                                .resizable()
                                .foregroundColor(.primaryBlcak)
                                .frame(width: 30, height: 30)
                                .padding(2)
                                .padding()
                                .background(Color.primaryWhite)
                                .clipShape(Circle())
                                .padding(.trailing, 16)
                        }
                        .simultaneousGesture(TapGesture().onEnded {
                            editMode.editMode = false
                        })
                        
                        
                        
                        
                        
                        Image(systemName: "mic.fill")
                            .resizable()
                            .foregroundColor(.primaryBlcak)
                            .frame(width: 20, height: 30)
                            .padding(5)
                            .padding()
                            .background(Color.primaryWhite)
                            .clipShape(Circle())
                            .padding(.trailing, 16)
                            .padding(.bottom, 16)
                            .onTapGesture {
                                showVoiceRec.toggle()
                            }
                            .sheet(isPresented: $showVoiceRec) {
                                VoiceMemoModal()
                                    .presentationDetents([.height(430)])
                                
                            }
                    }
                    
                }
            }
            
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                NavigationLink(destination: SeacrhView().navigationBarBackButtonHidden(true)) {
                    Image(systemName: "magnifyingglass")
                        .resizable(resizingMode: .stretch)
                        .frame(width: 22, height: 22, alignment: .leading)
                        .foregroundColor(.secondaryWhite)
                    
                }
            }
            
            ToolbarItem(placement: .principal) {
                Text("Note")
                    .font(Font.headerFont(36))
                    .bold()
                    .tracking(5)
                    .foregroundColor(.primaryWhite)
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink(destination: FolderView().navigationBarBackButtonHidden(true)) {
                    Image(systemName: "folder.badge.plus")
                        .resizable(resizingMode: .stretch)
                        .frame(width: 30, height: 22, alignment: .trailing)
                        .foregroundColor(.secondaryWhite)
                    
                }
                
            }
            
            
        }
    }
    
    private func getNotesInFolder()-> [Note] {
        if selectedFolder == "" {
            return Array(notes)
        }
        
        return  notes.filter { note in
            note.wrappedFolder == selectedFolder
        }
    }
    
    private func getFolderStrokeColor(cuurentFolder: String)-> Color {
        selectedFolder == cuurentFolder ? .primaryOrange : .secondaryWhite
    }
    
    private func getFolderTextColor(cuurentFolder: String)-> Color {
        selectedFolder == cuurentFolder ? .primaryOrange : .primaryWhite
    }
    
}







struct MemoGridItem :View {
    let title: String
    let content : String
    
    var body: some View {
        VStack(spacing: 0) {
            Text(title)
                .font(Font.mainFont(20))
                .fontWeight(.bold)
                .tracking(0.2)
                .foregroundColor(.primaryWhite)
                .frame(height: 20, alignment: .leading)
                .padding(.top, 25)
                .padding(.leading, 10)
            
            
            
            
            Text(content)
                .font(Font.mainFont(15))
                .tracking(0.2)
                .foregroundColor(.primaryWhite)
                .frame( height: 100)
                .padding(.horizontal, 10)
                .padding(.bottom, 40)
                .padding(.top, 9)
            
            HStack {
                Spacer()
                Image(systemName: "trash")
                    .resizable()
                    .foregroundColor(Color.primaryWhite)
                    .frame(width: 25, height: 25, alignment: .trailing)
                    .padding([.trailing, .bottom], 20)
                    .onTapGesture {
                      
                    }
            }
            
            
            
            
        }
        .background(Color.primaryOrange)
        .cornerRadius(20)
        .padding(.horizontal, 5)
        .padding(.top, 5)
        
    }
    
    
}


struct VocieMemoGridItem: View {
    var body: some View {
        VStack(spacing: 0) {
            
            Text("This is the title")
                .font(Font.mainFont(20))
                .fontWeight(.bold)
                .tracking(0.2)
                .foregroundColor(.primaryWhite)
                .frame(height: 20, alignment: .leading)
                .padding(.top, 25)
                .padding(.leading, 10)
            
            
            
            
            
            Image(systemName: "waveform")
                .resizable()
                .foregroundColor(Color.primaryWhite)
                .frame(width: 90, height: 100)
                .padding(.vertical, 10)
            
            
            
            
            
            HStack {
                Spacer()
                Image(systemName: "trash")
                    .resizable()
                    .foregroundColor(Color.primaryWhite)
                    .frame(width: 25, height: 25)
                    .padding([.trailing, .bottom], 20)
            }
            
            
            
            
        }
        .background(Color.primaryPurple)
        .cornerRadius(20)
        .padding(.horizontal, 5)
        .padding(.top, 5)
        
    }
}


struct NoteView_Previews: PreviewProvider {
    static var previews: some View {
        NoteView()
    }
}
