//
//  SelectCategoryViewController.swift
//  Task Manager
//
//  Created by Victor Blokhin on 03/04/2019.
//  Copyright © 2019 Victor Blokhin. All rights reserved.
//

import UIKit
import CoreData

class SelectCategoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var categoriesData:[Category] = [] {
        didSet {
            // если данных нет - скрыть таблицу, показать сообщение; и наоборот
            tableView.isHidden = categoriesData.isEmpty
            labelNoData.isHidden = !categoriesData.isEmpty
        }
    }
    var category:Category?
    private var selectedId: Int = 0
    
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var labelNoData: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewMain.layer.cornerRadius = 8
        roundCorners(for: viewHeader, corners: [.topLeft, .topRight], radius: 8)
        
        getData()
 
        if !categoriesData.isEmpty {
            if let category = category, let index = categoriesData.firstIndex(of: category) {
                selectedId = index
            } else {
                category = categoriesData[selectedId]
            }
        }
    }
    
    // Загрузить данные из БД в коллекцию categoriesData
    fileprivate func getData() {
        let request: NSFetchRequest<Category> = Category.fetchRequest()
        let app = UIApplication.shared.delegate as? AppDelegate
        categoriesData = try! app!.coreDataStack.managedContext.fetch(request)
    }
    
    // MARK: - TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoriesData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        guard let categoryCell = cell as? SelectCategoryTableViewCell else {
            return cell
        }
        
        categoryCell.labelName.text = categoriesData[indexPath.row].name
        categoryCell.viewColor.backgroundColor = UIColor.hexStringToUIColor(hex: categoriesData[indexPath.row].color ?? "")
        
        return categoryCell
    }
    
    // В таблице выбрана категория
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedId = indexPath.row
        category = categoriesData[selectedId]
    }
    
    // После загрузки всех строк - выбрать нужную
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let lastVisibleIndexPath = tableView.indexPathsForVisibleRows?.last {
            if indexPath == lastVisibleIndexPath {
                tableView.selectRow(at: IndexPath(row: selectedId, section: 0), animated: false, scrollPosition: .middle)
            }
        }
    }
    
    // MARK: - Actions
    @IBAction func buttonOKTap(_ sender: Any) {
        NotificationCenter.default.post(name: .selectedCategory, object: self)
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
