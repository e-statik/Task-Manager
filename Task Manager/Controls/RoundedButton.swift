//
//  RoundedButtonView.swift
//  Task Manager
//
//  Created by Victor Blokhin on 01/04/2019.
//  Copyright © 2019 Victor Blokhin. All rights reserved.
//

import UIKit

@IBDesignable
class RoundedButton: UIButton {

    private enum Constants {
        static let cornerRadius = CGFloat(27)
        static let borderColor = #colorLiteral(red: 0.5882352941, green: 0.231372549, blue: 0.2549019608, alpha: 1).cgColor
        static let borderWidth = CGFloat(4)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.cornerRadius = Constants.cornerRadius
        self.layer.borderColor = Constants.borderColor
        self.layer.borderWidth = Constants.borderWidth
    }

}
