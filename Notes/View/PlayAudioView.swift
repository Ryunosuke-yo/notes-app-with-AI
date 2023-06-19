//
//  PlayAudioView.swift
//  Notes
//
//  Created by Ryunosuke Yokokawa on 2023-06-14.
//

import SwiftUI
import ActivityIndicatorView


struct PlayAudioView: View {
    @State var titleValue = ""
    @State var selectedColor = Color.primaryOrange
    @State var showColorSheet = false
    @State var showFolderModal = false
    @State var folderValue = ""
    @State var currentFileName = ""
    //    @State var isSharePresented = false
    @State var showDeleteAlert = false
    @State var indicator = true
    @State var showFileNameAlert = false
    var recording: Recording
    @EnvironmentObject private var audioManager: AudioManager
    
    
    @Environment(\.presentationMode) var presentationMode
    @Environment (\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: [], animation: .easeInOut) var recordings: FetchedResults<Recording>
    
    
    
    var body: some View {
        ZStack {
            Color.primaryBlcak.ignoresSafeArea()
            VStack {
                Spacer()
                    .frame(height: 50)
                TextField("Title", text: $titleValue)
                    .font(Font.headerFont(34))
                    .fontWeight(Font.Weight.medium)
                    .tracking(2)
                    .foregroundColor(.primaryWhite)
                    .multilineTextAlignment(.center)
                
                
                Spacer()
                    .frame(height: 50)
                if audioManager.isPlaying {
                    ActivityIndicatorView(isVisible: $indicator, type: .equalizer(count: 7))
                        .foregroundColor(selectedColor)
                        .frame(width: 130, height: 140)
                        .padding(.top, 20)
                } else {
                    Image(systemName: "waveform")
                        .resizable()
                        .foregroundColor(selectedColor)
                        .frame(width: 130, height: 140)
                        .padding(.top, 20)
                }
                
                
                Text(recording.time ?? "")
                    .font(Font.mainFont(20))
                    .foregroundColor(.primaryWhite)
                    .padding(.top, 20)
                
                Spacer()
                    .frame(height: 20)
                
                if audioManager.isPlaying {
                    Image(systemName: "stop.circle")
                        .resizable()
                        .foregroundColor(selectedColor)
                        .frame(width: 80, height: 80)
                        .foregroundColor(.primaryWhite)
                        .padding(.top, 20)
                        .onTapGesture {
                            audioManager.stopPlaying()
                            audioManager.isPlaying.toggle()
                        }
                } else {
                    Image(systemName: "play.circle")
                        .resizable()
                        .foregroundColor(selectedColor)
                        .frame(width: 80, height: 80)
                        .foregroundColor(.primaryWhite)
                        .padding(.top, 20)
                        .onTapGesture {
                            if let url = recording.url {
                                if url.isFileURL {
                                    audioManager.startPlaying(url: url)
                                    audioManager.isPlaying.toggle()
                                }
                                
                            }
                            
                        }
                }
                Spacer()
            }
            
        }
        .onAppear {
            titleValue = recording.title ?? ""
            folderValue = recording.folder ?? ""
            selectedColor = Color.getColorValue(colorString: recording.color ?? "primaryOrange")
            currentFileName = recording.title ?? ""
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        .alert("Sure to delete?", isPresented: $showDeleteAlert) {
            Button("Delete", role: .destructive) {
                deleteRecording()
                
            }
            Button("Cancel", role:.cancel) {}
            
        }
        .alert("File name already exits", isPresented: $showFileNameAlert) {
            Button("OK", role: .cancel) {}
            
            Button("Reset file name", role: .destructive) {
                titleValue = currentFileName
            }
            .foregroundColor(.blue)
            
            
        }
        .sheet(isPresented: $showColorSheet) {
            ColorSheetModal { color in
                selectedColor = color
                showColorSheet.toggle()
            }
            .presentationDetents([.height(150)])
            .presentationBackground(Color.primaryGray)
            
        }
        //        .sheet(isPresented: $isSharePresented, onDismiss: {
        //        }, content: {
        //            if let url = recording.url {
        //                if let correctUrl = audioManager.getCorrectUrlFrom(url: url)  {
        //                    ActivityViewController(activityItems: [correctUrl])
        //                        .presentationDetents([.fraction(0.7), .large])
        //                        .ignoresSafeArea()
        //                } else {
        //                    Text("Error getting audio file")
        //                }
        //            } else {
        //                Text("Error getting audio file")
        //            }
        //        })
        
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                HStack(spacing: 25) {
                    Circle()
                        .fill(selectedColor)
                        .frame(width: 20, height: 20)
                        .onTapGesture {
                            showColorSheet = true
                        }
                    //                    Image(systemName: "square.and.arrow.up")
                    //                        .resizable()
                    //                        .frame(width: 20, height: 25)
                    //                        .foregroundColor(.primaryWhite)
                    //                        .onTapGesture {
                    //                            sheetManager.fileUrlState = recording.url
                    //                            isSharePresented = true
                    //                        }
                    
                    Image(systemName:  "trash")
                        .resizable()
                        .frame(width: 20, height: 23)
                        .foregroundColor(.recordRed)
                        .onTapGesture {
                            showDeleteAlert = true
                        }
                    
                    
                }
            }
            
            ToolbarItem(placement: .navigationBarLeading) {
                HStack {
                    Image(systemName: "chevron.left")
                        .resizable()
                        .frame(width: 10, height: 20)
                        .foregroundColor(.primaryWhite)
                        .padding([.leading, .trailing])
                    
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    if audioManager.isPlaying {
                        audioManager.stopPlaying()
                        audioManager.isPlaying.toggle()
                    }
                    updateRecording()
                   
                    
                    
                }
            }
            
            ToolbarItem(placement: .principal) {
                Text(folderValue == "" ? "All" : folderValue)
                    .foregroundColor(.secondaryWhite)
                    .tracking(1)
                    .font(Font.mainFont(20))
                    .onTapGesture {
                        showFolderModal.toggle()
                    }
                    .sheet(isPresented: $showFolderModal) {
                        FolderModal(folderValue: $folderValue)
                    }
                
            }
        }
    }
    
    func updateRecording() {
        if let index = recordings.firstIndex(of: recording) {
            let recordingToEdit = recordings[index]
            if titleValue != currentFileName {
                if let url = recording.url  {
                    if audioManager.fileNameExtits(fileName: "\(titleValue).m4a") {
                        showFileNameAlert = true
                        return
                    } else {
                        if let correctUrl = audioManager.getCorrectUrlFrom(url: url) {
                            print("updated")
                            if let newUrl =  audioManager.updateFileName(url: correctUrl, newFileName: "\(titleValue).m4a") {
                                recordingToEdit.url = newUrl
                            }
                            
                        }
                    }
                    
                }
                
                
            }
            
           
            
            if recordingToEdit.title != titleValue {
                recordingToEdit.title = titleValue
            }
            

            
            if recordingToEdit.color !=  Color.getColorString(color: selectedColor) {
                recordingToEdit.color = Color.getColorString(color: selectedColor)
            }
            
            if recordingToEdit.folder != folderValue {
                recordingToEdit.folder = folderValue
            }
            presentationMode.wrappedValue.dismiss()
            
            saveContext()
        }
        
        
        
    }
    
    func deleteRecording() {
        if let removeUrl = recording.url {
            audioManager.deleteRecordingFromDirectory(url: removeUrl) {
                moc.delete(recording)
                saveContext()
                presentationMode.wrappedValue.dismiss()
            }
        } else {
            print("coundn")
        }
    }
    
    
    func saveContext() {
        do {
            try moc.save()
        } catch {
            print("An error occurred: \(error)")
        }
    }
}

//struct PlayAudioView_Previews: PreviewProvider {
//    static var previews: some View {
//        PlayAudioView()
//    }
//}
