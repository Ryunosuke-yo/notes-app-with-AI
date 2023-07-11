//
//  FolderViewModel.swift
//  Notes
//
//  Created by Ryunosuke Yokokawa on 2023-07-02.
//

import Foundation
import SwiftUI
import CoreData

extension FolderView {
    @MainActor class FolderViewModel: ObservableObject {
        @Published var folderNameValue = ""
        
        
        func saveFolder(moc: NSManagedObjectContext, folders: FetchedResults<Folder>) {
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
        
        func deleteFolder(indexSet:IndexSet, moc: NSManagedObjectContext, folders: FetchedResults<Folder>, notes: FetchedResults<Note>) {
            var folderName: String?
            
            for index in indexSet {
                let folder = folders[index]
                folderName = folder.folderName ?? nil
                moc.delete(folder)
                
                
                do {
                    try moc.save()
                } catch {
                    print(error.localizedDescription, "when deleteing folder"
                    )
                }
            }
            
            notes.forEach { note in
                if note.folder == folderName {
                    note.folder = ""
                }
            }
        }
    }
}
