//
//  ContactGroupTableViewController.swift
//  GroupText
//
//  Created by Tristan Ludowyk on 25/07/2016.
//  Copyright © 2016 Room 401. All rights reserved.
//

import UIKit
import ContactsUI
import MessageUI

class ContactGroupTableViewController: UITableViewController, CNContactPickerDelegate, MFMessageComposeViewControllerDelegate {

    var contactGroups: [ContactGroup] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.leftBarButtonItem = self.editButtonItem
        
        // Load data from NSCoding if it exists
        if let savedContactGroups = loadContactGroups() {
            contactGroups += savedContactGroups
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createNewMessage(_ recipients: [String]) {
        if !MFMessageComposeViewController.canSendText() {
            let warningAlertController = UIAlertController(title: "Error", message: "Your device doesn't support SMS", preferredStyle: .alert)
            present(warningAlertController, animated: true, completion: nil)
            return
        }
    
        let messageController = MFMessageComposeViewController()
        messageController.messageComposeDelegate = self;
        messageController.recipients = recipients
    
        // Present message view controller on screen
        self.present(messageController, animated: true, completion: nil)
    }
    
    // MARK: Message Copose View Controller Delegate
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactGroups.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactGroupCell", for: indexPath)

        // Configure the cell...
        let contactGroup = contactGroups[indexPath.row]
        cell.textLabel?.text = contactGroup.name
        cell.detailTextLabel?.text = String(contactGroup.contacts.count)

        return cell
    }
    
    // MARK: Table View Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Create recipients array
        var recipients: [String] = []
        
        let contactGroup = contactGroups[indexPath.row]
        
        for contact in contactGroup.contacts {
            let phoneNumber = contact.phoneNumbers[0].value.stringValue
			recipients.append(phoneNumber)
		}
        
        createNewMessage(recipients)
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let contactGroup = contactGroups[indexPath.row]
        
        // Show the detail view controller
        let contactGroupViewController = self.storyboard?.instantiateViewController(withIdentifier: "ContactGroupDetail") as! ContactGroupViewController
        contactGroupViewController.contactGroup = contactGroup

        self.navigationController?.pushViewController(contactGroupViewController, animated: true)
        //presentViewController(contactGroupViewController, animated: true, completion: nil)
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: Actions

    @IBAction func unwindToContactGroups(_ sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? ContactGroupViewController, let contactGroup = sourceViewController.contactGroup {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                contactGroups[selectedIndexPath.row] = contactGroup
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            }
            else {
                // Add a new contact group
                let newIndexPath = IndexPath(row: contactGroups.count, section: 0)
                contactGroups.append(contactGroup)
                tableView.insertRows(at: [newIndexPath], with: .bottom)
            }
            
            // Save the contact groups
            saveContactGroups()
        }
    }
    
    // MARK: NSCoding
    
    func saveContactGroups() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(contactGroups, toFile: ContactGroup.ArchiveURL.path)
        
        if !isSuccessfulSave {
            print("Failed to save contact groups")
        }
    }
    
    func loadContactGroups() -> [ContactGroup]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: ContactGroup.ArchiveURL.path) as? [ContactGroup]
    }
    

}
