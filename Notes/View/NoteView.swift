//
//  NoteView.swift
//  Notes
//
//  Created by Ryunosuke Yokokawa on 2023-05-01.
//

import SwiftUI

struct NoteView: View {
    @State private var text: String = ""
    let data = ["Item 1", "Item 2", "Item 3", "Item 4", "Item 5"]
    var body: some View {
        ZStack {
            Color.primaryBlcak
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Spacer()
                    Image(systemName: "folder.badge.plus")
                        .resizable(resizingMode: .stretch)
                        .frame(width: 30, height: 22, alignment: .trailing)
                        .foregroundColor(.secondaryWhite)
                        .padding(.trailing, 15)
                }
                Text("Note")
                    .font(Font.mainFont(36))
                    .fontWeight(.bold)
                    .tracking(5)
                    .foregroundColor(.primaryWhite)
                    .frame(maxWidth: .infinity, alignment: .center)
                
                
                HStack {
                    Image(systemName: "magnifyingglass")
                        .resizable(resizingMode: .stretch)
                        .frame(width: 25, height: 25)
                        .foregroundColor(.primaryWhite)
                        .padding(.leading, 10)
                    
                    TextField("", text: $text)
                        .font(Font.mainFont(20))
                        .fontWeight(.regular)
                        .tracking(1)
                        .foregroundColor(.primaryWhite)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.gray, lineWidth: 0)
                        )
                        .padding(10)
                    
                    
                    
                }
                .background(Color.primaryGray)
                .cornerRadius(30)
                .padding(.horizontal, 10)
                
                ScrollView(.horizontal) {
                    HStack(spacing: 15) {
                        ForEach(data, id: \.self) { item in
                            Text(item)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 10)
                                .cornerRadius(20)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .inset(by: 2)
                                        .stroke(Color.secondaryWhite, lineWidth: 2)
                                )
                                .background(Color.primaryBlcak)
                                .foregroundColor(.primaryWhite)
                            
                            
                        }
                    }
                    
                }
                .scrollIndicators(.hidden)
                .padding(.top, 20)
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
            }
        }
    }
}

struct NoteView_Previews: PreviewProvider {
    static var previews: some View {
        NoteView()
    }
}
