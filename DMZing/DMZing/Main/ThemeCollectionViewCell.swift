//
//  ThemeCollectionViewCell.swift
//  DMZing
//
//  Created by 장한솔 on 2018. 10. 28..
//  Copyright © 2018년 장용범. All rights reserved.
//

import UIKit

class ThemeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        backView.layer.cornerRadius = backView.frame.height/2
    }
    
    override var isSelected: Bool {
        willSet {
            self.backView.backgroundColor = isSelected ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) : #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        }
    }
}
