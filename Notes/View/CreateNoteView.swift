//
//  CreateNoteView.swift
//  Notes
//
//  Created by Ryunosuke Yokokawa on 2023-05-07.
//

import SwiftUI

struct CreateNoteView: View {
    @Environment(\.presentationMode) var presentationMode
    @State var titleValue = ""
    @State var contentValue = ""
    @State var showFolderModal = false
    var body: some View {
        ZStack {
            Color.primaryBlcak.ignoresSafeArea()
            VStack {
                    TextField("Title", text: $titleValue)
                        .font(Font.mainFont(38))
                        .fontWeight(Font.Weight.medium)
                        .tracking(2)
                        .foregroundColor(.primaryWhite)
                       
              
                
                
                TextEditor(text: $contentValue)
                    .font(Font.mainFont(26))
                    .tracking(1.5)
                    .scrollContentBackground(.hidden)
                    .foregroundColor(.primaryWhite)
                    .background(Color.primaryBlcak)
                    .scrollBounceBehavior(.always)
                
                   
                
                
                 
                
            }
            .padding([.trailing, .leading], 20)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack(spacing: 20) {
                        
                        
                        Image(systemName: "square.and.arrow.up")
                            .resizable()
                            .frame(width: 20, height: 25)
                            .foregroundColor(.primaryWhite)
                        
                        Image(systemName: "folder")
                            .resizable()
                            .frame(width: 25, height: 25)
                            .foregroundColor(.primaryWhite)
                            .onTapGesture {
                                showFolderModal.toggle()
                            }
                            .sheet(isPresented: $showFolderModal) {
                                FolderModal()
                            }
                        
                        Text("Done")
                            .font(Font.mainFont(20))
                            .foregroundColor(.primaryWhite)
                    }
                    .padding([.horizontal, .top], 20)
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Image(systemName: "chevron.left")
                        .resizable()
                        .frame(width: 10, height: 20)
                        .foregroundColor(.primaryWhite)
                        .onTapGesture {
                            print("pressed")
                            self.presentationMode.wrappedValue.dismiss()
                        }
                }
            }
        }
    }
}

struct CreateNoteView_Previews: PreviewProvider {
    static var previews: some View {
        CreateNoteView()
    }
}
