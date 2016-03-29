//
//  MemeDetailVC.swift
//  MemeMe
//
//  Created by KEITH GROUT on 3/21/16.
//  Copyright © 2016 keithwgrout. All rights reserved.
//

import UIKit

class MemeDetailVC: UIViewController {
    
    @IBOutlet weak var memeDetailImage: UIImageView!
    
    var image: UIImage!
    
    override func viewDidLoad() {
        if let memePic = image {
            memeDetailImage.image = memePic
        } else {
            print("no pic available")
        }
    }

}
