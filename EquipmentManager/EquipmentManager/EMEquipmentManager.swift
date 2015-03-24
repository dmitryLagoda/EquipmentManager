//
//  EMEquipmentManager.swift
//  EquipmentManager
//
//  Created by lsd on 3/20/15.
//  Copyright (c) 2015 lsd. All rights reserved.
//

import UIKit
import Parse

enum EMParseClassConstants :String
{
    case Equipment = "EMEquipmentClass"
}

class EMEquipmentManager: NSObject
{
    private var m_EquipmentArray = [EMEquipment]()
    
    
//////************************************************////
    class var sharedInstance: EMEquipmentManager
    {
        struct Singleton
        {
            static let instance = EMEquipmentManager()
        }

        return Singleton.instance
    }
    
    func equipmentList() -> [EMEquipment]
    {
        return self.m_EquipmentArray
    }
    
    func equipmentList(syncronized: Bool) ->[EMEquipment]
    {
        if (syncronized)
        {
            self.fetchEquipmentListInMainThread()
        }
        
        return self.m_EquipmentArray
    }
    
    func equipmentCount() ->Int
    {
        return self.m_EquipmentArray.count
    }
    
    func addEquipment(equipment: EMEquipment)
    {
        self.m_EquipmentArray.append(equipment)
        
        // Create a new PFObject to represent this To-Do item.
        var equipmentObject :PFObject = PFObject(className: EMParseClassConstants.Equipment.rawValue)
        equipmentObject.setObject(equipment.name, forKey: "name")
        equipmentObject.setObject(equipment.group, forKey: "group")
    
        equipmentObject.saveInBackgroundWithBlock {
            (success: Bool, error: NSError!) -> Void in
            if (success)
            {
                equipment.objectID = equipmentObject.objectId
            }
            else
            {
                // There was a problem, check error.description
            }
        }
    }
    
    func addEquipmentWith(name: String, group: String)
    {
        let newEquipment = EMEquipment(name: name, group: group)
        
        self.addEquipment(newEquipment)
    }
    
    func removeEquipmentAtIndex(index: Int)
    {
        if (index >= self.m_EquipmentArray.count)
        {
            return
        }
        
        var equipment = self.m_EquipmentArray[index]
        
        if (!equipment.objectID.isEmpty)
        {
            let query: PFQuery = PFQuery(className: EMParseClassConstants.Equipment.rawValue)
            query.getObjectInBackgroundWithId(equipment.objectID) {
                (equipmentObject: PFObject!, error: NSError!) -> Void in
                if error == nil && equipmentObject != nil
                {
                    equipmentObject.deleteInBackground()
                    //println(gameScore)
                }
                else
                {
                    println(error)
                }
            }
            //let equipmentObject :PFObject = query.getObjectInBackgroundWithId(equipment.objectID).result as PFObject
        }
        
        self.m_EquipmentArray.removeAtIndex(index)
    }
    
    func fetchEquipmentListInMainThread()
    {
        var query: PFQuery = PFQuery(className: EMParseClassConstants.Equipment.rawValue)
        
//        query.cachePolicy = PFCachePolicy.CacheThenNetwork
        query.orderByAscending("createdAt")
        let equipmentList = query.findObjects()
        
        self.m_EquipmentArray.removeAll(keepCapacity: false)

        for equipment in equipmentList
        {
            let equipmentObject :PFObject = equipment as PFObject
            let sName = equipmentObject.objectForKey("name") as String
            let sGroup = equipmentObject.objectForKey("group") as String
            
            // TO DO: verify all!
            let newEquipment = EMEquipment(name: sName, group: sGroup)
            newEquipment.objectID = equipmentObject.objectId
            
            self.m_EquipmentArray.append(newEquipment)
        }
    }
    
    func assignEquipmentAt(index: Int, isCurrentUser: Bool)
    {
        let equipment = self.m_EquipmentArray[index]
        
        if (!isCurrentUser)
        {
            equipment.unassignFromUser()
        }
        else
        {
            equipment.assignedToUser = PFUser.currentUser()
        }
        
        if (!equipment.objectID.isEmpty)
        {
            let query: PFQuery = PFQuery(className: EMParseClassConstants.Equipment.rawValue)
            query.getObjectInBackgroundWithId(equipment.objectID) {
                (equipmentObject: PFObject!, error: NSError!) -> Void in
                if error == nil && equipmentObject != nil
                {
                    equipmentObject.setObject(equipment.assignedToUser, forKey: "AssignedToUser")
                    equipmentObject.saveInBackground()
                }
                else
                {
                    println(error)
                }
            }
        }
    }
   
    
}
