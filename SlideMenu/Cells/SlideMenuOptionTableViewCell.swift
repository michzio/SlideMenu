//
//  SlideMenuOptionTableViewCell.swift
//  SlideMenu
//
//  Created by Michal Ziobro on 29/07/2019.
//  Copyright © 2019 Click5Interactive. All rights reserved.
//

import UIKit

class SlideMenuOptionTableViewCell: UITableViewCell {

    // MARK: - Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var badgeLabel: UILabel!
    @IBOutlet weak var separator: UIView!
    @IBOutlet weak var iconImageView: UIImageView!
    
    // MARK: - Life Cycle Hooks
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configStyle()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}

// MARK: - Look & Feel
extension SlideMenuOptionTableViewCell {
    
    private func configStyle() {
        
        // style Title
        titleLabel.text = ""
        titleLabel.font = UIFont.systemFont(ofSize: 14.0)
        titleLabel.textColor = UIColor.black
        
        // style Icons
        iconImageView.tintColor = .lightGray //AppColors.menuIconGray
        
        // style Badge
        badgeLabel.layer.cornerRadius = 7
        badgeLabel.clipsToBounds = true
        badgeLabel.backgroundColor = UIColor.red
        
        // style Separator
        separator.backgroundColor = .white
        
        // style Background
        contentView.backgroundColor = .white
    }
}
