//
//  VoiceMemoModal.swift
//  Notes
//
//  Created by Ryunosuke Yokokawa on 2023-05-05.
//

import SwiftUI
import ActivityIndicatorView
import AVKit

struct VoiceMemoModal: View {
    @FetchRequest(sortDescriptors: [], animation: .easeInOut) var folders: FetchedResults<Folder>
    @FetchRequest(sortDescriptors: [], animation: .easeInOut) var recordings: FetchedResults<Recording>
    @State private var titleValue = ""
    @State private var folder = ""
    @State private var minutes = 0
    @State private var seconds = 0
    @State private var fileUrl: URL?
    @State private var selectedFolder: Folder?
    @State private var recodingComplted = false
    @State var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @Environment (\.managedObjectContext) var moc
    
    
    @State private var isRecording = false
    @State var session: AVAudioSession!
    @State var recorder :AVAudioRecorder!
    @State var audioPlayer: AVPlayer!
    
    var body: some View {
        let timeString = "\(minutes < 10 ? "0\(minutes)" : String(minutes)):\(seconds < 10 ? "0\(seconds)" : String(seconds))"
        ZStack {
            Color.primaryGray.ignoresSafeArea()
            VStack(spacing: 0) {
                HStack {
                    Spacer()
                    TextField("New Voice Memo", text: $titleValue)
                        .font(Font.mainFont(30))
                        .foregroundColor(.primaryWhite)
                        .tracking(1)
                        .bold()
                        .frame(width: UIScreen.screenWidth - 30)
                        .multilineTextAlignment(TextAlignment.center)
                    Spacer()
                }
                
                
                Text(timeString)
                    .font(Font.mainFont(18))
                    .foregroundColor(.primaryWhite)
                    .tracking(1)
                    .padding(.top, 10)
                    .onReceive(timer) { _ in
                        if isRecording {
                            seconds += 1
                            if seconds == 60 {
                                seconds = 0
                                minutes += 1
                            }
                        }
                    }
                
                ActivityIndicatorView(isVisible: $isRecording, type: .equalizer(count: 7))
                    .frame(width: 80, height: 90)
                    .foregroundColor(.primaryWhite)
                    .padding(.top, 20)
                
                if !isRecording {
                    Image(systemName: "waveform")
                        .resizable()
                        .frame(width: 80, height: 90)
                        .foregroundColor(.primaryWhite)
                        .padding(.top, 20)
                }
                
                
                
                Circle()
                    .foregroundColor(isRecording ?  .recordRed : .secondaryWhite)
                    .frame(width: 90, height: 90)
                    .padding(.top, 20)
                    .onTapGesture {
                        
                        if isRecording {
                            recorder.stop()
                        } else {
                            startRecording()
                        }
                        isRecording.toggle()
                        
                    }
                
                
                if folders.count == 0 {
                    Text("No folders")
                        .foregroundColor(.primaryWhite)
                        .font(Font.mainFont(16))
                        .padding(.top, 30)
                } else {
                    ScrollView(.horizontal) {
                        HStack(spacing: 12) {
                            ForEach(folders, id: \.self) { folder in
                                HStack {
                                    Image(systemName: "plus.circle")
                                        .resizable()
                                        .foregroundColor(.primaryOrange)
                                        .frame(width: 18,height: 18)
                                    Text(folder.wrappedFolderNeme)
                                    
                                        .foregroundColor(.primaryWhite)
                                }
                                .padding(.horizontal, 20)
                                .padding(.vertical, 10)
                                .cornerRadius(20)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .inset(by: 2)
                                        .stroke(getStrokeColor(item: folder), lineWidth: 2)
                                )
                                .onTapGesture {
                                    selectedFolder = folder
                                }
                            }
                        }
                        
                    }
                    .scrollIndicators(.hidden)
                    .padding(.top, 30)
                    .padding(.leading, 10)
                    .padding(.bottom, 25)
                    Spacer()
                    
                }
            }
            .padding(.top, 20)
            
        }
        .onDisappear {
            isRecording = false
            if recodingComplted {
                saveRecording(timeString: timeString)
                
            }
            
        }
        
        
    }
    
    func getStrokeColor(item: Folder)-> Color {
        if let sFolder = selectedFolder {
            return sFolder == item ? .primaryOrange : .secondaryWhite
        }
        
        
        return .secondaryWhite
    }
    
    
    private func startRecording() {
        do {
            let title = titleValue == "" ? "New Vocie memo\(recordings.count + 1)" : titleValue
            let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fileName = url.appendingPathComponent("\(title).m4a")
            fileUrl = fileName
            let settings = [
                AVFormatIDKey: Int(kAudioFormatLinearPCM),
                AVLinearPCMBitDepthKey: 24,
                AVSampleRateKey: 48000,
                AVNumberOfChannelsKey: 2,
                AVEncoderBitRateKey: 128000,
                AVEncoderAudioQualityKey: AVAudioQuality.max.rawValue]
            recorder = try AVAudioRecorder(url: fileName, settings: settings)
            recorder.record()
            recodingComplted = true
        } catch {
            print(error.localizedDescription, "when record")
        }
    }
    
    
    func saveRecording(timeString: String) {
        let title = titleValue == "" ? "New Vocie memo\(recordings.count + 1)" : titleValue
        let newRecoding = Recording(context: moc)
        newRecoding.title = title
        newRecoding.folder = "folder"
        newRecoding.url = fileUrl
        newRecoding.id = UUID()
        newRecoding.folder = selectedFolder == nil ? "" : selectedFolder?.wrappedFolderNeme
        newRecoding.time = timeString
        
        do {
            try moc.save()
        } catch {
            print(error.localizedDescription, "save recroding")
        }
        
    }
    
    
    
}

//struct VoiceMemoModal_Previews: PreviewProvider {
//    static var previews: some View {
//        VoiceMemoModal()
//    }
//}
