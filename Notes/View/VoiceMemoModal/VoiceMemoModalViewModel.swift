//
//  VoiceMemoModalViewModel.swift
//  Notes
//
//  Created by Ryunosuke Yokokawa on 2023-07-10.
//

import Foundation
import SwiftUI

extension VoiceMemoModal {
    @MainActor class VoiceMemoModalViewModel: ObservableObject {
        @Published var titleValue = "New Recording"
        @Published var folder = ""
        @Published var minutes = 0
        @Published var seconds = 0
        @Published var selectedFolder: Folder?
        @Published var fileName = ""
        @Published var recodingComplted = false
        @Published var selectedColor = Color.primaryOrange
        @Published var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
        @Published var showFilenameAlert = false
        @Published var isRecording = false
    }
}
