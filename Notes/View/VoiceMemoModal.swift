//
//  VoiceMemoModal.swift
//  Notes
//
//  Created by Ryunosuke Yokokawa on 2023-05-05.
//

import SwiftUI
import ActivityIndicatorView

struct VoiceMemoModal: View {
    @FetchRequest(sortDescriptors: [], animation: .easeInOut) var folders: FetchedResults<Folder>
    @State private var titleValue = ""
    @State private var folder = ""
    @State private var isRecording = false
    @State private var minutes = 0
    @State private var seconds = 0
    @State var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
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
                
                
                Text("\(minutes < 10 ? "0\(minutes)" : String(minutes)):\(seconds < 10 ? "0\(seconds)" : String(seconds))")
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
                                        .stroke(Color.secondaryWhite, lineWidth: 2)
                                )
                                
                                
                                
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
        }
        
        
    }
    
  
    
}

struct VoiceMemoModal_Previews: PreviewProvider {
    static var previews: some View {
        VoiceMemoModal()
    }
}
