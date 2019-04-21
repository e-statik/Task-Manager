//
//  StateTableViewCell.swift
//  Task Manager
//
//  Created by Victor Blokhin on 05/04/2019.
//  Copyright © 2019 Victor Blokhin. All rights reserved.
//

import UIKit

class StateTableViewCell: UITableViewCell {

    @IBOutlet weak var labelName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
