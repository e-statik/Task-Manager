//
//  UnderlineButton.swift
//  Task Manager
//
//  Created by Victor Blokhin on 02/04/2019.
//  Copyright © 2019 Victor Blokhin. All rights reserved.
//

import UIKit

class UnderlineButton: UIButton {
    private enum constants {
        static let borderWidth: CGFloat = 2
        static let borderColor: UIColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        static let selectedTextColor: UIColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        static let deselectedTextColor: UIColor = #colorLiteral(red: 0.968627451, green: 0.968627451, blue: 0.968627451, alpha: 0.5)
        static let layerName: String = "UnderlineButtonBottomBorderLayer"
    }
    
    private var borderLayer: CALayer?

    func selectButton() {
        let borderLayer = CALayer()
        borderLayer.name = constants.layerName
        borderLayer.backgroundColor = constants.borderColor.cgColor
        borderLayer.frame = CGRect(x:0, y:self.frame.size.height - constants.borderWidth, width:self.frame.size.width, height:constants.borderWidth)
        self.layer.addSublayer(borderLayer)
        self.setTitleColor(constants.selectedTextColor, for: .normal)
    }
    
    func deselectButton() {
        if self.layer.sublayers != nil {
            for lr in self.layer.sublayers! {
                if let lrName = lr.name, lrName == constants.layerName {
                        lr.removeFromSuperlayer()
                    }
                }
        }

        self.setTitleColor(constants.deselectedTextColor, for: .normal)
    }
    
}
