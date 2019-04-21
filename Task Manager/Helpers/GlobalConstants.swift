//
//  GlobalConstants.swift
//  Task Manager
//
//  Created by Victor Blokhin on 02/04/2019.
//  Copyright © 2019 Victor Blokhin. All rights reserved.
//

import Foundation
import UIKit

enum Constants {
    static let overdueTextColor: UIColor = UIColor(named: "OverdueText")!
    static let normalTextColor: UIColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    static let categoryColors: [String] = ["FF7E79", "FFD479", "FFFC79", "D4FB79", "73FA79", "73FCD6", "73FDFF", "76D6FF", "7A81FF", "D783FF", "FF85FF", "FF8AD8"]
    
    static func getCategoryColorNameIndex(forColor: String) -> Int {
        
        if let index = categoryColors.firstIndex(of: forColor.uppercased()) {
            return index
        }
        
        return -1
    }
}
