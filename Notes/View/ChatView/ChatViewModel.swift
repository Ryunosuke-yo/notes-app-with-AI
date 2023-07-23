//
//  ChatViewModel.swift
//  Notes
//
//  Created by Ryunosuke Yokokawa on 2023-07-02.
//

import Foundation
import CoreData
import SwiftUI

extension ChatView {
    @MainActor class ChatViewModel: ObservableObject {
        @Published var textEditorHeight : CGFloat = 100
        @Published var prompt = ""
        @Published var aiResponse = ""
        @Published var loadingState: Loading = .idle
        @Published var scrollToBottom = false
        @Published var isLoadingForIndicator = true
        @Published var showAlert = false
        @Published var maxHeight : CGFloat = 250
        
        func sendChat(moc: NSManagedObjectContext, chats: FetchedResults<Chats>)async throws -> Void {
            if prompt != "" {
                let newUserChat = Chats(context: moc)
                newUserChat.content = prompt
                newUserChat.timestamp = Date().timeIntervalSince1970
                newUserChat.user = true
                newUserChat.id = UUID()
                newUserChat.date = Date()
                do {
                    try await callOpenAIChatEndpoint(moc: moc, chats: chats)
                    prompt = ""
                } catch {
                    isError()
                }
                
              
            }
        }
        
        func isError () {
            loadingState = .error
        }
        
        
        func callOpenAIChatEndpoint(moc: NSManagedObjectContext, chats: FetchedResults<Chats>) async throws -> Void {
            scrollToBottom = true
            loadingState = .loading
            let apiKey = OPEN_AI_API_KEY
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
            
            
            
            let(data, _) = try await URLSession.shared.data(for: request)
            
            
            
            do {
                let res = try JSONDecoder().decode(ChatResponse.self, from: data)
                let newChat = Chats(context: moc)
                newChat.user = false
                newChat.content = res.choices[0].message.content
                newChat.id = UUID()
                newChat.date = Date()
                
                let timestamp = Date().timeIntervalSince1970
                newChat.timestamp = timestamp
                do {
                    try moc.save()
                    
                } catch {
                 
                }
                loadingState = .success
                
            } catch {
                loadingState = .error
            }
            
        }
        
        
        
        
        func deletelAllChats(moc: NSManagedObjectContext, chats: FetchedResults<Chats>) {
            for chat in chats {
                moc.delete(chat)
            }
            
            do {
                try moc.save()
            } catch {
          
            }
            
        }
    }
}
