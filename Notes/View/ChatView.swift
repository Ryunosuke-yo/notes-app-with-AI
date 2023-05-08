//
//  ChatView.swift
//  Notes
//
//  Created by Ryunosuke Yokokawa on 2023-05-02.
//

import SwiftUI

struct ChatView: View {
    @State var text = ""
    var body: some View {
        ZStack {
            Color.primaryBlcak.ignoresSafeArea()
            VStack {
                ScrollView {
                    VStack {
                        ChatBubble()
                        ChatBubble()
                        ChatBubble()
                        ChatBubble()
                    }
                }
                .scrollIndicators(.hidden)
                
                
                HStack {
                    TextEditor(text: $text)
                        .font(Font.mainFont(23))
                        .fontWeight(.regular)
                        .tracking(1.5)
                        .foregroundColor(.primaryWhite)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.gray, lineWidth: 0)
                        )
                        .padding([.vertical], 10)
                        .padding(.horizontal, 20)
                    
                    Image(systemName: "paperplane.fill")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .padding(.trailing, 20)
                        .foregroundColor(.primaryOrange)
                        
                }
                
                    .background(Color.primaryGray)
                    .cornerRadius(30)
                    .padding(.horizontal, 10)
            }
           
            
            
        }
    }
}

struct ChatBubble: View {
    var body: some View {
        HStack {
            Spacer()
            Text("Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lore")
                .frame(width: UIScreen.screenWidth / 1.6)
                .padding()
                .background(Color.primaryWhite)
                .cornerRadius(15)
                .padding(.bottom, 10)
        }
    }
    
    
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView()
    }
}
