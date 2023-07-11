//
//  CreateNoteView-viewModel.swift
//  Notes
//
//  Created by Ryunosuke Yokokawa on 2023-07-02.
//

import Foundation
import SwiftUI

extension CreateNoteView {
    @MainActor class CreateNoteViewModel: ObservableObject {
        @Published var titleValue = ""
        @Published var contentValue = ""
        @Published var showFolderModal = false
        @Published var folderValue = ""
        @Published var selectedColor = Color.primaryOrange
        @Published var showColorSheet = false
        @Published var isSharePresented = false
        @Published var showDeleteAlert = false
        
    }
}
