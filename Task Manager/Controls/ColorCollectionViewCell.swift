//
//  ColorCollectionViewCell.swift
//  Task Manager
//
//  Created by Victor Blokhin on 03/04/2019.
//  Copyright © 2019 Victor Blokhin. All rights reserved.
//

import UIKit

protocol CollectionColorDelegate {
    func collectionColorSelect(sender: ColorCollectionViewCell)
}

class ColorCollectionViewCell: UICollectionViewCell {
    
    var isSelectedCell: Bool = false
    var delegate:CollectionColorDelegate?
    var cellColor:UIColor = UIColor.white
    
    @IBOutlet weak private var buttonColor: UIButton!
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        buttonColor.layer.cornerRadius = 4
        buttonColor.backgroundColor = cellColor
    }
    
    func selectCell() {
        self.isSelectedCell = true
        buttonColor.setTitle("✓", for: .normal)
    }
    
    func deselectCell() {
        self.isSelectedCell = false
        buttonColor.setTitle("", for: .normal)
    }
    
    func setCellColor(_ color: UIColor) {
        self.cellColor = color
        buttonColor.backgroundColor = color
    }
    
    @IBAction func buttonColorTap(_ sender: Any) {
        selectCell()
        delegate?.collectionColorSelect(sender: self)
    }
    
}
