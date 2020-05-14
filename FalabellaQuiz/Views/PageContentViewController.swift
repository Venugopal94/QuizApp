//
//  PageContentViewController.swift
//  FalabellaQuiz
//
//  Created by venu Gopal on 10/05/20.
//  Copyright © 2020 venu Gopal. All rights reserved.
//

import UIKit

class PageContentViewController: UIViewController {

    @IBOutlet weak var pointsEarned: UILabel!
    @IBOutlet weak var choicesCollectionView: UICollectionView!
    @IBOutlet weak var lblTitle: UILabel!
    
    var pageIndex: Int = 0
    var strTitle: String!
    var strPhotoName: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblTitle.text = strTitle
    }
    
    
    @IBAction func tapOnScores(_ sender: Any) {
    }
}
