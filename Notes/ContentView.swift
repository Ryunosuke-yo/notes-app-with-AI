//
//  ContentView.swift
//  Notes
//
//  Created by Ryunosuke Yokokawa on 2023-04-30.
//

import SwiftUI

struct ContentView: View {
    @State private var tabSelection = 1
   
    
    init() {
        UITabBar.appearance().backgroundColor = .primaryGray
        UITabBar.appearance().unselectedItemTintColor = .secondaryWhite
        
    }
    
    
    var body: some View {
        ZStack {
            Color.primaryBlcak
            VStack {
                TabView(selection: $tabSelection) {
                    NavigationStack() {
                        NoteView()
                    }
                    .tabItem {
                        Image(systemName: "note")
                        Text("Notes")
                        
                    }
                    .toolbarBackground(.hidden, for: .tabBar)
                    .tag(1)
                    
                    
                    ChatView(selectedTab: $tabSelection)
                        .tabItem {
                            Image(systemName: "bubble.left")
                            Text("Chat")
                        }
                        .toolbarBackground(.hidden, for: .tabBar)
                        .tag(2)
                    
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
