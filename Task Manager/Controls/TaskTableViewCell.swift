//
//  TaskTableViewCell.swift
//  Task Manager
//
//  Created by Victor Blokhin on 30/03/2019.
//  Copyright © 2019 Victor Blokhin. All rights reserved.
//

import UIKit

class TaskTableViewCell: UITableViewCell {
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelPlannedEnd: UILabel!
    @IBOutlet weak var viewContent: UIView!
    @IBOutlet weak var viewColor: UIView!
    @IBOutlet weak var viewData: UIView!
    @IBOutlet weak var labelState: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    /*
    fileprivate func roundCorners(for view: UIView, corners: UIRectCorner, radius: Double) {
        let maskPath = UIBezierPath(roundedRect: view.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let shape = CAShapeLayer()
        shape.path = maskPath.cgPath
        view.layer.mask = shape
    }
     */
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        //roundCorners(for: viewColor, corners: [.bottomLeft, .topLeft], radius: 10)
        //roundCorners(for: viewData, corners: [.bottomRight, .topRight], radius: 10)
        viewColor.layer.cornerRadius = 10
    }

}
