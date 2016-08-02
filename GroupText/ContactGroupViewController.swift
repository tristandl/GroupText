//
//  ContactGroupViewController.swift
//  GroupText
//
//  Created by Tristan Ludowyk on 25/07/2016.
//  Copyright © 2016 Room 401. All rights reserved.
//

import UIKit
import Contacts
import ContactsUI

class ContactGroupViewController: UIViewController, UITableViewDataSource, CNContactPickerDelegate {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var contacts: [CNContact]?
    
    var contactGroup: ContactGroup?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        nameTextField?.text = contactGroup?.name
        contacts = contactGroup?.contacts
        
        tableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let name = nameTextField.text ?? ""
        
        if let contacts = contacts {
            contactGroup = ContactGroup(name: name, withContacts: contacts)
        } else {
            print("Contact group not set")
        }
    }
    @IBAction func selectContactsTapped(sender: UIButton) {
        let contactPicker = CNContactPickerViewController()
        contactPicker.delegate = self
        contactPicker.predicateForEnablingContact = NSPredicate(format: "phoneNumbers.@count > 0")
        self.presentViewController(contactPicker, animated: true, completion: nil)
    }
    
    // Uncomment the below to add support for presenting in a nav controller for editing
    // rather than adding
    @IBAction func cancelTapped(sender: UIBarButtonItem) {
        let isPresentingInAddMode = presentingViewController is UINavigationController
        
        if isPresentingInAddMode {
            dismissViewControllerAnimated(true, completion: nil)
        }
        else {
            navigationController!.popViewControllerAnimated(true)
        }
    }
    
    // MARK: Table View Delegate
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts?.count ?? 0
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ContactDetailCell")!
        
        guard let contact = contacts?[indexPath.row] else {
            return cell
        }
        
        if contact.imageDataAvailable {
            cell.imageView?.image = UIImage(data:contact.thumbnailImageData!)
        }
        
        cell.textLabel?.text = CNContactFormatter.stringFromContact(contact, style: .FullName)
        cell.detailTextLabel?.text = (contact.phoneNumbers[0].value as? CNPhoneNumber)?.stringValue
        
        return cell
    }
    
    // MARK: Contact Picker Delegate
    func contactPicker(picker: CNContactPickerViewController, didSelectContacts contacts: [CNContact]) {
        // Add the contacts list to the contacts groups array
        self.contacts = contacts
        
        // Reload the table in the main thread
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            // I don't think you need to use a weak self in here because this block won't hang around very long
            // compared to the lifecycle of the view controller
            self.tableView.reloadData()
        }
    }
}
