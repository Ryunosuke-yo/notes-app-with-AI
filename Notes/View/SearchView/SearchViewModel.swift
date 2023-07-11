//
//  SearchViewModel.swift
//  Notes
//
//  Created by Ryunosuke Yokokawa on 2023-07-02.
//

import Foundation

extension SeacrhView {
    @MainActor class SearchViewModel: ObservableObject {
        @Published var searchText = ""
        @Published var selectedNoteId: UUID? = nil
        @Published var searchResultForRecording = false
        @Published var searchResultForNote = false
    }
}
