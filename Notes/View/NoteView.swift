//
//  NoteView.swift
//  Notes
//
//  Created by Ryunosuke Yokokawa on 2023-05-01.
//

import SwiftUI

struct NoteView: View {
    @State private var text: String = ""
    @State private var showVoiceRec = false
    @FetchRequest(sortDescriptors: [], animation: .easeInOut) var notes: FetchedResults<Note>
    @Environment (\.managedObjectContext) var moc
    
    
    
    
    let data = ["All", "Daily", "Work", "Item 4", "Item 5"]
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]
    var body: some View {
        ZStack {
            Color.primaryBlcak
                .ignoresSafeArea()
            VStack(spacing: 10) {
                HStack(spacing: 0) {
                    Rectangle()
                        .frame(width: 30, height: 22)
                        .padding(.leading, 15)
                        .foregroundColor(Color.primaryBlcak)
                    Text("Note")
                        .font(Font.mainFont(36))
                        .bold()
                        .tracking(5)
                        .foregroundColor(.primaryWhite)
                        .frame(maxWidth: .infinity, alignment: .center)
                    
                    NavigationLink(destination: FolderView().navigationBarBackButtonHidden(true)) {
                        Image(systemName: "folder.badge.plus")
                            .resizable(resizingMode: .stretch)
                            .frame(width: 30, height: 22, alignment: .trailing)
                            .foregroundColor(.secondaryWhite)
                            .padding(.trailing, 15)
                    }
                    
                    
                    
                }
                
                
                
                HStack {
                    Image(systemName: "magnifyingglass")
                        .resizable(resizingMode: .stretch)
                        .frame(width: 15, height: 15)
                        .foregroundColor(.primaryWhite)
                        .padding(.leading, 10)
                    
                    TextField("", text: $text)
                        .font(Font.mainFont(20))
                        .fontWeight(.regular)
                        .tracking(1)
                        .foregroundColor(.primaryWhite)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.gray, lineWidth: 0)
                        )
                        .padding(5)
                    
                    
                    
                }
                .background(Color.primaryGray)
                .cornerRadius(30)
                .padding(.horizontal, 10)
                
                ScrollView(.horizontal) {
                    HStack(spacing: 12) {
                        ForEach(data, id: \.self) { item in
                            Text(item)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 10)
                                .cornerRadius(20)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .inset(by: 2)
                                        .stroke(Color.secondaryWhite, lineWidth: 2)
                                )
                                .background(Color.primaryBlcak)
                                .foregroundColor(.primaryWhite)
                            
                            
                        }
                    }
                    
                }
                .scrollIndicators(.hidden)
                .padding(.top, 5)
                
                
                
                
                ScrollView {
                    if (notes.count == 0) {
                        Text("No contents")
                            .font(Font.mainFont(20))
                            .tracking(0.2)
                            .foregroundColor(.primaryWhite)
                            .padding(.top, 20)
                    } else {
                        LazyVGrid(columns: columns, spacing: 2) {
                            ForEach(notes, id: \.self) {
                                note in
                                MemoGridItem(title: note.title ?? "", content: note.contents ?? "") {
                                    moc.delete(note)
                                }
                            }
                        }
                        .padding(.bottom, 80)
                    }
                    
                    
                }                
            }
            
            VStack {
                
                Spacer()
                HStack {
                    
                    Spacer()
                    
                    VStack {
                        NavigationLink(destination: CreateNoteView()) {
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
        
    }
    
    
}


struct MemoGridItem :View {
    let title: String
    let content : String
    let deleteNote : (()-> Void)
    
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
                        deleteNote()
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
