//
//  Folder+CoreDataProperties.swift
//  Notes
//
//  Created by Ryunosuke Yokokawa on 2023-05-23.
//
//

import Foundation
import CoreData


extension Folder {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Folder> {
        return NSFetchRequest<Folder>(entityName: "Folder")
    }

    @NSManaged public var folderName: String?
    @NSManaged public var note: NSSet?
    
    
    public var wrappedFolderNeme: String {
        folderName ?? ""
    }
    
    public var noteArray: [Note] {
        let set = note as? Set<Note> ?? []
//        print(set)
        
    
        
        return  Array(set)
    }
    


}

// MARK: Generated accessors for note
extension Folder {

    @objc(addNoteObject:)
    @NSManaged public func addToNote(_ value: Note)

    @objc(removeNoteObject:)
    @NSManaged public func removeFromNote(_ value: Note)

    @objc(addNote:)
    @NSManaged public func addToNote(_ values: NSSet)

    @objc(removeNote:)
    @NSManaged public func removeFromNote(_ values: NSSet)

}

extension Folder : Identifiable {

}
