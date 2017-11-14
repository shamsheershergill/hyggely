//
//  MeetupsVC.swift
//  hyggely
//
//  Created by Shamsheer on 2017-10-06.
//  Copyright © 2017 Shamsheer. All rights reserved.
// meetups tab on home screen

import UIKit
import FirebaseDatabase
import MapKit

import FirebaseAuth

class MeetupsVC: UIViewController {

    //this screen is accessed from the home screen and a different version will be shown based on traveler or local
    
    @IBOutlet weak var RiderVC: UIView!
    @IBOutlet weak var DriverVC: UIView!
    //first pull up user and see if they are host or not
    override func viewDidLoad() {
   
            var isHost = false
        let userID = Auth.auth().currentUser?.uid
        DBProvider.Instance.contactsRef.child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            if(snapshot.exists())
            {
                let userDict = snapshot.value as? NSDictionary
                print(userDict)
                let dbHost = userDict!["isHost"] as? String
                print ("DIS BE DA HOST meetupsVC")
                print(dbHost)
                let isHost = ( dbHost == "true")
                print(isHost)
            }
            })
            
        print(isHost , "A HOST OR NOT")
    
        if ((isHost) )
    {
        self.RiderVC.alpha = 0
        self.DriverVC.alpha = 1
    }
    else{
            self.RiderVC.alpha = 1
            self.DriverVC.alpha = 0
    }
    }
    
   
   
}
