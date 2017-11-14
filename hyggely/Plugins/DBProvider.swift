//

import Foundation
import FirebaseDatabase
import FirebaseStorage

protocol FetchData: class {
    func dataReceived(contacts: [Contact]);
}

class DBProvider {
    
    private static let _instance = DBProvider();
    
    weak var delegate: FetchData?;
    
    private init() {}
    
    static var Instance: DBProvider {
        return _instance;
    }
    
    var dbRef: DatabaseReference {
        return Database.database().reference();
    }
    
    var contactsRef: DatabaseReference {
        return dbRef.child(Constants.CONTACTS);
    }
    
    var messagesRef: DatabaseReference {
        return dbRef.child(Constants.MESSAGES);
    }
    
    var storageRef: StorageReference {
        return Storage.storage().reference();
        //https://chat-38e12.firebaseio.com/

    }
    
    var ridersRef: DatabaseReference {
        return dbRef.child(Constants.TRAVELERS);
    }
    
    var driversRef: DatabaseReference {
        return dbRef.child(Constants.HOSTS);
    }
    
    var requestRef: DatabaseReference {
        return dbRef.child(Constants.HYGGE_REQUEST);
    }
    
    var requestAcceptedRef: DatabaseReference {
        return dbRef.child(Constants.HYGGE_ACCEPTED);
    }
    
    var usersRef: DatabaseReference {
        return dbRef.child(Constants.USERS)
    }

    func saveUser(withID: String, email: String, password: String) {
        let data: Dictionary<String, Any> = [Constants.EMAIL: email, Constants.PASSWORD: password, Constants.isHost: "true"];
        
        contactsRef.child(withID).setValue(data);
    }
    
 
   /* //local
    func saveLUser(withID: String, email: String, password: String) {
        let data: Dictionary<String, Any> = [Constants.EMAIL: email, Constants.PASSWORD: password, Constants.isRider: true];
        ridersRef.child(withID).child(Constants.DATA).setValue(data);
    }
    
    //traveler
    func saveTUser(withID: String, email: String, password: String) {
        let data: Dictionary<String, Any> = [Constants.EMAIL: email, Constants.PASSWORD: password, Constants.isRider: false];
        driversRef.child(withID).child(Constants.DATA).setValue(data);
    }
 */
    
    func getContacts(isHost: Bool) {
        var ref = driversRef
        if (isHost) {
           ref  = driversRef
        }
        else{
            ref = ridersRef
        }
        ref.observeSingleEvent(of: DataEventType.value) {
            (snapshot: DataSnapshot) in
            var contacts = [Contact]();
            
            if  var myContacts = snapshot.value as? NSDictionary {
                
                for (key, value) in myContacts {
                    
                    if  var contactData = value as? NSDictionary {
                        
                        if let name = contactData[Constants.NAME] as? String {
                            if let URL = contactData["URL"] as? String{
                                if let desc = contactData[Constants.DESCRIPTION] as? String{
                                    if let paid = contactData["paid"] as? Bool {
                                        if let service = contactData["service"] as? String
                                        {
                                            if let otherPartyName = contactData["otherPartyName"] as? String {
                                           let longLocation = contactData["longLocation"] as? Double
                                                let latLocation = contactData["latLocation"] as? Double
                                           
                                                let id = key as! String;
                                                let newContact = Contact(id: id, name: name, url: URL, desc: desc, paid: paid, service: service, otherPartyName: otherPartyName, longLocation: longLocation!, latLocation: latLocation!);
                                            contacts.append(newContact);
                                            
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            self.delegate?.dataReceived(contacts: contacts);
        }
        
    }
    
   
}

















































