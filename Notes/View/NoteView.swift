//
//  NoteView.swift
//  Notes
//
//  Created by Ryunosuke Yokokawa on 2023-05-01.
//


import SwiftUI
import AVKit


struct NoteView: View {
    @State private var seactText: String = ""
    @State private var showVoiceRec = false
    @State private var selectedFolder: Folder?
    @EnvironmentObject private var editMode:EditMode
    @State private var selectedNoteId: UUID? = nil
    @State private var isNoteMode = true
    @State private var appMode: AppMode = .noteMode
    @EnvironmentObject private var audioManager: AudioManager
    
    @State var audios: [URL] = []
    
    
    @FetchRequest(sortDescriptors: [SortDescriptor(\.date, order: .reverse)], animation: .easeInOut) var notes: FetchedResults<Note>
    @FetchRequest(sortDescriptors: [], animation: .easeInOut) var folders: FetchedResults<Folder>
    @FetchRequest(sortDescriptors: [SortDescriptor(\.date, order: .reverse)], animation: .easeInOut) var recordings: FetchedResults<Recording>
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
                HStack {
                    Spacer()
                    
                    Image(systemName: "doc")
                        .resizable()
                        .foregroundColor(appMode == .noteMode ? .primaryOrange : .secondaryWhite)
                        .frame(width: 17, height: 20)
                        .onTapGesture {
                            appMode = .noteMode
                        }
                    
                    
                    Spacer()
                    Divider()
                        .overlay(Color.secondaryWhite)
                        .frame(height: 10)
                    Spacer()
                    
                    Image(systemName: "mic.circle")
                        .resizable()
                        .foregroundColor(appMode == .voiceMemo ? .primaryOrange : .secondaryWhite)
                        .frame(width: 20, height: 20)
                        .onTapGesture {
                            appMode = .voiceMemo
                        }
                    Spacer()
                    
                }
                .padding([.top], 15)
                
                ScrollView(.horizontal) {
                    HStack(spacing: 12) {
                        Text("All")
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .cornerRadius(20)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .inset(by: 2)
                                    .stroke(selectedFolder == nil ? Color.primaryOrange : Color.secondaryWhite, lineWidth: 2)
                            )
                            .background(Color.primaryBlcak)
                            .foregroundColor(selectedFolder == nil ? Color.primaryOrange : Color.secondaryWhite)
                            .onTapGesture {
                                selectedFolder = nil
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
                                    selectedFolder = item
                                }
                            
                            
                        }
                    }
                    .padding(.leading, 10)
                    
                }
                .scrollIndicators(.hidden)
                .padding(.top, 10)
                
                
                ScrollView {
                    if appMode == .noteMode {
                        if (notes.count == 0) {
                            Text("No contents")
                                .font(Font.mainFont(20))
                                .tracking(0.2)
                                .foregroundColor(.primaryWhite)
                                .padding(.top, 20)
                        } else {
                            LazyVGrid(columns: columns, spacing: 2) {
                                ForEach(getNotesInFolder() ?? [], id: \.self) {
                                    note in
                                    NavigationLink(destination: CreateNoteView(noteId: $selectedNoteId)) {
                                        MemoGridItem(note: note)
                                        
                                    }
                                    .simultaneousGesture(TapGesture().onEnded {
                                        selectedNoteId = note.id
                                        editMode.editMode = true
                                        
                                    })
                                    
                                }
                                
                                
                            }
                            .padding(.bottom, 80)
                        }
                    } else {
                        LazyVGrid(columns: columns, spacing: 2) {
                            ForEach(getRecordingsInFolder() ?? []) { recording in
                                NavigationLink(destination: PlayAudioView(recording: recording)) {
                                    VocieMemoGridItem(voiceMemo: recording)
                                }


                            }
                        }
                    }
                    
                }
                .onAppear {
                    if folders.count == 0 {
                        selectedFolder = nil
                    }
                }
//
//                if appMode == .voiceMemo {
//                    List(audios, id: \.self) { audio in
//                        Text( audio.absoluteString)
//                            .foregroundColor(.primaryWhite)
//                            .onTapGesture {
//                                if audioManager.isPlaying {
//                                    audioManager.stopPlaying()
//                                } else {
//                                    audioManager.startPlaying(url: audio)
//                                }
//                            }
//                    }
//                }
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
                                VoiceMemoModal(isPresented: $showVoiceRec)
                                    .presentationDetents([.height(450), .large])

                            }
                            
                          
                    }
                    
                }
            }
            
        }
        .onAppear {
            audioManager.requestPermissionAndSetUp()
//            let  files = audioManager.getAuidos()
            
            
            // reset all audios
//            for file in files {
//                audios.append(file.absoluteURL)
//                do {
//                    try FileManager.default.removeItem(at: file)
//                } catch {
//                    print("error")
//                }

            }

//            for recording in recordings {
//                moc.delete(recording)
//            }
//
//            do {
//                try moc.save()
//            } catch {
//                print(error.localizedDescription, "when saving context")
//            }
//
            
