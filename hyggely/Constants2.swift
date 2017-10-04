//
//  Constants.swift
//  hyggely
//
//  Created by Shamsheer on 2017-09-28.
//  Copyright © 2017 Shamsheer. All rights reserved.
//

import Foundation
import Firebase

struct Constants2
{
    struct refs
    {
        static let databaseRoot = Database.database().reference()
        static let databaseChats = databaseRoot.child("chats")
    }
}
