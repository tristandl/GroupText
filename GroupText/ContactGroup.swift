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
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("contactGroups")
    
    // MARK: Initialisers
    
	init(name: String, withContacts contacts: [CNContact]) {
        self.name = name
        self.contacts = contacts
    }
    
    convenience required init?(coder aDecoder: NSCoder) {
        let name = aDecoder.decodeObject(forKey: PropertyKey.nameKey) as! String
        let contacts = aDecoder.decodeObject(forKey: PropertyKey.contactsKey) as! [CNContact]
        
        self.init(name: name, withContacts: contacts)
    }
    
    // MARK: NSCoding
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: PropertyKey.nameKey)
        aCoder.encode(contacts, forKey: PropertyKey.contactsKey)
    }
    
}
