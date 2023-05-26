//
//  SeacrhView.swift
//  Notes
//
//  Created by Ryunosuke Yokokawa on 2023-05-25.
//

import SwiftUI

struct SeacrhView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var text = ""
    
    var body: some View {
        ZStack {
            Color.primaryBlcak.ignoresSafeArea()
            
            VStack {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .resizable(resizingMode: .stretch)
                        .frame(width: 15, height: 15)
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
                        .padding(5)
                    
                    
                    
                }
                .background(Color.primaryGray)
                .cornerRadius(30)
                .padding(.horizontal, 10)
                
                Spacer()
            }
            
            
           
            
            
        }
        .toolbar {
            ToolbarItem (placement: .navigationBarLeading) {
                Image(systemName: "chevron.left")
                    .resizable()
                    .frame(width: 10, height: 20)
                    .foregroundColor(.primaryWhite)
                    .onTapGesture {
                        print("pressed")
                        self.presentationMode.wrappedValue.dismiss()
                    }
            }
            ToolbarItem(placement: .principal) {
                
                Text("Seacrh")
                    .font(Font.mainFont(32))
                    .tracking(4)
                    .foregroundColor(Color.primaryWhite)
                    .bold()
                
            }
        }
    }
}

struct SeacrhView_Previews: PreviewProvider {
    static var previews: some View {
        SeacrhView()
    }
}
