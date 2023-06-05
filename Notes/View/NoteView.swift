//
//  NoteView.swift
//  Notes
//
//  Created by Ryunosuke Yokokawa on 2023-05-01.
//
import AudioKit
import SwiftUI
import AVKit

struct NoteView: View {
    @State private var seactText: String = ""
    @State private var showVoiceRec = false
    @State private var selectedFolder = ""
    @EnvironmentObject private var editMode:EditMode
    @State private var selectedNoteId: UUID? = nil
    @State private var recordings: [URL] = []
    
    @FetchRequest(sortDescriptors: [], animation: .easeInOut) var notes: FetchedResults<Note>
    @FetchRequest(sortDescriptors: [], animation: .easeInOut) var folders: FetchedResults<Folder>
    @Environment (\.managedObjectContext) var moc
    
    
    @State var isRecording = false
    @State var session: AVAudioSession!
    @State var recorder :AVAudioRecorder!
    @State var audioPlayer: AVPlayer!
    let audioEngine = AVAudioEngine()
    let audioPlayerNode = AVAudioPlayerNode()
    
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
                
                Text(isRecording ? "true" : "false")
                
                //                Button {
                //                    do {
                //                        if isRecording {
                //                            recorder.stop()
                //                            isRecording.toggle()
                //                            return
                //                        }
                //                        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                //                        let fileName = url.appendingPathComponent("myRec\(recordings.count + 1).m4a")
                //                        let settings = [
                //                            AVFormatIDKey: Int(kAudioFormatLinearPCM),
                //                            AVLinearPCMBitDepthKey: 24,
                //                            AVSampleRateKey: 48000,
                //                            AVNumberOfChannelsKey: 2,
                //                            AVEncoderBitRateKey: 128000,
                //                            AVEncoderAudioQualityKey: AVAudioQuality.max.rawValue]
                //                        recorder = try AVAudioRecorder(url: fileName, settings: settings)
                //                        recorder.record()
                //                        isRecording.toggle()
                //                        getRecordings()
                //                    } catch {
                //                        print(error.localizedDescription, "when record")
                //                    }
                //                } label: {
                //                    Text("start")
                //                }
                
                //                Text(String(recordings.count))
                //                    .foregroundColor(.white)
                //
                //                if recordings.count == 0 {
                //                    Text("zero")
                //                        .foregroundColor(.white)
                //                } else {
                //                                        List(recordings, id: \.self) { rec in
                //                                            Text(rec.relativeString)
                //                                                .foregroundColor(.white)
                //                                                .onTapGesture {
                //                                                }
                //
                //                                        }
                //
                //                }
                
             
                
                
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
                                    .presentationDetents([.height(430), .large])
                                
                            }
                    }
                    
                }
            }
            
        }
        .onAppear {
            do {
                self.session = AVAudioSession.sharedInstance()
                try self.session.setCategory(.playAndRecord)
                
                
                self.session.requestRecordPermission {
                    status in
                    if !status {
                        print("permisiion denied")
                    } else {
                        getRecordings()
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
    
    func getRecordings() {
        do {
            let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let results = try FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: nil, options: .producesRelativePathURLs)
            
            recordings.removeAll()
            
            for rec in results {
                recordings.append(rec)
            }
        } catch {
            print(error.localizedDescription, "when getting recordings")
        }
    }
    
    func playRecordedAudio(url: URL) {
        let playerItem = AVPlayerItem(url: url)
        
        audioPlayer = AVPlayer(playerItem: playerItem)
        audioPlayer.volume = 1.0
        audioPlayer?.play()
        
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
        .background(convertNoteColorString(colorString: noteColorString))
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
    
    private func convertNoteColorString(colorString: String)-> Color {
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


//struct NoteView_Previews: PreviewProvider {
//    static var previews: some View {
//        NoteView()
//    }
//}
