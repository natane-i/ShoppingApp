//
//  CategoryIcon.swift
//  ShoppingApp
//
//  Created by spark-01 on 2024/07/05.
//

import UIKit

class CategoryIcon: UICollectionViewCell {
    
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var categoryView: UIView!
    @IBOutlet weak var categoryFrame: UIView!
    
    override var isSelected: Bool {
        get { return super.isSelected }
        set {
            super.isSelected = newValue
            updateAppearance()
        }
    }
    
    func updateAppearance() {
        if isSelected {
            categoryLabel.textColor = .white
            categoryView.backgroundColor = .colorTag
        } else {
            categoryLabel.textColor = .colorTag
            categoryView.backgroundColor = .white
        }
    }
    
    func setup() {
        categoryFrame.layer.cornerRadius = 6
        categoryView.layer.cornerRadius = 6
    }
}

extension UIColor {
    static var colorTag: UIColor {
        return UIColor(named: "color_tag")!
    }
   
}
