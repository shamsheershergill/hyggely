//
//  ContactsVC.swift
//  hyggely
//
//  Created by Shamsheer on 2017-09-28.
//  Copyright © 2017 Shamsheer. All rights reserved.
//

import UIKit
import FirebaseAuth

class ContactsVController: UIViewController, UITableViewDelegate, UITableViewDataSource, FetchData  {
    
    //this is where the paid list should appear
    @IBOutlet weak var myTable: UITableView!
    private let CELL_ID = "Cell";
    private let CHAT_SEGUE = "ChatSegue";
    var userID = ""
    var isHost = false
    var hostName = ""
    var currentUserPaid = false
    private var paidContacts = [Contact]();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //check if host or traveler here and display contacts

        
        userID = (Auth.auth().currentUser?.uid)!
        DBProvider.Instance.contactsRef.child(userID).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if(snapshot.exists())
            {
                let userDict = snapshot.value as! [String: Any]
                self.currentUserPaid = (userDict["paid"] as? Bool)!
                let dbHost = userDict["isHost"] as? String
                print ("DIS BE DA HOST contactsVC")
                print(dbHost)
                
                let isHost = ( dbHost == "true")
                print(isHost)
                self.currentUserPaid = self.currentUserPaid && isHost

            }
            
        })
        DBProvider.Instance.delegate = self;
        
       DBProvider.Instance.getContacts(isHost: isHost);
    }
    
    func dataReceived(contacts: [Contact]) {
        self.paidContacts = contacts;
        var currentIndex = 0
        var currentUserPaid = false
        
        // get the name of current user
        for contact in paidContacts {
            if contact.id == AuthProvider.Instance.userID() {
                AuthProvider.Instance.userName = contact.name;
               
            }
            if(currentUserPaid)
            {
                hostName = DBProvider.Instance.ridersRef.child(userID).value(forKey: "hostName") as! String
                if (hostName != contact.name)
                {
                    paidContacts.remove(at: currentIndex)
                }
            }
            currentIndex = currentIndex + 1
        }
        
        
        myTable.reloadData();
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return paidContacts.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
       // UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier]
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_ID, for: indexPath);
        
        cell.textLabel?.text = paidContacts[indexPath.row].name;
        
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: CHAT_SEGUE, sender: nil);
    }
    
    @IBAction func logout(_ sender: Any) {
        if AuthProvider.Instance.logOut() {
            dismiss(animated: true, completion: nil);
        }
    }
    
}
