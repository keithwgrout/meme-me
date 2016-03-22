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
    
    let images = ["breakfast", "lunch", "dinner", "omelette", "breakfast", "lunch", "dinner", "omelette"]
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let object = UIApplication.sharedApplication().delegate
//        let appDelegate = object as! AppDelegate
//        
//        for image in images {
//            let meme = Meme(topText: "Time For", bottomText: "Food", image: UIImage(named: image), memedImage: UIImage(named: image))
//            appDelegate.memes.append(meme)
//        }
        
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
        let detailVC = storyboard?.instantiateViewControllerWithIdentifier("DetailVC") as! MemeDetailVC
        navigationController?.pushViewController(detailVC, animated: true)
        
    }

    @IBAction func CreateMeme(sender: AnyObject) {
        let memeEditorVC = storyboard?.instantiateViewControllerWithIdentifier("MemeVC") as! MemeEditorViewController
        presentViewController(memeEditorVC, animated: true, completion: nil)
    }
   

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
