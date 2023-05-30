//
//  VoiceMemoModal.swift
//  Notes
//
//  Created by Ryunosuke Yokokawa on 2023-05-05.
//

import SwiftUI

struct VoiceMemoModal: View {
    @FetchRequest(sortDescriptors: [], animation: .easeInOut) var folders: FetchedResults<Folder>
    var body: some View {
        ZStack {
            Color.primaryGray.ignoresSafeArea()
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    Spacer()
                    Image(systemName: "xmark")
                        .resizable()
                        .frame(width: 15, height: 15)
                        .foregroundColor(.primaryWhite)
                }
                .padding(.trailing, 20)
                
                
                
                Text("New Voice Memo")
                    .font(Font.mainFont(30))
                    .foregroundColor(.primaryWhite)
                    .tracking(1)
                    .bold()
                
                Text("01:23:32")
                    .font(Font.mainFont(18))
                    .foregroundColor(.primaryWhite)
                    .tracking(1)
                    .padding(.top, 10)
                
                Image(systemName: "waveform")
                    .resizable()
                    .frame(width: 80, height: 90)
                    .foregroundColor(.primaryWhite)
                    .padding(.top, 20)
                
                Circle()
                    .foregroundColor(.recordRed)
                    .frame(width: 90, height: 90)
                    .padding(.top, 20)
                
                
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
        
        
    }
    
}

struct VoiceMemoModal_Previews: PreviewProvider {
    static var previews: some View {
        VoiceMemoModal()
    }
}
