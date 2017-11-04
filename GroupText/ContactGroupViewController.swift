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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let name = nameTextField.text ?? ""
        
        if let contacts = contacts {
            contactGroup = ContactGroup(name: name, withContacts: contacts)
        } else {
            print("Contact group not set")
        }
    }
    @IBAction func selectContactsTapped(_ sender: UIButton) {
        let contactPicker = CNContactPickerViewController()
        contactPicker.delegate = self
        contactPicker.predicateForEnablingContact = NSPredicate(format: "phoneNumbers.@count > 0")
        self.present(contactPicker, animated: true, completion: nil)
    }
    
    // Uncomment the below to add support for presenting in a nav controller for editing
    // rather than adding
    @IBAction func cancelTapped(_ sender: UIBarButtonItem) {
        let isPresentingInAddMode = presentingViewController is UINavigationController
        
        if isPresentingInAddMode {
            dismiss(animated: true, completion: nil)
        }
        else {
            navigationController!.popViewController(animated: true)
        }
    }
    
    // MARK: Table View Delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts?.count ?? 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactDetailCell")!
        
        guard let contact = contacts?[indexPath.row] else {
            return cell
        }
        
        if contact.imageDataAvailable {
            cell.imageView?.image = UIImage(data:contact.thumbnailImageData!)
        }
        
        cell.textLabel?.text = CNContactFormatter.string(from: contact, style: .fullName)
        cell.detailTextLabel?.text = contact.phoneNumbers[0].value.stringValue
        
        return cell
    }
    
    // MARK: Contact Picker Delegate
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contacts: [CNContact]) {
        // Add the contacts list to the contacts groups array
        self.contacts = contacts
        
        // Reload the table in the main thread
        DispatchQueue.main.async { () -> Void in
            // I don't think you need to use a weak self in here because this block won't hang around very long
            // compared to the lifecycle of the view controller
            self.tableView.reloadData()
        }
    }
}
