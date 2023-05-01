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
    }
    
    var body: some View {
            VStack {
                TabView {
                    Text("Notes")
                        .tabItem {
                            Image(systemName: "note")
                            Text("Notes")
                        }
                        .toolbarBackground(Color.red, for: .tabBar)
                    
                    Text("Second View")
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
