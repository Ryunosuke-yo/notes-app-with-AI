//
//  Font.swift
//  Notes
//
//  Created by Ryunosuke Yokokawa on 2023-05-01.
//

import Foundation
import SwiftUI


extension Font {
    static var mainFont = {
        (size: CGFloat)-> Font in
        return Font.custom("Futura", size: size)
    }
}
