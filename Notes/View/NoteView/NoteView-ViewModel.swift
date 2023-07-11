//
//  NoteView-ViewModel.swift
//  Notes
//
//  Created by Ryunosuke Yokokawa on 2023-07-02.
//

import Foundation
import SwiftUI

extension NoteView {
    @MainActor class NoteViewModel: ObservableObject {
        @Published var isNoteMode = true
        @Published var appMode: AppMode = .noteMode
        @Published var seactText: String = ""
        @Published var showVoiceRec = false
        @Published var selectedFolder: Folder?
        @Published var selectedNoteId: UUID? = nil
        
     
        
        func getFolderTextColor(cuurentFolder: String)-> Color {
            if let s = selectedFolder {
               return s.wrappedFolderNeme == cuurentFolder ? .primaryOrange : .primaryWhite
           }
           return .primaryWhite
       }
        
        func getFolderStrokeColor(cuurentFolder: String)-> Color {
            if let s = selectedFolder {
                return s.wrappedFolderNeme == cuurentFolder ? .primaryOrange : .secondaryWhite
            }
            return .secondaryWhite
        }
    }
    
     
}
