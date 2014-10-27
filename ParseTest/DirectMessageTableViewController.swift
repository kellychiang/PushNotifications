//
//  DirectMessageTableViewController.swift
//  PushNotifications
//
//  Created by kelly on 2014/10/19.
//  Copyright (c) 2014年 kelly. All rights reserved.
//

import UIKit

class DirectMessageTableViewController: UITableViewController , UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar! = UISearchBar ()
    
    var userList: NSMutableArray = NSMutableArray ()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchBar.delegate = self
        
        loadUsers("")
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    func loadUsers(name: String ) {
        var findUsers: PFQuery = PFUser.query ()
        
        if  !name.isEmpty {
            findUsers.whereKey("username", containsString: name)
        }
        
        findUsers.findObjectsInBackgroundWithBlock {
        (objects: [AnyObject]!, error: NSError!) -> Void in
            
            if (error == nil) {
                self.userList = NSMutableArray(array: objects)
                self.tableView.reloadData()
            }
            
        }
            
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        loadUsers(searchText)
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        loadUsers("")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return userList.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell

        // Configure the cell...
        
        var user: PFUser = userList.objectAtIndex(indexPath.row) as PFUser
        
        cell.textLabel.text = user.username

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var messageAlert: UIAlertController = UIAlertController(title: "New direct message", message: "Enter your message", preferredStyle: UIAlertControllerStyle.Alert)
        
        messageAlert.addTextFieldWithConfigurationHandler {
            (textfiled: UITextField!) -> Void in
            
            textfiled.placeholder = "Your message ..."
        }
        
        messageAlert.addAction(UIAlertAction(title: "Send", style: UIAlertActionStyle.Default, handler: {
            (actionAction:UIAlertAction!) -> Void in
            
            var pushQuery: PFQuery = PFInstallation.query()
            pushQuery.whereKey("user", equalTo: self.userList.objectAtIndex(indexPath.row))
            
            var push: PFPush = PFPush ()
            push.setQuery(pushQuery)
            
            let textfileds: NSArray = messageAlert.textFields! as NSArray
            let messageTextField: UITextField = textfileds.objectAtIndex(0) as UITextField
            
            push.setMessage(messageTextField.text)
            
            push.sendPushInBackground()
            
        }))
        
        messageAlert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
        
        self.presentViewController(messageAlert, animated: true, completion: nil)
    }

    
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView!, canEditRowAtIndexPath indexPath: NSIndexPath!) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView!, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath!) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView!, moveRowAtIndexPath fromIndexPath: NSIndexPath!, toIndexPath: NSIndexPath!) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView!, canMoveRowAtIndexPath indexPath: NSIndexPath!) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
