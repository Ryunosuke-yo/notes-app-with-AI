//
//  PlayAudioViewModel.swift
//  Notes
//
//  Created by Ryunosuke Yokokawa on 2023-07-10.
//

import Foundation
import SwiftUI

extension PlayAudioView {
    @MainActor class PlayAudioViewModel: ObservableObject {
        @Published var titleValue = ""
        @Published var selectedColor = Color.primaryOrange
        @Published var showColorSheet = false
        @Published var showFolderModal = false
        @Published var folderValue = ""
        @Published var currentFileName = ""
        @Published var showDeleteAlert = false
        @Published var indicator = true
        @Published var showFileNameAlert = false
    }
}
