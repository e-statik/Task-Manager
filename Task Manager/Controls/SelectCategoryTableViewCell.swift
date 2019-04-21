//
//  SelectCategoryTableViewCell.swift
//  Task Manager
//
//  Created by Victor Blokhin on 03/04/2019.
//  Copyright © 2019 Victor Blokhin. All rights reserved.
//

import UIKit

class SelectCategoryTableViewCell: UITableViewCell {
   
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelSelect: UILabel!
    @IBOutlet weak var viewColor: UIView!
    
    override func layoutSubviews() {
        super.layoutSubviews()

        viewColor.layer.cornerRadius = 4
        self.selectionStyle = UITableViewCell.SelectionStyle.none
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if selected {
            labelSelect.text = "✓"
        } else {
            labelSelect.text = ""
        }
    }

}
