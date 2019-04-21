//
//  SelectCategoryTableViewCell.swift
//  Task Manager
//
//  Created by Victor Blokhin on 03/04/2019.
//  Copyright © 2019 Victor Blokhin. All rights reserved.
//

import UIKit

class SelectStateTableViewCell: UITableViewCell {
   
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelSelect: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.selectionStyle = UITableViewCell.SelectionStyle.none
    }


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: false)
        
        if selected {
            labelSelect.text = "✓"
        } else {
            labelSelect.text = ""
        }
    }

}
