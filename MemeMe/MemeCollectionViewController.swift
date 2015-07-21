//
//  MemeCollectionViewController.swift
//  Created by Stevenson Michel on 07/19/2015.
//  Copyright (c) 2015 Stevenson Michel. All rights reserved.
//

import UIKit

class MemeCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
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
        
        self.editing = false
        
        updateMemes()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        updateMemes()
        self.collectionView?.reloadData()
    }

    //Load the memes from App Delegate
    func updateMemes(){
        let applicationDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        memes = applicationDelegate.memes
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    //Select an cell item. When edit mode is on select deletes the meme. When off, displays Meme Detail View
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MemeCollectionViewCell", forIndexPath: indexPath) as! MemeCollectionViewCell
        let meme = self.memes[indexPath.row]
        
        if self.editing {// If the edit mode is on display the delete icon.
            cell.deleteImageView.hidden = false
        } else {
            cell.deleteImageView.hidden = true
        }
        
        // Set the image
        cell.memeImageView?.image = meme.memedImage
        
        return cell
    }
    
    //It is used for deletion and viewing the meme. When in the edit mode we delete the saved Meme on Select.
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath:NSIndexPath) {
        if !self.editing { //Display Meme
            let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeDetailViewController") as! MemeDetailViewController
            detailController.meme   = self.memes[indexPath.row]
             self.navigationController!.pushViewController(detailController, animated: true)
        } else { //Delete meme
            let applicationDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
            memes.removeAtIndex(indexPath.row)
            
            applicationDelegate.memes = memes
            self.collectionView?.reloadData()
        }
    }
    
    func collectionView(collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return CGFloat(10.0)
    }
    
    //Distance between cells in a row
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return CGFloat(-8.0)
    }
    //sets the border of the collection cell
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
            return UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
    }
    
    //Action to create another Meme
    func anotherMeme(){
        self.dismissViewControllerAnimated(true, completion: nil)
        self.performSegueWithIdentifier("anotherMeme", sender: self)
        
        //Reset Editor View.
        let applicationDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        applicationDelegate.editorMeme = Meme(topText: "TOP", bottomText: "BOTTOM", image: UIImage(), memedImage: UIImage())
    }
    
    //Toggles the edit and reloads the data for the delete icon to be displayed or hid.
    func edit(){
        self.editing = !self.editing
        self.collectionView?.reloadData()
    }

}

