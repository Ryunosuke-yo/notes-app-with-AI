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
    @FetchRequest(sortDescriptors: [], animation: .easeInOut) var folders: FetchedResults<Folder>
    @FetchRequest(sortDescriptors: [], animation: .easeInOut) var notes: FetchedResults<Note>
    @StateObject var viewModel = FolderViewModel()
    
    var body: some View {
        ZStack {
            Color.primaryBlcak.ignoresSafeArea()
            
            
            VStack {
                HStack {
                    TextField("", text: $viewModel.folderNameValue)
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
                    viewModel.saveFolder(moc: moc, folders: folders)
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
                            FolderList(plusIocn: false, folderName: item.folderName ?? "Error getting name", folderValue: nil)
                                .listRowBackground(Color.primaryGray)
                                .foregroundColor(Color.primaryWhite)
                        }
                        .onDelete { index in
                            viewModel.deleteFolder(indexSet: index, moc: moc, folders: folders, notes: notes)
                        }
                    }
                    .scrollContentBackground(.hidden)
                    .background(Color.primaryBlcak)
                }
                
                
            }
            
            
            
            
        }
        .toolbar {
            ToolbarItem (placement: .navigationBarLeading) {
                HStack {
                    Image(systemName: "chevron.left")
                        .resizable()
                        .frame(width: 10, height: 20)
                        .foregroundColor(.primaryWhite)
                        .padding([.leading, .trailing])
                       
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    self.presentationMode.wrappedValue.dismiss()
                }
               
            }
            ToolbarItem(placement: .principal) {
                
                Text("Folders")
                    .font(Font.headerFont(32))
                    .tracking(4)
                    .foregroundColor(Color.primaryWhite)
                    .bold()
                
            }
        }
    }
    

    
//    func deleteFolder(at indexSet:IndexSet) {
//        var folderName: String?
//        
//        for index in indexSet {
//            let folder = folders[index]
//            folderName = folder.folderName ?? nil
//            moc.delete(folder)
//            
//            
//            do {
//                try moc.save()
//            } catch {
//                print(error.localizedDescription, "when deleteing folder"
//                )
//            }
//        }
//        
//        notes.forEach { note in
//            if note.folder == folderName {
//                note.folder = ""
//            }
//        }
//    }
    
    
    
}




//struct FolderView_Previews: PreviewProvider {
//    static var previews: some View {
//        FolderView()
//    }
//}
