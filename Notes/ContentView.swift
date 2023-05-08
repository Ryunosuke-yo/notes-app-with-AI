//
//  ContentView.swift
//  Notes
//
//  Created by Ryunosuke Yokokawa on 2023-04-30.
//

import SwiftUI

struct ContentView: View {
   
    init() {
        UITabBar.appearance().backgroundColor = .primaryGray
        UITabBar.appearance().unselectedItemTintColor = .secondaryWhite
        
    }
    
   
    var body: some View {
        ZStack {
            Color.primaryBlcak
            VStack {
                TabView {
                    NavigationStack {
                            NoteView()
                    }
                        .tabItem {
                            Image(systemName: "note")
                            Text("Notes")
                             
                        }
                        .toolbarBackground(.hidden, for: .tabBar)
                    
                    
                    ChatView()
                        .tabItem {
                            Image(systemName: "bubble.left")
                            Text("Chat")
                        }
                        .toolbarBackground(.hidden, for: .tabBar)
                }
                
                
            }
            
        }
        
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
