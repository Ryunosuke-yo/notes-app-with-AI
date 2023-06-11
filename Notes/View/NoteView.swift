//
//  NoteView.swift
//  Notes
//
//  Created by Ryunosuke Yokokawa on 2023-05-01.
//


import SwiftUI
import AVKit
import ActivityIndicatorView

struct NoteView: View {
    @State private var seactText: String = ""
    @State private var showVoiceRec = false
    @State private var selectedFolder: Folder?
    @EnvironmentObject private var editMode:EditMode
    @State private var selectedNoteId: UUID? = nil
    @State private var isPlaying = false
    @State private var isNoteMode = true
    @State private var appMode: AppMode = .noteMode
    
    @FetchRequest(sortDescriptors: [], animation: .easeInOut) var notes: FetchedResults<Note>
    @FetchRequest(sortDescriptors: [], animation: .easeInOut) var folders: FetchedResults<Folder>
    @FetchRequest(sortDescriptors: [], animation: .easeInOut) var recordings: FetchedResults<Recording>
    @Environment (\.managedObjectContext) var moc
    
    @State var session: AVAudioSession!
    @State var recorder :AVAudioRecorder!
    @State var audioPlayer: AVAudioPlayer!
    
    
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
                                VocieMemoGridItem(voiceMemo: recording) {
                                    if let url = recording.url {
                                        if isPlaying == true {
                                            pauseRecording()
                                            isPlaying = false
                                        } else {
                                            playRecordedAudio(url: url)
                                            isPlaying = true
                                        }
                                        
                                    }
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
                                    .presentationDetents([.height(450), .large])
                                
                            }
                    }
                    
                }
            }
            
        }
        .onAppear {
            do {
                self.session = AVAudioSession.sharedInstance()
                try self.session.setCategory(.playAndRecord, options: .defaultToSpeaker)
                
                
                self.session.requestRecordPermission {
                    status in
                    if !status {
                        print("permisiion denied")
                    }
                }
            } catch {
                print(error.localizedDescription, "when setting audio session")
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
    
    func playRecordedAudio(url: URL) {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer.volume = 1.0
            audioPlayer.play()
        } catch {
            print(error.localizedDescription, "play")
        }
    }
    
    func pauseRecording() {
        //        do {
        //            audioPlayer = try AVAudioPlayer(contentsOf: url)
        //            audioPlayer.pause()
        //        } catch {
        //            print(error.localizedDescription, "play")
        //        }
        
        audioPlayer.pause()
        
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
    let onTapRecording: ()-> Void
    @State var thisIsPlaying = false
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
                
                Text(voiceMemo.time ?? "Error")
                    .font(Font.mainFont(13))
                    .tracking(0.3)
                    .foregroundColor(.primaryWhite)
                    .padding([.top], 5)
                
                
                ActivityIndicatorView(isVisible: $thisIsPlaying, type: .equalizer(count: 7))
                    .frame(width: 90, height: 100)
                    .foregroundColor(.primaryWhite)
                    .padding(.top, 20)
                
                if thisIsPlaying == false {
                    Image(systemName: "waveform")
                        .resizable()
                        .foregroundColor(Color.primaryWhite)
                        .frame(width: 90, height: 100)
                        .padding(.vertical, 10)
                }
            }
            .onTapGesture {
                onTapRecording()
                thisIsPlaying.toggle()
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
        moc.delete(recording)
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


//struct NoteView_Previews: PreviewProvider {
//    static var previews: some View {
//        NoteView()
//    }
//}
