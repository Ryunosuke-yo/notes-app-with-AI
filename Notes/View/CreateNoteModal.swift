//
//  CreateNoteModal.swift
//  Notes
//
//  Created by Ryunosuke Yokokawa on 2023-05-05.
//

import SwiftUI

struct CreateNoteModal: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            Color.primaryBlcak.ignoresSafeArea()
            VStack {
                HStack(spacing: 20) {
                    Text("Cancel")
                        .font(Font.mainFont(20))
                        .foregroundColor(.primaryWhite)
                        .onTapGesture {
                            dismiss()
                        }
                    
                    Spacer()
                    
                    Image(systemName: "square.and.arrow.up")
                        .resizable()
                        .frame(width: 20, height: 25)
                        .foregroundColor(.primaryWhite)
                    
                    Image(systemName: "folder")
                        .resizable()
                        .frame(width: 25, height: 25)
                        .foregroundColor(.primaryWhite)
                    
                    Text("Done")
                        .font(Font.mainFont(20))
                        .foregroundColor(.primaryWhite)
                }
                .padding([.horizontal, .top], 20)
                
                
                Spacer()
            }
        }
    }
}

struct CreateNoteModal_Previews: PreviewProvider {
    static var previews: some View {
        CreateNoteModal()
    }
}
