//
//  SheetManager.swift
//  Notes
//
//  Created by Ryunosuke Yokokawa on 2023-06-15.
//

import Foundation

class SheetManager: ObservableObject {
    @Published var fileNameState = ""
    @Published var fileUrlState: URL? = nil
}
