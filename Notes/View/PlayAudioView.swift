//
//  PlayAudioView.swift
//  Notes
//
//  Created by Ryunosuke Yokokawa on 2023-06-14.
//

import SwiftUI

struct PlayAudioView: View {
    @State var titleValue = ""
    @State var selectedColor = Color.primaryOrange
    @State var showColorSheet = false
    @State var showFolderModal = false
    @State var folderValue = ""
    var recording: Recording
    
    
    @Environment(\.presentationMode) var presentationMode
    @Environment (\.managedObjectContext) var moc
    
    
    
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
                Image(systemName: "waveform")
                    .resizable()
                    .foregroundColor(selectedColor)
                    .frame(width: 130, height: 140)
                    .foregroundColor(.primaryWhite)
                    .padding(.top, 20)
                
                Text(recording.time ?? "")
                    .font(Font.mainFont(20))
                    .foregroundColor(.primaryWhite)
                    .padding(.top, 20)
                
                Spacer()
                    .frame(height: 20)
                Image(systemName: "play.circle")
                    .resizable()
                    .foregroundColor(selectedColor)
                    .frame(width: 80, height: 80)
                    .foregroundColor(.primaryWhite)
                    .padding(.top, 20)
                Spacer()
            }
            
        }
        .onAppear {
            titleValue = recording.title ?? ""
            folderValue = recording.folder ?? ""
            selectedColor = Color.getColorValue(colorString: recording.color ?? "primaryOrange")
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showColorSheet) {
            ColorSheetModal { color in
                selectedColor = color
                showColorSheet.toggle()
            }
            .presentationDetents([.height(150)])
            .presentationBackground(Color.primaryGray)
            
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                HStack(spacing: 25) {
                    Circle()
                        .fill(selectedColor)
                        .frame(width: 20, height: 20)
                        .onTapGesture {
                            showColorSheet = true
                        }
                    Image(systemName: "square.and.arrow.up")
                        .resizable()
                        .frame(width: 20, height: 25)
                        .foregroundColor(.primaryWhite)
                        .onTapGesture {
                            //                            if titleValue == "" {
                            //                                return
                            //                            }
                            //                            createTxtFile()
                        }
                    
                    Image(systemName:  "trash")
                        .resizable()
                        .frame(width: 20, height: 23)
                        .foregroundColor(.recordRed)
                    
                    
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
                .simultaneousGesture(TapGesture().onEnded {
                    //                            if titleValue == "" && contentValue == "" {
                    presentationMode.wrappedValue.dismiss()
                    //                                return
                    //                            }
                    //                            saveNote()
                    
                })
                
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
}

//struct PlayAudioView_Previews: PreviewProvider {
//    static var previews: some View {
//        PlayAudioView()
//    }
//}
