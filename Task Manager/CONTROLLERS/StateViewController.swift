//
//  StateViewController.swift
//  Task Manager
//
//  Created by Victor Blokhin on 05/04/2019.
//  Copyright © 2019 Victor Blokhin. All rights reserved.
//

import UIKit
import CoreData

class StateViewController: UIViewController {
    
    var state:State?
    var isCreateNew:Bool = true

    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var fieldName: UITextField!
    @IBOutlet weak var switchCloser: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewMain.backgroundColor = #colorLiteral(red: 0.2470588235, green: 0.2470588235, blue: 0.2549019608, alpha: 1)
        viewMain.layer.cornerRadius = 8
        roundCorners(for: viewHeader, corners: [.topLeft, .topRight], radius: 8)
        
        let fnColor = fieldName.textColor!
        fieldName.attributedPlaceholder = NSAttributedString(string: fieldName.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor: fnColor.withAlphaComponent(0.35)])
        
        if let state = state {
            fieldName.text = state.name
            switchCloser.isOn = state.isDone
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if state == nil {
            let app = UIApplication.shared.delegate as? AppDelegate
            guard let context = app?.coreDataStack.managedContext else { return }
            
            state = State(context: context)
        }
        
        if let state = state {
            state.name = fieldName.text
            state.isDone = switchCloser.isOn
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        // Если попытка сохранить и не указано название - подсветка поля красным + отказ
        if identifier == "StateViewController done tap" && (fieldName.text ?? "") == "" {
            let color = #colorLiteral(red: 1, green: 0.4932718873, blue: 0.4739984274, alpha: 1)
            fieldName.attributedPlaceholder = NSAttributedString(string: (fieldName.placeholder ?? "") + " *", attributes: [NSAttributedString.Key.foregroundColor: color])
            return false
        }
        
        return true
    }

    // Скруглить у view указанные углы
    fileprivate func roundCorners(for view: UIView, corners: UIRectCorner, radius: Double) {
        let maskPath = UIBezierPath(roundedRect: view.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let shape = CAShapeLayer()
        shape.path = maskPath.cgPath
        view.layer.mask = shape
    }
}
