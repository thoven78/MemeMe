//
//  MemeTableViewController.swift
//  Created by Stevenson Michel on 07/19/2015.
//  Copyright (c) 2015 Stevenson Michel. All rights reserved.
//

import UIKit

class MemeTableViewController: UITableViewController {
    var memes: [Meme]!
    var plusButton = UIBarButtonItem()
    var editButton = UIBarButtonItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        plusButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "anotherMeme")
        editButton = UIBarButtonItem(title: "Edit", style: .Done, target: self, action: "edit")

        self.navigationItem.hidesBackButton = true
        self.navigationItem.rightBarButtonItem = plusButton
        self.navigationItem.leftBarButtonItem = editButton
        updateMemes()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        updateMemes()
        self.editing = false
        self.tableView.reloadData() // Reload Data so if a delete was done to get the new data.
    }
    
    //Load the memes from App Delegate
    func updateMemes(){
        let applicationDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        memes = applicationDelegate.memes
    }

    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    //Asks the data source whether a given row can be moved to another location in the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    //Setup the display of the cell
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("tableViewCell") as UITableViewCell?
        
        let meme = self.memes[indexPath.row]
        // Set the name and image
        cell!.textLabel?.text = meme.topText! + "-" + meme.bottomText!
        cell!.detailTextLabel?.text = ""
        cell!.imageView?.image = meme.memedImage

        return cell!
    }

    //On select display the Meme in Meme Detail View
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeDetailViewController") as! MemeDetailViewController
        detailController.meme   = self.memes[indexPath.row]
        
        self.navigationController!.pushViewController(detailController, animated: true)
    }
    
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
        let itemToMove = memes[fromIndexPath.row]
        memes.removeAtIndex(fromIndexPath.row)
        memes.insert(itemToMove, atIndex: toIndexPath.row)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "anotherMeme"{
            if let _ = segue.destinationViewController as? EditorViewController{
                //Reset Editor View.
                let applicationDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
                applicationDelegate.editorMeme = Meme(topText: "TOP", bottomText: "BOTTOM", image: UIImage(), memedImage: UIImage())
            }
        }
    }
    
    //Button Action. Goes to the Edit View to create another meme.
    func anotherMeme(){
        self.dismissViewControllerAnimated(true, completion: nil)
        self.performSegueWithIdentifier("anotherMeme", sender: self)

    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    //For deleting the Meme
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        let applicationDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        memes.removeAtIndex(indexPath.row)

        applicationDelegate.memes = memes
        self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
    }
    
    func edit(){
        self.editing = !self.editing
    }
    
}