//        }
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
    
    
    private func getNotesInFolder()-> [Note]? {
        if selectedFolder == nil {
            return Array(notes)
        }
        
        if let s = selectedFolder {
            return  notes.filter { note in
                note.wrappedFolder == s.wrappedFolderNeme
            }
        }
        
        return nil
    }
    
    private func getRecordingsInFolder()-> [Recording]? {
        if selectedFolder == nil {
            return Array(recordings)
        }
        
        if let s = selectedFolder {
            return  recordings.filter { recording in
                recording.folder == s.wrappedFolderNeme
            }
        }
        
        return nil
    }
    
    private func getFolderStrokeColor(cuurentFolder: String)-> Color {
        if let s = selectedFolder {
            return s.wrappedFolderNeme == cuurentFolder ? .primaryOrange : .secondaryWhite
        }
        return .secondaryWhite
    }
    
    private func getFolderTextColor(cuurentFolder: String)-> Color {
        if let s = selectedFolder {
            return s.wrappedFolderNeme == cuurentFolder ? .primaryOrange : .primaryWhite
        }
        return .primaryWhite
    }
}







struct MemoGridItem :View {
    @State var showDeleteAlert = false
    let note: Note
    @FetchRequest(sortDescriptors: [], animation: .easeInOut) var notes: FetchedResults<Note>
    @Environment (\.managedObjectContext) var moc
    
    
    var body: some View {
        let title = note.wrappedTitle
        let content = note.wrappedContents
        let noteColorString = note.wrappedColor
        
        
        
        VStack(spacing: 0) {
            Text(title)
                .font(Font.mainFont(20))
                .fontWeight(.bold)
                .tracking(0.2)
                .foregroundColor(.primaryWhite)
                .padding([.top, .bottom], 10)
                .padding([.leading, .trailing], 5)
                .lineLimit(1)
            
            
            
            
            VStack {
                Text(content)
                    .font(Font.mainFont(13))
                    .tracking(0.2)
                    .foregroundColor(.primaryWhite)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .multilineTextAlignment(.leading)
                    .padding([.leading, .trailing], 15)
                
                Spacer()
            }
            .frame(height: 140)
            
            HStack {
                Spacer()
                Image(systemName: "trash")
                    .resizable()
                    .foregroundColor(Color.primaryWhite)
                    .frame(width: 25, height: 25, alignment: .trailing)
                    .padding([.trailing, .bottom], 20)
                    .onTapGesture {
                        showDeleteAlert = true
                    }
            }
            
            
        }
        .background(Color.convertNoteColorString(colorString: noteColorString))
        .cornerRadius(20)
        .padding(.horizontal, 5)
        .padding(.top, 5)
        .alert("Sure to delete?", isPresented: $showDeleteAlert) {
            Button("delete", role: .destructive) {
                deleteNote(note)
            }
            Button("Cancel", role:.cancel) {}
            
        }
        
    }
    
    private func deleteNote(_ note: Note) {
        moc.delete(note)
        saveContext()
    }
    
    private func saveContext() {
        do {
            try moc.save()
        } catch {
            print(error.localizedDescription, "when saving context")
        }
    }
    
    
}


struct VocieMemoGridItem: View {
    @State var showDeleteAlert = false
    let voiceMemo: Recording
    @State var isPlaying = false
    
    @EnvironmentObject private var audioManager: AudioManager
    @Environment (\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: [], animation: .easeInOut) var recordings: FetchedResults<Recording>
    var body: some View {
        VStack(spacing: 0) {
            VStack {
                Text(voiceMemo.title ?? "Unknown")
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
                
                Text(voiceMemo.time ?? "Error")
                    .font(Font.mainFont(13))
                    .tracking(0.3)
                    .foregroundColor(.primaryWhite)
                    .padding([.top], 5)
                
            }
            HStack {
                Spacer()
                Image(systemName: "trash")
                    .resizable()
                    .foregroundColor(Color.primaryWhite)
                    .frame(width: 25, height: 25)
                    .padding([.trailing, .bottom], 20)
                    .onTapGesture {
                        showDeleteAlert = true
                    }
                    .alert("Sure to delete?", isPresented: $showDeleteAlert) {
                        Button("delete", role: .destructive) {
                            deleteRecording(recording: voiceMemo
                            )
                        }
                        Button("Cancel", role:.cancel) {}
                        
                    }
            }
            
            
            
            
        }
        .background(Color.getColorValue(colorString: voiceMemo.color ?? "primaryOrange"))
        .cornerRadius(20)
        .padding(.horizontal, 5)
        .padding(.top, 5)
        
        
    }
    
    
    
    private func deleteRecording(recording: Recording) {
        if let removeUrl = recording.url {
            audioManager.deleteRecordingFromDirectory(url: removeUrl) {
                moc.delete(recording)
                saveContext()
            }
            
        }
    }
    
    private func saveContext() {
        do {
            try moc.save()
        } catch {
            print(error.localizedDescription, "when saving context")
        }
    }
}


//struct NoteView_Previews: PreviewProvider {
//    static var previews: some View {
//        NoteView()
//    }
//}
