//
//  MemeCollectionViewController.swift
//  MemeMe
//
//  Created by KEITH GROUT on 3/22/16.
//  Copyright © 2016 keithwgrout. All rights reserved.
//

import UIKit

private let reuseIdentifier = "MemeItem"

class MemeCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    var memes: [Meme] {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let space: CGFloat = 3.0
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space

    }
    
    override func viewWillAppear(animated: Bool) {
        collectionView?.reloadData()
    }
    
    @IBAction func CreateMeme(sender: AnyObject) {
        let memeEditorVC = storyboard?.instantiateViewControllerWithIdentifier("MemeVC") as! MemeEditorViewController
        presentViewController(memeEditorVC, animated: true, completion: nil)
    }

    // MARK: UICollectionViewDataSource
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let space: CGFloat = 3.0
        var dimension: CGFloat
        
        if view.frame.size.width > view.frame.size.height {
            dimension = (view.frame.size.width - (4 * space)) / 5.0
        } else {
            dimension = (view.frame.size.width - (2 * space)) / 3.0
        }
        
        return CGSizeMake(dimension, dimension)
    }
    
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        collectionView?.performBatchUpdates(nil, completion: nil)
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! MemeCollectionViewCell
        let meme = memes[indexPath.row]
    
        cell.memeImage.image = meme.memedImage
    
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let meme = memes[indexPath.row]
        
        let memeDetailVC = storyboard?.instantiateViewControllerWithIdentifier("DetailVC") as! MemeDetailVC
        memeDetailVC.image = meme.memedImage
        navigationController?.pushViewController(memeDetailVC, animated: true)
    
        
    }

    

}
