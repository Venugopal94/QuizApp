//
//  OptionCell.swift
//  FalabellaQuiz
//
//  Created by venu Gopal on 10/05/20.
//  Copyright © 2020 venu Gopal. All rights reserved.
//

import UIKit

class OptionCell: UICollectionViewCell {

    @IBOutlet weak var optionText: UILabel!
    @IBOutlet weak var radioView: UIView!
    
    var option: String? {
        didSet {
          setUpCell()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }
    func setUpCell()  {
        optionText.text = option
        if isSelected {
            radioView.backgroundColor = UIColor.red
        } else {
            radioView.backgroundColor = UIColor.darkGray
        }
    }

}
