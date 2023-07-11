//
//  VoiceMemoModal.swift
//  Notes
//
//  Created by Ryunosuke Yokokawa on 2023-05-05.
//

import SwiftUI

import AVKit
import ActivityIndicatorView

struct VoiceMemoModal: View {
    @FetchRequest(sortDescriptors: [], animation: .easeInOut) var folders: FetchedResults<Folder>
    @FetchRequest(sortDescriptors: [], animation: .easeInOut) var recordings: FetchedResults<Recording>
    @StateObject var viewModel = VoiceMemoModalViewModel()
    @Binding var isPresented:Bool
    @Environment (\.managedObjectContext) var moc
    @EnvironmentObject private var audioManager: AudioManager
    
    let colorSelection: [Color] = [
        .primaryGreen,
        .primaryOrange,
        .primaryPurple,
        .primaryYellow,
    ]
    
    var body: some View {
        let timeString = "\(viewModel.minutes < 10 ? "0\(viewModel.minutes)" : String(viewModel.minutes)):\(viewModel.seconds < 10 ? "0\(viewModel.seconds)" : String(viewModel.seconds))"
        let title = viewModel.titleValue == "" ? "New Vocie memo\(recordings.count + 1)" : viewModel.titleValue
        ZStack {
            Color.primaryGray.ignoresSafeArea()
            VStack(spacing: 0) {
                HStack {
                    Spacer()
                    TextField("", text: $viewModel.titleValue)
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
                    .onReceive(viewModel.timer) { _ in
                        if viewModel.isRecording {
                            viewModel.seconds += 1
                            if viewModel.seconds == 60 {
                                viewModel.seconds = 0
                                viewModel.minutes += 1
                            }
                        }
                    }
                
                ActivityIndicatorView(isVisible: $viewModel.isRecording, type: .equalizer(count: 7))
                    .frame(width: 80, height: 90)
                    .foregroundColor(.primaryWhite)
                    .padding(.top, 20)
                
                if !viewModel.isRecording {
                    Image(systemName: "waveform")
                        .resizable()
                        .frame(width: 80, height: 90)
                        .foregroundColor(.primaryWhite)
                        .padding(.top, 20)
                }
                
                
                
                Circle()
                    .foregroundColor(viewModel.isRecording ?  .recordRed : .secondaryWhite)
                    .frame(width: 90, height: 90)
                    .padding(.top, 20)
                    .onTapGesture {
                        if viewModel.isRecording {
                            audioManager.stopRecording()
                            
                        } else {
                            audioManager.startRecording(title: title)
                            viewModel.recodingComplted = true
                            viewModel.fileName = "\(title).m4a"
                        }
                        viewModel.isRecording.toggle()
                        
                    }
                
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(colorSelection, id: \.self) { color in
                            Circle()
                                .fill(color)
                                .frame(width: 40, height: 40)
                                .onTapGesture {
                                    viewModel.selectedColor = color
                                }
                                .background {
                                    if viewModel.selectedColor == color {
                                        Circle()
                                            .foregroundColor(.primaryWhite)
                                            .frame(width: 44, height: 44)
                                    }
                                }
                        }
                        .padding(.leading, 10)
                        .padding(.bottom, 5)
                    }
                    .padding(.leading, 5)
                    .padding(.top, 15)
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
                                    viewModel.selectedFolder = folder
                                }
                            }
                        }
                        
                    }
                    .scrollIndicators(.hidden)
                    .padding(.top, 20)
                    .padding(.leading, 10)
                    .padding(.bottom, 10)
                    
                    
                }
                
                
                Spacer()
            }
            .padding(.top, 20)
            
        }
        .onDisappear {
            saveAudiofile(timeString: timeString)
        }
        .alert("File name already exits", isPresented: $viewModel.showFilenameAlert) {
            Button("cencel", role: .cancel) {
            
            }
           
            
        }
        
        
    }
    
    
    func saveAudiofile(timeString: String) {
        if viewModel.isRecording == true {
            audioManager.stopRecording()
        }
        if viewModel.fileName != viewModel.titleValue  {
            if audioManager.fileNameExtits(fileName: viewModel.fileName) {
                viewModel.showFilenameAlert = true
                return
            } else {
                if let url = audioManager.fileUrl {
                    if let coorectUrl = audioManager.getCorrectUrlFrom(url: url) {
                        audioManager.fileUrl = audioManager.updateFileName(url: coorectUrl, newFileName: "\(UUID())_\(viewModel.titleValue)")
                    }

                }

            }

        }
        if viewModel.recodingComplted {
            saveRecording(timeString: timeString)

        }
        viewModel.isRecording = false
        isPresented = false
    }
    
    func getStrokeColor(item: Folder)-> Color {
        if let sFolder = viewModel.selectedFolder {
            return sFolder == item ? .primaryOrange : .secondaryWhite
        }
        
        
        return .secondaryWhite
    }
    
    
    
    
    func saveRecording(timeString: String) {
        let title = viewModel.titleValue == "" ? "New Vocie memo\(recordings.count + 1)" : viewModel.titleValue
        let newRecoding = Recording(context: moc)
        newRecoding.title = title
        newRecoding.folder = "folder"
        newRecoding.url = audioManager.fileUrl
        newRecoding.id = UUID()
        newRecoding.folder = viewModel.selectedFolder == nil ? "" : viewModel.selectedFolder?.wrappedFolderNeme
        newRecoding.time = timeString
        newRecoding.color = Color.getColorString(color:viewModel.selectedColor)
        newRecoding.date = Date()
        newRecoding.timestamp = Date().timeIntervalSince1970
        
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
