//
//  NoteView.swift
//  Notes
//
//  Created by Ryunosuke Yokokawa on 2023-05-01.
//

import SwiftUI

struct NoteView: View {
    @State private var text: String = ""
    let data = ["All", "Daily", "Work", "Item 4", "Item 5"]
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]
    var body: some View {
        ZStack {
            Color.primaryBlcak
                .ignoresSafeArea()
            
            VStack {
                HStack(spacing: 0) {
                   Rectangle()
                        .frame(width: 30, height: 22)
                        .padding(.leading, 15)
                        .foregroundColor(Color.primaryBlcak)
                    Text("Note")
                        .font(Font.mainFont(36))
                        .fontWeight(.bold)
                        .tracking(5)
                        .foregroundColor(.primaryWhite)
                        .frame(maxWidth: .infinity, alignment: .center)
                 
                    Image(systemName: "folder.badge.plus")
                        .resizable(resizingMode: .stretch)
                        .frame(width: 30, height: 22, alignment: .trailing)
                        .foregroundColor(.secondaryWhite)
                        .padding(.trailing, 15)
                }
                
              
                
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
                    HStack(spacing: 12) {
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
                .padding(.top, 5)
                
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 2) {
                        ForEach(0..<data.count) {
                            index in
                            if index % 3 == 0 {
                                VStack(spacing: 0) {
                                    
                                    Text("This is the title")
                                        .font(Font.mainFont(20))
                                        .fontWeight(.bold)
                                        .tracking(0.2)
                                        .foregroundColor(.primaryWhite)
                                        .frame(height: 20, alignment: .leading)
                                        .padding(.top, 25)
                                        .padding(.leading, 10)
                                    
                                    
                                    
                                    
                                    Text("I’m creating a note app to demonstrate my ability as a ios developer Why people are")
                                        .font(Font.mainFont(15))
                                        .tracking(0.2)
                                        .foregroundColor(.primaryWhite)
                                        .frame( height: 100)
                                        .padding(.horizontal, 10)
                                        .padding(.bottom, 40)
                                        .padding(.top, 9)
                                    
                                    HStack {
                                        Spacer()
                                        Image(systemName: "trash")
                                            .resizable()
                                            .foregroundColor(Color.primaryWhite)
                                            .frame(width: 25, height: 25, alignment: .trailing)
                                            .padding([.trailing, .bottom], 20)
                                    }
                                    
                                    
                                    
                                    
                                }
                                .background(Color.primaryOrange)
                                .cornerRadius(20)
                                .padding(.horizontal, 5)
                                .padding(.top, 18)
                                
                                
                            } else {
                                VStack(spacing: 0) {
                                    
                                    Text("This is the title")
                                        .font(Font.mainFont(20))
                                        .fontWeight(.bold)
                                        .tracking(0.2)
                                        .foregroundColor(.primaryWhite)
                                        .frame(height: 20, alignment: .leading)
                                        .padding(.top, 25)
                                        .padding(.leading, 10)
                                    
                                    
                                    
                                    
                                 
                                        Image(systemName: "waveform")
                                            .resizable()
                                            .foregroundColor(Color.primaryWhite)
                                            .frame(width: 90, height: 100)
                                            .padding(.vertical, 10)
                                    
                                    
                                 
                                  
                                    
                                    HStack {
                                        Spacer()
                                        Image(systemName: "trash")
                                            .resizable()
                                            .foregroundColor(Color.primaryWhite)
                                            .frame(width: 25, height: 25)
                                            .padding([.trailing, .bottom], 20)
                                    }
                                    
                                    
                                    
                                    
                                }
                                .background(Color.primaryPurple)
                                .cornerRadius(20)
                                .padding(.horizontal, 5)
                                .padding(.top, 18)
                                
                                
                            }
                        }
                    }
                }
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
            }
        }
    }
}

struct NoteView_Previews: PreviewProvider {
    static var previews: some View {
        NoteView()
    }
}
