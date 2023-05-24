//
//  FolderModal.swift
//  Notes
//
//  Created by Ryunosuke Yokokawa on 2023-05-07.
//

import SwiftUI

struct FolderModal: View {
    @Binding var folderValue: String
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: [], animation: .easeInOut) var folders: FetchedResults<Folder>
    
    
    var body: some View {
        ZStack {
            Color.primaryBlcak.ignoresSafeArea()
            
            VStack(spacing: 10) {
                Capsule()
                            .foregroundColor(.primaryGray)
                            .frame(width: 80, height: 9)
                            .padding(.top, 20)
                List(folders) { folder in
                    FolderList(plusIocn: true, folderName: folder.folderName ?? "Error getting name")
                        .listRowBackground(Color.primaryGray)
                        .foregroundColor(Color.primaryWhite)
                        .onTapGesture {
                            folderValue = folder.folderName ?? ""
                            presentationMode.wrappedValue.dismiss()
                        }
                        
                }
                .scrollContentBackground(.hidden)
                .background(Color.primaryBlcak)
            }
            
            
        }
    }
}

struct FolderList: View {
    let plusIocn: Bool
    let folderName: String
    var body: some View {
        HStack {
            if plusIocn == true {
                Image(systemName: "plus.circle")
                    .resizable()
                    .foregroundColor(.primaryOrange)
                    .frame(width: 20, height: 20)
            }
           
            Text(folderName)
                .foregroundColor(.primaryWhite)
                .font(Font.mainFont(20))
                .tracking(1.5)
                .padding(.leading, 10)
            Spacer()
        }
        .contentShape(Rectangle())
        .padding(7)
        
            
    }
}

//struct FolderModal_Previews: PreviewProvider {
//    static var previews: some View {
//        FolderModal()
//    }
//}
