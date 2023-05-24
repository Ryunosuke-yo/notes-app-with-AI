//
//  DataController.swift
//  Notes
//
//  Created by Ryunosuke Yokokawa on 2023-05-21.
//

import Foundation
import CoreData


class DataController: ObservableObject {
    let container = NSPersistentContainer(name: "Note")
    
    init() {
        container.loadPersistentStores { desc, error in
            if let error = error {
                print("Fatal error: \(error.localizedDescription)")
            }
        }
        
        self.container.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
    }
}
