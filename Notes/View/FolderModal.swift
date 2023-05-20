//
//  FolderModal.swift
//  Notes
//
//  Created by Ryunosuke Yokokawa on 2023-05-07.
//

import SwiftUI

struct FolderModal: View {
   
    var body: some View {
        ZStack {
            Color.primaryBlcak.ignoresSafeArea()
            
            VStack(spacing: 10) {
                Capsule()
                            .foregroundColor(.primaryGray)
                            .frame(width: 80, height: 9)
                            .padding(.top, 20)
                List {
                   FolderList()
                        .listRowBackground(Color.primaryGray)
                        .foregroundColor(Color.primaryWhite)
                    FolderList()
                        .listRowBackground(Color.primaryGray)
                        .foregroundColor(Color.primaryWhite)
                        
                }
                .scrollContentBackground(.hidden)
                .background(Color.primaryBlcak)
            }
            
            
        }
    }
}

struct FolderList: View {
    var body: some View {
        HStack {
            Image(systemName: "plus.circle")
                .resizable()
                .foregroundColor(.primaryOrange)
                .frame(width: 20, height: 20)
            Text("folder name")
                .foregroundColor(.primaryWhite)
                .font(Font.mainFont(20))
                .tracking(1.5)
                .padding(.leading, 10)
            Spacer()
        }
        .contentShape(Rectangle())
        .padding(7)
        .onTapGesture {
            print("taped")
        }
        
            
    }
}

struct FolderModal_Previews: PreviewProvider {
    static var previews: some View {
        FolderModal()
    }
}
