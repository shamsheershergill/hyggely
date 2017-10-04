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
    
    init(id: String, name: String) {
        _id = id;
        _name = name;
    }
    
    var name: String {
        get {
            return _name;
        }
    }
    
    var id: String {
        return _id;
    }
    
}
