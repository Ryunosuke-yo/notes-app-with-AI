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
    @NSManaged public var color: String?
    @NSManaged public var timestamp: String?
    @NSManaged public var title: String?
    @NSManaged public var noteInFolder: Folder?
  
    
    
    public var wrappedTitle: String {
        title ?? "Unknown"
    }
    
    public var wrappedContents: String {
        contents ?? "Unknown"
    }
    
    public var wrappedFolder: String {
        folder ?? "Unknown"
    }
    
    public var wrappedTimestamp: String {
        timestamp ?? "Unknown"
    }
    
    public var wrappedColor: String {
        color ?? "primaryOrange"
    }
    
 
    

    
}

extension Note : Identifiable {

}
