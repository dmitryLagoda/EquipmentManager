//
//  EMEquipment.swift
//  EquipmentManager
//
//  Created by lsd on 3/20/15.
//  Copyright (c) 2015 lsd. All rights reserved.
//

import UIKit
import Parse

class EMEquipment: NSObject
{
    var objectID :String = ""  //!! This object id is the same that is used in cloud store Parse
    var name :String!
    var group :String!
    var assignedToUser :PFUser?
    
    init(name: String, group: String)
    {
        super.init()
        
        self.name = name
        self.group = group
        self.assignedToUser = nil//PFUser(className: "DummyUser")
    }

    func unassignFromUser()
    {
        self.assignedToUser = nil//PFUser(className: "DummyUser")
    }
}
