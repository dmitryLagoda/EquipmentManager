//
//  EMManageEquipmentViewController.swift
//  EquipmentManager
//
//  Created by lsd on 3/20/15.
//  Copyright (c) 2015 lsd. All rights reserved.
//

import UIKit
import Parse

class EMManageEquipmentViewController: UITableViewController
{
    override func viewWillAppear(animated: Bool)
    {
        
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let controller = self.navigationController
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
//        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent;
        self.navigationItem.title = "Manage equipment"
        
        //self.navigationItem.leftBarButtonItem = self.editButtonItem()
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "addNewObject:")
        
        self.navigationItem.rightBarButtonItems = [self.editButtonItem(), addButton]
        
        self.updateData()
    }
    
    func addNewObject(sender: AnyObject)
    {
        let count: Int = EMEquipmentManager.sharedInstance.equipmentCount()
        EMEquipmentManager.sharedInstance.addEquipmentWith("Equipment \(count+1)", group: "Electric")
        
        let indexPath = NSIndexPath(forRow: count, inSection: 0)
        
        self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
    }

    //MARK: - Table View
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return EMEquipmentManager.sharedInstance.equipmentCount()
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("EMManageEquipmentTableCell", forIndexPath: indexPath) as UITableViewCell
        
        let oneEquipment :EMEquipment = EMEquipmentManager.sharedInstance.equipmentList()[indexPath.row]
        cell.textLabel?.text = oneEquipment.name
        
        if (oneEquipment.assignedToUser == PFUser.currentUser())
        {
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
        }
        else
        {
            cell.accessoryType = UITableViewCellAccessoryType.None
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath)
    {
        if editingStyle == .Delete
        {
            EMEquipmentManager.sharedInstance.removeEquipmentAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    override func tableView(tableView: UITableView, didHighlightRowAtIndexPath indexPath: NSIndexPath)
    {
        let selectedEquipment :EMEquipment = EMEquipmentManager.sharedInstance.equipmentList()[indexPath.row]
        
        if (selectedEquipment.assignedToUser != PFUser.currentUser())
        {
            EMEquipmentManager.sharedInstance.assignEquipmentAt(indexPath.row, isCurrentUser: true)
        }
        else
        {
            EMEquipmentManager.sharedInstance.assignEquipmentAt(indexPath.row, isCurrentUser: false)
        }
        
        tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
 
    }

    //MARK: - Other methods
    func updateData()
    {
        EMEquipmentManager.sharedInstance.fetchEquipmentListInMainThread()
    }
}
