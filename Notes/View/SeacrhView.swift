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
                            HStack {
                                Text("Notes")
                                    .font(Font.mainFont(20))
                                    .foregroundColor(.secondaryWhite)
                                    .padding([.top, .leading], 10)
                                    .padding([.bottom], 5)
                                Spacer()
                            }
                            
                            
                            ForEach(notes) { note in
                                if note.wrappedTitle.contains(searchText) || note.wrappedContents.contains(searchText) {
                                    NavigationLink(destination: CreateNoteView(noteId: $selectedNoteId)) {
                                        SearchNoteResults(note: note)
                                        
                                    }
                                    .simultaneousGesture(TapGesture().onEnded {
                                        selectedNoteId = note.id
                                        editMode.editMode = true
                                    })
                                    
                                    Divider()
                                        .frame(height: 1)
                                        .overlay(Color.primaryGray)
                                } else {
                                    NoMachesView()
                                }
                                
                            }
                            
                            HStack {
                                Text("Recordings")
                                    .font(Font.mainFont(20))
                                    .foregroundColor(.secondaryWhite)
                                    .padding([.top, .leading], 10)
                                    .padding([.bottom], 5)
                                Spacer()
                            }
                            
                            ForEach(recordings) { recording in
                                if  recording.title != nil && recording.title!.contains(searchText)  {
                                    NavigationLink(destination: PlayAudioView(recording: recording)) {
                                        SearchRecordingResults(recording: recording)
                                        
                                    }
                                    
                                    Divider()
                                        .frame(height: 1)
                                        .overlay(Color.primaryGray)
                                    
                                } else {
                                    NoMachesView()
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

struct NoMachesView: View {
    var body: some View {
        HStack {
            Text("No matches")
                .font(Font.mainFont(15))
                .foregroundColor(.secondaryWhite)
                .padding([.top, .leading], 10)
                .padding([.bottom], 5)
            
            Spacer()
        }
    }
    
    
}

struct SearchNoteResults: View {
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

struct SearchRecordingResults: View {
    let recording: Recording
    var body: some View {
        VStack(spacing: 3) {
            Text(recording.title ?? "")
                .font(Font.mainFont(20))
                .foregroundColor(.primaryWhite)
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
                .lineLimit(1)
                .tracking(1)
            Text(recording.time ?? "")
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
