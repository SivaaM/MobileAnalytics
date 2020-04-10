//
//  DetailVC.swift
//  MemberInfoApp
//
//  Created by Fahath Rajak on 27/03/20.
//  Copyright © 2020 Fahath. All rights reserved.
//

import UIKit

class DetailVC: UIViewController {
    @IBOutlet weak var iv: UIImageView!

    var imageString: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let image = imageString {
            iv.image = UIImage(named: image)
        }
        
    }
}
