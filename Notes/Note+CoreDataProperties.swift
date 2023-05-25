//
//  Note+CoreDataProperties.swift
//  Notes
//
//  Created by Ryunosuke Yokokawa on 2023-05-23.
//
//

import Foundation
import CoreData


extension Note {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Note> {
        return NSFetchRequest<Note>(entityName: "Note")
    }

    @NSManaged public var contents: String?
    @NSManaged public var folder: String?
    @NSManaged public var id: UUID?
    @NSManaged public var timestamp: String?
    @NSManaged public var title: String?
    @NSManaged public var noteInFolder: Folder?
    
    
    public var wrappedTitle: String {
        title ?? ""
    }
    
    public var wrappedContents: String {
        contents ?? ""
    }
    
    public var wrappedFolder: String {
        folder ?? ""
    }
    

    
}

extension Note : Identifiable {

}
