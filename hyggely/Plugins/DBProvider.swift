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
        return Storage.storage().reference(forURL: "gs:chat-38e12.appspot.com");
        //https://chat-38e12.firebaseio.com/

    }
    


    func saveUser(withID: String, email: String, password: String) {
        let data: Dictionary<String, Any> = [Constants.EMAIL: email, Constants.PASSWORD: password];
        
        contactsRef.child(withID).setValue(data);
    }
    
    func getContacts() {
        
        contactsRef.observeSingleEvent(of: DataEventType.value) {
            (snapshot: DataSnapshot) in
            var contacts = [Contact]();
            
            if let myContacts = snapshot.value as? NSDictionary {
                
                for (key, value) in myContacts {
                    
                    if let contactData = value as? NSDictionary {
                        
                        if let email = contactData[Constants.EMAIL] as? String {
                            
                            let id = key as! String;
                            let newContact = Contact(id: id, name: email);
                            contacts.append(newContact);
                        }
                    }
                }
            }
            self.delegate?.dataReceived(contacts: contacts);
        }
        
    }
    
}

















































