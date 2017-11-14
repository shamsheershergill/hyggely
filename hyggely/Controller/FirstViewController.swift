//
//  FirstViewController.swift
//  hyggely
//
//  Created by Shamsheer on 2017-09-26.
//  Copyright © 2017 Shamsheer. All rights reserved.
//
//this is the first home screen with tabbed view

import UIKit
import MapKit

class FirstViewController: UIViewController {

    
    @IBOutlet weak var chatsVC: UIView!
    @IBOutlet weak var meetupsVC: UIView!
    
    @IBAction func logOut(_ sender: Any) {
        if AuthProvider.Instance.logOut() {
            dismiss(animated: true, completion: nil);
        }
    }
    
    @IBAction func chatsToggle(_ sender: UISegmentedControl) {
        switch(sender.selectedSegmentIndex)
        {
        case 0:
            self.meetupsVC.alpha = 0
            self.chatsVC.alpha = 1
            break
        case 1:
            self.meetupsVC.alpha = 1
            self.chatsVC.alpha = 0
            break;
        default:
            break;
        }
    }
    
    
    
}
    


    


    


