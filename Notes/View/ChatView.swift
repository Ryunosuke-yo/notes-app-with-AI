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
    @State var loadingState: Loading = .idle
    @State var scrollToBottom = false
    @State var isLoadingForIndicator = true
    @State var showAlert = false
    var maxHeight : CGFloat = 250
    @Binding var selectedTab: Int
    @FocusState private var focused: Bool
    @FetchRequest(sortDescriptors: [
        SortDescriptor(\.timestamp)], animation: .easeInOut) var chats: FetchedResults<Chats>
    @Environment(\.managedObjectContext) var moc
    @Namespace var bottomID
    
    
    var body: some View {
        ZStack {
            Color.primaryBlcak.ignoresSafeArea()
            VStack {
                HStack {
                    HStack{
                        Image(systemName: "chevron.left")
                            .resizable()
                            .frame(width: 10, height: 20)
                            .foregroundColor(.primaryWhite)
                           
                            .padding([ .trailing, .leading])

                    }
                    .frame(width: 30)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        selectedTab = 1
                    }
                   
                       
                Spacer()
                    Text("Chat")
                        .font(Font.mainFont(32))
                        .tracking(4)
                        .foregroundColor(Color.primaryWhite)
                        .bold()
                    
                Spacer()
                
                    Text("Clear")
                        .font(Font.mainFont(13))
                        .tracking(1.5)
                        .foregroundColor(Color.primaryWhite)
                        .frame(width: 50)
                        .padding(.top, 5)
                        .onTapGesture {
                            showAlert = true
                        }
                    
                }
                .padding([.leading, .trailing], 20)
                    ScrollViewReader { proxy in
                        ScrollView {
                            if chats.count == 0 {
                                Text("No chats")
                                    .font(Font.mainFont(20))
                                    .tracking(1)
                                    .foregroundColor(.primaryGray)
                                    .padding(.top, 10)
                            } else {
                                LazyVStack {
                                    ForEach(chats, id: \.self) {
                                        chat in
                                        ChatBubble(leftRight: chat.user == true ? .right : .left, content: chat.content ?? "Error loading message")
                                    }
                                    
                                   
                                    if loadingState == .loading {
                                        ActivityIndicatorView(isVisible: $isLoadingForIndicator, type: .rotatingDots(count: 5))
                                            .frame(width: 50.0, height: 50.0)
                                            .foregroundColor(.primaryOrange)

                                    }
    
                                    if loadingState == .error {
                                        Text("Error happend")
                                            .font(Font.mainFont(12))
                                            .foregroundColor(.primaryOrange)
                                            .tracking(1)

                                    }
                                    Color.clear
                                        .id(chats.count)
                                }
                            }
                            
                        }
                        
                        .scrollIndicators(.hidden)
                        .onTapGesture {
                            focused = false
                        }
                        .onChange(of: chats.count) { _ in
                            withAnimation {
                                proxy.scrollTo(chats.count)
                            }
                         
                              
                        }
                        .onAppear {
                            proxy.scrollTo(chats.count)
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
                            sendChat()
                        }
                    
                }
                
                .background(Color.primaryGray)
                .cornerRadius(30)
                .padding(.horizontal, 10)
                
            }
            .padding([.bottom], 20)
            .alert("Sure to clear chats history?", isPresented: $showAlert) {
                Button("Cancel", role: .destructive) {}
                    .foregroundColor(.red)
                Button("OK", role: .cancel) {
                    if chats.count != 0 {
                        deletelAllChats()
                    }
                  
                }
               
            }
            
        }
    }
    
    
    func sendChat() {
        if prompt != "" {
            let newUserChat = Chats(context: moc)
            newUserChat.content = prompt
            newUserChat.timestamp = Date().timeIntervalSince1970
            newUserChat.user = true
            newUserChat.id = UUID()
            callOpenAIChatEndpoint()
            prompt = ""
        }
    }
    
    
    
    func callOpenAIChatEndpoint() {
        scrollToBottom = true
        loadingState = .loading
        let apiKey = ""
        let endpointURL = URL(string: "https://api.openai.com/v1/chat/completions")!
        
        var request = URLRequest(url: endpointURL)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        var messageArray = chats.map {
            ["role" : $0.user == true ? "user" : "system", "content": $0.content ?? ""]
        }
        messageArray.append(["role" : "user", "content": prompt])
        
        let body: [String: AnyHashable] = [
            "model": "gpt-3.5-turbo",
            "messages": messageArray
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        
        
        let task = URLSession.shared.dataTask(with: request) { (data, _, error) in
            guard let data = data, error == nil else {
                loadingState = .error
                return
            }
            
            do {
                let res = try JSONDecoder().decode(ChatResponse.self, from: data)
                let newChat = Chats(context: moc)
                newChat.user = false
                newChat.content = res.choices[0].message.content
                newChat.id = UUID()
                
                let timestamp = Date().timeIntervalSince1970
                newChat.timestamp = timestamp
                do {
                    try moc.save()
                    
                } catch {
                    print(error.localizedDescription, "when saving chat")
                }
                loadingState = .success
                
            } catch {
                print(error)
                loadingState = .error
            }
          
        }
        task.resume()
    }
    
    
    func deletelAllChats() {
        for chat in chats {
            moc.delete(chat)
        }
        
        do {
            try moc.save()
        } catch {
            print(error.localizedDescription, "when deletinf history")
        }
       
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
                .textSelection(.enabled)
            
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
