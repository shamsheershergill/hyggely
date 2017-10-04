//
//  FirstViewController.swift
//  hyggely
//
//  Created by Shamsheer on 2017-09-26.
//  Copyright © 2017 Shamsheer. All rights reserved.
//
//this is the first home screen with tabbed view

import UIKit

class FirstViewController: UIViewController, UITableViewDataSource {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    let chats = [
        ( "Mary Beth", "I like long walks on the beach"),
        (    "John Snow", "I know nothing"),
         ( "Michael Scott", "I can show you around with my gf Jan")
    ]
    
    let maps = [
        ("Tom Harrison", "I can take you around Lison"),
        ("Jack Sparrow", "I can take you around Milan"),
        ("Brittany Spears", "I can take you around SF"),
        ("Mary Spears", "I can take you around Berlin"),
        ("Annoying GUY", "I can take you around Ibiza")
    ]
    
    func numberOfSections(in tableView: UITableView) -> Int {
        //return the number of sections in the table
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        
   return chats.count
     
    }
    
    func tableView( _ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        //perform logic here to actually display the data
       
        var cell = UITableViewCell()
            cell.textLabel?.text = chats[indexPath.row].0 + chats[indexPath.row].1
        
        return cell
    }
    
   
    
    @IBOutlet var tableView: UIView!
    //@IBOutlet var mapView: UIView!
  
    
  
    @IBAction func homeScreenToggle(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0{
          
            
        }
        else{
            
       
        }
    }
    
    
}

