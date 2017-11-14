//
//  ChatsVC.swift
//  hyggely
//
//  Created by Shamsheer on 2017-10-06.
//  Copyright © 2017 Shamsheer. All rights reserved.
//

import UIKit
import FirebaseAuth

class ChatsVC: UIViewController, UITableViewDelegate, UITableViewDataSource, FetchData{
   
    //this screen shows everyone available to chat (unpaid yet)
    @IBOutlet weak var myTable: UITableView!
    private let CELL_ID = "Cell";
    private let CHAT_SEGUE = "ChatSegue";
    
    private var contacts = [Contact]();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //check if host or traveler here and display contacts
        
        var isHost = false
        let userID = Auth.auth().currentUser?.uid
        DBProvider.Instance.contactsRef.child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            if(snapshot.exists())
            {
             let userDict = snapshot.value as! [String: Any]
               let dbHost = userDict["isHost"] as? String
                print ("DIS BE DA HOST")
                print(dbHost)
                  let isHost = ( dbHost == "true")

            }
            
        })
        DBProvider.Instance.delegate = self;
        
        DBProvider.Instance.getContacts(isHost: isHost);
       
    }
    
    func dataReceived(contacts: [Contact]) {
        self.contacts = contacts;
        
        // get the name of current user
        for contact in contacts {
            if contact.id == AuthProvider.Instance.userID() {
                AuthProvider.Instance.userName = contact.name;
            }
        }
        
        myTable.reloadData();
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       print (contacts.count, "this many rows in chatsvc")
        return contacts.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier]
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_ID, for: indexPath);
        
        cell.textLabel?.text = contacts[indexPath.row].name;
        
        return cell;
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            
        let storyboardd : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let nextVC = storyboardd.instantiateViewController(withIdentifier: "BookVC") as! BookVC
        
        nextVC.imageURL = contacts[indexPath.row].url
        print(contacts[indexPath.row].name, contacts[indexPath.row].desc)
        nextVC.descr = contacts[indexPath.row].desc
        nextVC.name = contacts[indexPath.row].name
        nextVC.service = "chat"
        print ("TRYING TO GET BOOK VC")
        self.present(nextVC, animated: false, completion: nil)
    }
    
    

}
