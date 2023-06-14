//
//  SeacrhView.swift
//  Notes
//
//  Created by Ryunosuke Yokokawa on 2023-05-25.
//

import SwiftUI

struct SeacrhView: View {
    @Environment(\.presentationMode) var presentationMode
    @FetchRequest(sortDescriptors: [], animation: .easeInOut) var notes: FetchedResults<Note>
    @FetchRequest(sortDescriptors: [], animation: .easeInOut) var recordings: FetchedResults<Recording>
    @EnvironmentObject var editMode: EditMode
    @State private var searchText = ""
    @State private var selectedNoteId: UUID? = nil
    
    var body: some View {
        ZStack {
            Color.primaryBlcak.ignoresSafeArea()
            
            VStack {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .resizable(resizingMode: .stretch)
                        .frame(width: 15, height: 15)
                        .foregroundColor(.primaryWhite)
                        .padding(.leading, 10)
                    
                    TextField("", text: $searchText)
                        .font(Font.mainFont(20))
                        .fontWeight(.regular)
                        .tracking(1)
                        .foregroundColor(.primaryWhite)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.gray, lineWidth: 0)
                        )
                        .padding(5)
                        .onSubmit {
                           
                        }
                    
                    
                    
                }
                .background(Color.primaryGray)
                .cornerRadius(30)
                .padding(.horizontal, 10)
                
                ScrollView {
                    if searchText != "" {
                        VStack {
                            ForEach(notes) { note in
                                if note.wrappedTitle.contains(searchText) || note.wrappedContents.contains(searchText) {
                                    NavigationLink(destination: CreateNoteView(noteId: $selectedNoteId)) {
                                        SearchResults(note: note)
                                            
                                    }
                                    .simultaneousGesture(TapGesture().onEnded {
                                        selectedNoteId = note.id
                                        editMode.editMode = true
                                    })
                                      
                                    Divider()
                                        .frame(height: 1)
                                        .overlay(Color.primaryGray)
                                }
                            }
                        }
                    }
                }
                
                
                
                
                
                
                Spacer()
            }
            .padding([.top], 10)
            
            
           
            
            
        }
        .toolbar {
            ToolbarItem (placement: .navigationBarLeading) {
                HStack {
                    Image(systemName: "chevron.left")
                        .resizable()
                        .frame(width: 10, height: 20)
                        .foregroundColor(.primaryWhite)
                        .padding([.leading, .trailing])
                       
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    print("pressed")
                    self.presentationMode.wrappedValue.dismiss()
                }
                
            }
            ToolbarItem(placement: .principal) {
                
                Text("Seacrh")
                    .font(Font.mainFont(32))
                    .tracking(4)
                    .foregroundColor(Color.primaryWhite)
                    .bold()
                
            }
        }
    }
}

struct SearchResults: View {
    let note: Note
    var body: some View {
        VStack(spacing: 3) {
            Text(note.wrappedTitle)
                .font(Font.mainFont(20))
                .foregroundColor(.primaryWhite)
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
                .lineLimit(1)
                .tracking(1)
            Text(note.wrappedContents)
                .foregroundColor(.primaryWhite)
                .frame(maxWidth: .infinity, alignment: .leading)
                .lineLimit(1)
                .tracking(0.5)
           
               
            
        }
        .padding(.trailing, 20)
        .padding(.leading, 25)
        .padding(.top, 10)
        .padding(.bottom, 3)
    }
}

//struct SeacrhView_Previews: PreviewProvider {
//    static var previews: some View {
//        SeacrhView()
//    }
//}
