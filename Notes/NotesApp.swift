//
//  NotesApp.swift
//  Notes
//
//  Created by Ryunosuke Yokokawa on 2023-04-30.
//

import SwiftUI

@main
struct NotesApp: App {
    @Environment(\.managedObjectContext) var moc
    @StateObject private var dataController = DataController()
    
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
                .environmentObject(EditMode())
        }
    }
}
