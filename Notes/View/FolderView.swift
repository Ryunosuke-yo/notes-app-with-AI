//
//  FolderView.swift
//  Notes
//
//  Created by Ryunosuke Yokokawa on 2023-05-03.
//

import SwiftUI

struct FolderView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) var moc
    @State var folderNameValue = ""
    @FetchRequest(sortDescriptors: [], animation: .easeInOut) var folders: FetchedResults<Folder>
   
    
    
    var body: some View {
        ZStack {
            Color.primaryBlcak.ignoresSafeArea()
            
            
            VStack {
                HStack {
                    TextField("", text: $folderNameValue)
                        .font(Font.mainFont(20))
                        .fontWeight(Font.Weight.medium)
                        .tracking(2)
                        .foregroundColor(.primaryWhite)
                        .padding()
                    
                    
                }
                
                .background(Color.primaryGray)
                .cornerRadius(10)
                .padding()
                .padding([.top], 40)
                
                Button {
                    saveFolder()
                } label: {
                    Text("Add")
                        .font(Font.mainFont(20))
                        .fontWeight(Font.Weight.medium)
                        .tracking(1)
                        .foregroundColor(.primaryWhite)
                        .padding([.top, .bottom])
                        .padding([.trailing, .leading], 50)
                    
                }
                .background(Color.primaryOrange)
                .cornerRadius(10)
                
                
                
                if(folders.count == 0) {
                    Spacer()
                } else {
                    List {
                        ForEach(folders, id: \.self) { item in
                            FolderList(plusIocn: false, folderName: item.folderName ?? "Error getting name")
                                .listRowBackground(Color.primaryGray)
                                .foregroundColor(Color.primaryWhite)
                        }
                        .onDelete(perform: deleteFolder)
                    }
                    .scrollContentBackground(.hidden)
                    .background(Color.primaryBlcak)
                }
                
                
            }
            
            
            
            
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
                
                Text("Folders")
                    .font(Font.mainFont(32))
                    .tracking(4)
                    .foregroundColor(Color.primaryWhite)
                    .bold()
                
            }
        }
    }
    
    func saveFolder() {
        
        if folders.contains(where: {
            $0.wrappedFolderNeme == folderNameValue
        }) {
            return
        }
        
        let newFolder = Folder(context: moc)
        newFolder.folderName = folderNameValue
        
        do {
            try moc.save()
        } catch {
            print("An error occurred: \(error)")
        }
    }
    
    func deleteFolder(at indexSet:IndexSet) {
        for index in indexSet {
            let folder = folders[index]
            moc.delete(folder)
            
        }
    }
}




struct FolderView_Previews: PreviewProvider {
    static var previews: some View {
        FolderView()
    }
}
