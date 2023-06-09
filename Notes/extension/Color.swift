//
//  Color.swift
//  Notes
//
//  Created by Ryunosuke Yokokawa on 2023-04-30.
//

import Foundation
import SwiftUI


extension Color {
    static let primaryBlcak = Color("primaryBlack")
    static let primaryWhite = Color("primaryWhite")
    static let primaryYellow = Color("primaryYellow")
    static let primaryGray = Color("primaryGray")
    static let primaryGreen = Color("primaryGreen")
    static let primaryOrange = Color("primaryOrange")
    static let secondaryWhite = Color("secondaryWhite")
    static let primaryPurple = Color("primaryPurple")
    static let recordRed = Color("recordRed")
    
    
    static func getColorString(color: Color)-> String {
        switch color {
        case .primaryOrange :
            return NoteColors.orange.rawValue
        case .primaryPurple :
            return NoteColors.purple.rawValue
        case .primaryYellow :
            return NoteColors.yellow.rawValue
        case .primaryGreen :
            return NoteColors.green.rawValue
        default:
            return NoteColors.orange.rawValue
        }
    }
    
    static func getColorValue(colorString: String)-> Color {
        switch colorString {
        case NoteColors.orange.rawValue:
            return .primaryOrange
        case NoteColors.green.rawValue:
            return .primaryGreen
        case NoteColors.purple.rawValue:
            return .primaryPurple
        case NoteColors.yellow.rawValue:
            return . primaryYellow
        default:
            return .primaryOrange
        }
    }
    
    static func convertNoteColorString(colorString: String)-> Color {
        switch colorString {
        case NoteColors.orange.rawValue:
            return .primaryOrange
        case NoteColors.green.rawValue:
            return .primaryGreen
        case NoteColors.purple.rawValue:
            return .primaryPurple
        case NoteColors.yellow.rawValue:
            return . primaryYellow
        default:
            return .primaryOrange
        }
    }
}
