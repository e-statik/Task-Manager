//
//  SelectDateViewController.swift
//  Task Manager
//
//  Created by Victor Blokhin on 01/04/2019.
//  Copyright © 2019 Victor Blokhin. All rights reserved.
//

import UIKit

class SelectDateViewController: UIViewController {

    @IBOutlet weak var buttonOK: RoundedButton!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var viewHeader: UIView!
    
    var targetFieldName: String = ""
    
    var dateTime: NSDate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        datePicker.setValue(UIColor.white, forKeyPath: "textColor")
        viewMain.backgroundColor = #colorLiteral(red: 0.2470588235, green: 0.2470588235, blue: 0.2549019608, alpha: 1)
        viewMain.layer.cornerRadius = 8
        roundCorners(for: viewHeader, corners: [.topLeft, .topRight], radius: 8)
        
        if let dt = dateTime {
            datePicker.date = dt as Date
        }
    }
    
    override func loadView() {
        super.loadView()
    }
    
    // Нажата кнопка подтверждения выбора и закрытия окна
    @IBAction func buttonOKTap(_ sender: Any) {
        dateTime = datePicker.date as NSDate
        NotificationCenter.default.post(name: .selectedDateTime, object: self)
        dismiss(animated: true, completion: nil)
    }
    
    // Нажата кнопка выбора пустого значения даты и закрытия окна
    @IBAction func buttonClearTap(_ sender: Any) {
        dateTime = nil
        NotificationCenter.default.post(name: .selectedDateTime, object: self)
        dismiss(animated: true, completion: nil)
    }
    
    // Скруглить у view указанные углы
    fileprivate func roundCorners(for view: UIView, corners: UIRectCorner, radius: Double) {
        let maskPath = UIBezierPath(roundedRect: view.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let shape = CAShapeLayer()
        shape.path = maskPath.cgPath
        view.layer.mask = shape
    }
    

}
