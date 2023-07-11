//
//  ChatView.swift
//  Notes
//
//  Created by Ryunosuke Yokokawa on 2023-05-02.
//

import SwiftUI
import ActivityIndicatorView


struct ChatView: View {
    @Binding var selectedTab: Int
    @FocusState private var focused: Bool
    @FetchRequest(sortDescriptors: [
        SortDescriptor(\.date)], animation: .easeInOut) var chats: FetchedResults<Chats>
    @Environment(\.managedObjectContext) var moc
    @Namespace var bottomID
    @StateObject var viewModel = ChatViewModel()
    
    
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
                            viewModel.showAlert = true
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
                                
                                
                                if viewModel.loadingState == .loading {
                                    ActivityIndicatorView(isVisible: $viewModel.isLoadingForIndicator, type: .rotatingDots(count: 5))
                                        .frame(width: 50.0, height: 50.0)
                                        .foregroundColor(.primaryOrange)
                                    
                                }
                                
                                if viewModel.loadingState == .error {
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
                    DynamicHeightTextEditor(text: $viewModel.prompt, placeholder: "Ask anything", maxHeight: viewModel.maxHeight)
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
                            Task {
                                do {
                                    try await viewModel.sendChat(moc: moc, chats: chats)
                                } catch {
                                    viewModel.isError()
                                }
                            }
                            
                            
                        }
                    
                }
                
                .background(Color.primaryGray)
                .cornerRadius(30)
                .padding(.horizontal, 10)
                
            }
            .padding([.bottom], 20)
            .alert("Sure to clear chats history?", isPresented: $viewModel.showAlert) {
                Button("OK", role: .destructive) {
                    if chats.count != 0 {
                        viewModel.deletelAllChats(moc: moc, chats: chats)
                    }
                    Button("Cancel", role: .cancel) {}
                    
                    
                    
                }
                
            }
            
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
