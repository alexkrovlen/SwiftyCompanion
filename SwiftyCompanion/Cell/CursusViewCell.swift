//
//  CursusViewCell.swift
//  SwiftyCompanion
//
//  Created by Flash Jessi on 9/19/21.
//  Copyright © 2021 Svetlana Frolova. All rights reserved.
//

import UIKit

class CursusViewCell: UITableViewCell {
    
    @IBOutlet weak var cursusNameLabel: UILabel! {
        didSet {
            cursusNameLabel.textColor = .white
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
