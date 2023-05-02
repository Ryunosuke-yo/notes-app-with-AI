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
            VStack {
                TabView {
                    NoteView()
                        .tabItem {
                            Image(systemName: "note")
                            Text("Notes")
                        }
                    
                    
                    Text("Chat")
                          .tabItem {
                              Image(systemName: "bubble.left")
                              Text("Chat")
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
