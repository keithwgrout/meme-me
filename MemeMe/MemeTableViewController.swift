//
//  MemeTableViewController.swift
//  MemeMe
//
//  Created by KEITH GROUT on 3/22/16.
//  Copyright © 2016 keithwgrout. All rights reserved.
//

import UIKit

class MemeTableViewController: UITableViewController {
    
    var memes: [Meme] {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 150

    }
    
    override func viewWillAppear(animated: Bool) {
        tableView.reloadData()
    }

    

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return memes.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MemeCell", forIndexPath: indexPath)
        let meme = memes[indexPath.row]
        
        cell.imageView?.image = meme.memedImage

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {        
        let meme = memes[indexPath.row]
        
        let memeDetailVC = storyboard?.instantiateViewControllerWithIdentifier("DetailVC") as! MemeDetailVC
        memeDetailVC.image = meme.memedImage
        navigationController?.pushViewController(memeDetailVC, animated: true)
    }

    @IBAction func CreateMeme(sender: AnyObject) {
        let memeEditorVC = storyboard?.instantiateViewControllerWithIdentifier("MemeVC") as! MemeEditorViewController
        presentViewController(memeEditorVC, animated: true, completion: nil)
    }

}
