//
//  CustomViewCell.swift
//  SwiftyCompanion
//
//  Created by Flash Jessi on 9/16/21.
//  Copyright © 2021 Svetlana Frolova. All rights reserved.
//

import UIKit

class CustomViewCell: UITableViewCell {
    
    
    @IBOutlet weak var nameLabel: UILabel! {
        didSet {
            nameLabel.textColor = .white
        }
    }
    @IBOutlet weak var valueLabel: UILabel! {
        didSet {
            valueLabel.textColor = .white
        }
    }
    
    @IBOutlet weak var descriptionLabel: UILabel! {
        didSet {
            descriptionLabel.textColor = .white
        }
    }
    @IBOutlet weak var heightDescription: NSLayoutConstraint! {
        didSet {
            heightDescription.constant = CGFloat(0)
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
