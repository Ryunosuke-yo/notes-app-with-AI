//
//  ColorSheetModal.swift
//  Notes
//
//  Created by Ryunosuke Yokokawa on 2023-06-14.
//

import SwiftUI

struct ColorSheetModal: View {
    var onTap: (_ color: Color)-> Void
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]
    let colorSelection: [Color] = [
        .primaryGreen,
        .primaryOrange,
        .primaryPurple,
        .primaryYellow,
    ]
    var body: some View {
        LazyVGrid(columns: columns, spacing: 20) {
            ForEach(colorSelection, id: \.self) { color in
                Circle()
                    .fill(color)
                    .frame(width: 40, height: 40)
                    .onTapGesture {
                        onTap(color)
                    }
            }
        }
    }
}

//struct ColorSheetModal_Previews: PreviewProvider {
//    static var previews: some View {
//        ColorSheetModal()
//    }
//}
