//
//  RoundedContainerView.swift
//  Task Manager
//
//  Created by Victor Blokhin on 01/04/2019.
//  Copyright © 2019 Victor Blokhin. All rights reserved.
//

import UIKit

@IBDesignable
class RoundedContainerView: UIView {
    
    private enum Constants {
        static let cornerRadius = CGFloat(6)
        static let borderColor = UIColor(displayP3Red: 255, green: 255, blue: 255, alpha: 0.08).cgColor
        static let borderWidth = CGFloat(2)
    }
    
    @IBInspectable
    var showBorders: Bool = true
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.cornerRadius = Constants.cornerRadius
        
        if showBorders {
            self.layer.borderColor = Constants.borderColor
            self.layer.borderWidth = Constants.borderWidth
        }
    }

}
