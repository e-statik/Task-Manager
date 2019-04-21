//
//  SelectStateViewController.swift
//  Task Manager
//
//  Created by Victor Blokhin on 04/04/2019.
//  Copyright © 2019 Victor Blokhin. All rights reserved.
//

import UIKit
import CoreData

class SelectStateViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var categoryStatesData: [State] = [] {
        didSet {
            // если данных нет - скрыть таблицу, показать сообщение; и наоборот
            tableView.isHidden = categoryStatesData.isEmpty
            labelNoData.isHidden = !categoryStatesData.isEmpty
        }
    }
    var category: Category?
    var state: State?
    var selectedId:Int = 0
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var labelNoData: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewMain.layer.cornerRadius = 8
        roundCorners(for: viewHeader, corners: [.topLeft, .topRight], radius: 8)
        
        getData()
        
        if !categoryStatesData.isEmpty {
            if let state = state, let index = categoryStatesData.firstIndex(of: state) {
                selectedId = index
            } else {
                state = categoryStatesData[selectedId]
            }
        }
    }
    
    // Загрузить данные из БД в коллекцию categoryStatesData
    fileprivate func getData() {
        // Загружаем статусы только по текущей категории
        if let category = category, let catStates = category.states {
            for catState in catStates {
                if let catState = catState as? State {
                    categoryStatesData.append(catState)
                }
            }
        }
    }
    
    // MARK: - TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryStatesData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        guard let stateCell = cell as? SelectStateTableViewCell else {
            return cell
        }
        
        stateCell.labelName.text = categoryStatesData[indexPath.row].name
        stateCell.labelName.textColor = categoryStatesData[indexPath.row].isDone ? #colorLiteral(red: 0.002038905084, green: 0.7180559962, blue: 0.003163546881, alpha: 1) : #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0) // "Завершающие" статусы подсветить зеленым
        
        return stateCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedId = indexPath.row
        state = categoryStatesData[selectedId]
    }
    
    // После загрузки всех строк - выбрать нужную
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let lastVisibleIndexPath = tableView.indexPathsForVisibleRows?.last {
            if indexPath == lastVisibleIndexPath {
                tableView.selectRow(at: IndexPath(row: selectedId, section: 0), animated: false, scrollPosition: .middle)
            }
        }
    }
    
    // Нажата кнопка подтверждения выбора и закрытия окна
    @IBAction func buttonOkTap(_ sender: Any) {
        NotificationCenter.default.post(name: .selectedState, object: self)
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
