//
//  Contact.swift
//  hyggely
//
//  Created by Shamsheer on 2017-10-02.
//  Copyright © 2017 Shamsheer. All rights reserved.
//

import Foundation

class Contact {
    
    private var _name = "";
    private var _id = "";
    private var _url = "";
    private var _desc = "";
    private var _paid = false;
    private var _service = "";
    private var _otherPartyName = "";
    private var _longLocation = 0.0;
    private var _latLocation = 0.0;
    
    init(id: String, name: String, url: String, desc: String, paid: Bool, service: String, otherPartyName: String, longLocation: Double, latLocation: Double) {
        _id = id;
        _name = name;
        _url = url;
        _desc = desc;
        _paid = paid;
        _service = service;
        _otherPartyName = otherPartyName;
        _longLocation = longLocation;
        _latLocation = latLocation;
    }
    
    var name: String {
        get {
            return _name;
        }
    }
    
    var id: String {
        return _id;
    }
    
    var url: String{
        get{
            return _url
        }
    }
    
    var desc: String {
        get{
            return _desc
        }
    }
    
    var paid: Bool {
        return _paid
    }
    
    var otherPartyName: String{
        get{
            return _otherPartyName
        }
    }
  
    var latLocation: Double{
        return _latLocation
    }
    
    var longLocation: Double{
        return _longLocation
    }
}
