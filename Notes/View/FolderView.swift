//
//  FolderView.swift
//  Notes
//
//  Created by Ryunosuke Yokokawa on 2023-05-03.
//

import SwiftUI

struct FolderView: View {
    @Environment(\.presentationMode) var presentationMode
  
       
    var body: some View {
        ZStack {
            Color.primaryBlcak.ignoresSafeArea()
            
              }
        .toolbar {
            ToolbarItem (placement: .navigationBarLeading) {
                Image(systemName: "chevron.left")
                    .resizable()
                    .frame(width: 10, height: 20)
                    .foregroundColor(.primaryWhite)
                    .onTapGesture {
                        print("pressed")
                        self.presentationMode.wrappedValue.dismiss()
                    }
            }
            ToolbarItem(placement: .principal) {
                HStack {
                    Text("Folders")
                        .font(Font.mainFont(32))
                        .tracking(4)
                        .foregroundColor(Color.primaryWhite)
                        .bold()
                    
                }
                
                
            }
        }
    }
    }




struct FolderView_Previews: PreviewProvider {
    static var previews: some View {
        FolderView()
    }
}
