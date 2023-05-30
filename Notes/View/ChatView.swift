//
//  ChatView.swift
//  Notes
//
//  Created by Ryunosuke Yokokawa on 2023-05-02.
//

import SwiftUI
import ActivityIndicatorView

struct ChatView: View {
    @State private var textEditorHeight : CGFloat = 100
    @State var prompt = ""
    @State var aiResponse = ""
    @State var isLoading = false
    var maxHeight : CGFloat = 250
    @Binding var selectedTab: Int
    @FocusState private var focused: Bool
    @FetchRequest(sortDescriptors: [
        SortDescriptor(\.timestamp)], animation: .easeInOut) var chats: FetchedResults<Chats>
    @Environment(\.managedObjectContext) var moc
    
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
                if chats.count == 0 {
                    Text("No talk")
                } else {
                    ScrollViewReader { proxy in
                        ScrollView {
                            VStack {
                                ForEach(chats, id: \.self) {
                                    chat in
                                    ChatBubble(leftRight: chat.user == true ? .right : .left, content: chat.content ?? "Error loading message")
                                }
                                
                                if isLoading == true {
                                    ActivityIndicatorView(isVisible: $isLoading, type: .rotatingDots(count: 5))
                                         .frame(width: 50.0, height: 50.0)
                                         .foregroundColor(.primaryOrange)
                                    Spacer()
                                    
                                }
                            }

                        }

                        .scrollIndicators(.hidden)
                        .onTapGesture {
                            focused = false
                        }
                        .onAppear {
                            proxy.scrollTo(chats.last, anchor: .bottom)
                        }
                    }
                   
                }
                
               
             
                
                
                HStack {
                    DynamicHeightTextEditor(text: $prompt, placeholder: "Ask anything", maxHeight: maxHeight)
                        .background(Color.primaryGray)
                        .foregroundColor(.primaryWhite)
                        .padding([.leading], 15)
                        .focused($focused)
                    
                    
                    Image(systemName: "paperplane.fill")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .padding(.trailing, 20)
                        .foregroundColor(.primaryOrange)
                        .onTapGesture {
                            if prompt != "" {
                                let newUserChat = Chats(context: moc)
                                newUserChat.content = prompt
                                newUserChat.timestamp = Date().timeIntervalSince1970
                                newUserChat.user = true
                                prompt = ""
                                callOpenAIChatEndpoint()
                            }
                          
                        }
                    
                }
                
                .background(Color.primaryGray)
                .cornerRadius(30)
                .padding(.horizontal, 10)
               
            }
            .padding([.bottom], 20)
            
            
        }
    }
    
    
    
    func callOpenAIChatEndpoint() {
        isLoading = true
        let apiKey = ProcessInfo.processInfo.environment["CHAT_API_KEY"]!
        let endpointURL = URL(string: "https://api.openai.com/v1/chat/completions")!
        
        var request = URLRequest(url: endpointURL)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: AnyHashable] = [
            "model": "gpt-3.5-turbo",
            "messages": [
                ["role": "system", "content": "You are a helpful assistant."],
                ["role": "user", "content": prompt]
            ]
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
       
        
        
        let task = URLSession.shared.dataTask(with: request) { (data, _, error) in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let res = try JSONDecoder().decode(ChatResponse.self, from: data)
                let newChat = Chats(context: moc)
                newChat.user = false
                newChat.content = res.choices[0].message.content
                
                let timestamp = Date().timeIntervalSince1970
                newChat.timestamp = timestamp
                print(timestamp)
                do {
                    try moc.save()
                   
                } catch {
                    print(error.localizedDescription, "when saving chat")
                }
                isLoading = false
            } catch {
                print(error)
            }
            
        }
        task.resume()
    }
    
    
}

struct ChatBubble: View {
    let leftRight: leftRight
    let content: String
    var body: some View {
        HStack {
            leftRight == .right ? Spacer() : nil
            
            Text(content)
                .padding()
                .background(leftRight == .right ? Color.primaryOrange : Color.primaryGray)
                .foregroundColor(.primaryWhite)
                .cornerRadius(16)
//                .frame(maxWidth: UIScreen.screenWidth / 1.3)
              
            leftRight == .left ? Spacer() : nil
        }
        .padding(EdgeInsets(top: 5, leading: leftRight == .left ? 15 : 100, bottom: 5, trailing: leftRight == .right ? 15 : 100 ))
        
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
