//
//  ContactGroup.swift
//  GroupText
//
//  Created by Tristan Ludowyk on 25/07/2016.
//  Copyright © 2016 Room 401. All rights reserved.
//

import Foundation
import ContactsUI

class ContactGroup: NSObject, NSCoding {
    
    // MARK: Types
    
    struct PropertyKey {
        static let nameKey = "name"
        static let contactsKey = "contacts"
    }
    
    var name: String
    var contacts: [CNContact]
    
    
    // MARK: Archiving Paths
    
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("contactGroups")
    
    // MARK: Initialisers
    
    @objc init(name: String, withContacts contacts: [CNContact]) {
        self.name = name
        self.contacts = contacts
    }
    
    convenience required init?(coder aDecoder: NSCoder) {
        let name = aDecoder.decodeObjectForKey(PropertyKey.nameKey) as! String
        let contacts = aDecoder.decodeObjectForKey(PropertyKey.contactsKey) as! [CNContact]
        
        self.init(name: name, withContacts: contacts)
    }
    
    // MARK: NSCoding
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(name, forKey: PropertyKey.nameKey)
        aCoder.encodeObject(contacts, forKey: PropertyKey.contactsKey)
    }
    
}