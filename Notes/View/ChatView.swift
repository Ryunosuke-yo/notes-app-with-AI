//
//  ChatView.swift
//  Notes
//
//  Created by Ryunosuke Yokokawa on 2023-05-02.
//

import SwiftUI

struct ChatView: View {
    @State private var textEditorHeight : CGFloat = 100
    @State var text = ""
    var maxHeight : CGFloat = 250
    @Binding var selectedTab: Int
    @FocusState private var focused: Bool
 
    var body: some View {
        ZStack {
            Color.primaryBlcak.ignoresSafeArea()
            VStack {
                HStack(spacing:0) {
                    Image(systemName: "chevron.left")
                        .resizable()
                        .frame(width: 10, height: 20)
                        .foregroundColor(.primaryWhite)
                        .onTapGesture {
                            print("pressed")
                            selectedTab = 1
                        }
                        .padding(.leading, 20)
                    Text("Chat")
                        .font(Font.mainFont(32))
                        .tracking(4)
                        .foregroundColor(Color.primaryWhite)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .center)
                    Rectangle()
                        .frame(width: 30, height: 22)
                        .foregroundColor(Color.primaryBlcak)
                }
                ScrollView {
                    VStack {
                        ChatBubble(leftRight: .left)
                        ChatBubble(leftRight: .right)
                        ChatBubble(leftRight: .left)
                        ChatBubble(leftRight: .left)
                    }
                }
                .scrollIndicators(.hidden)
                .onTapGesture {
                    focused = false
                }
                
                
                HStack {
                    DynamicHeightTextEditor(text: $text, placeholder: "Ask anything", maxHeight: maxHeight)
                        .background(Color.primaryGray)
                        .foregroundColor(.primaryWhite)
                        .padding([.leading], 15)
                        .focused($focused)
                    
                    
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
            .padding([.bottom], 20)
            
            
            
        }
        
    }
}

struct ChatBubble: View {
   let leftRight: leftRight
    var body: some View {
        HStack {
            leftRight == .right ? Spacer() : nil
           
            Text("Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type")
                .frame(width: UIScreen.screenWidth / 1.6)
                .padding()
                .background(leftRight == .right ? Color.primaryOrange : Color.primaryGray)
                .foregroundColor(.primaryWhite)
                .cornerRadius(15)
                .padding(.bottom, 10)
            leftRight == .left ? Spacer() : nil
        }
    
    }
    
    
}

struct ViewHeightKey: PreferenceKey {
    static var defaultValue: CGFloat { 0 }
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value = value + nextValue()
    }
}

//struct ChatView_Previews: PreviewProvider {
//    static var previews: some View {
//        ChatView()
//    }
//}
