//
//  SentMemesCollectionViewController.swift
//  MemeMe
//
//  Created by KEITH GROUT on 3/1/16.
//  Copyright © 2016 keithwgrout. All rights reserved.
//

import Foundation
import UIKit

class SentMemesViewController: UIViewController {
    
    // Properties
    var memes: [Meme] {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    }
    
    // Methods

}