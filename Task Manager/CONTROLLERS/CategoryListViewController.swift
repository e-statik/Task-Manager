//
//  CategoryListViewController.swift
//  Task Manager
//
//  Created by Victor Blokhin on 03/04/2019.
//  Copyright © 2019 Victor Blokhin. All rights reserved.
//

import UIKit
import CoreData

class CategoryListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var categoriesData:[Category] = [] {
        didSet {
            // если данных нет - скрыть таблицу, показать сообщение; и наоборот
            tableView.isHidden = categoriesData.isEmpty
            labelNoData.isHidden = !categoriesData.isEmpty
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var labelNoData: UILabel!
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getData()
    }

    // Загрузка данных из БД в коллекцию categoriesData
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
    
        guard let categoryCell = cell as? CategoryTableViewCell else {
            return cell
        }
        
        categoryCell.labelName.text = categoriesData[indexPath.row].name
        categoryCell.viewColor.backgroundColor = UIColor.hexStringToUIColor(hex: categoriesData[indexPath.row].color ?? "")
        
        return categoryCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    // MARK: - Actions
//    @IBAction func buttonTapClose(_ sender: Any) {
//        dismiss(animated: true, completion: nil)
//
//    }
    
    @IBAction func backFromPreviousViewController(sender: UIStoryboardSegue) {
        // Возврат из окна добавления/редактирования категории (нажатие Done)
        if sender.identifier == "CategoryViewController done tap" {
            getData()
            tableView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Переход к редактированию выбранной категории
        if segue.identifier == "Open category" {
            if let vc = segue.destination as? CategoryViewController, let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell) {
                    vc.category = categoriesData[indexPath.row]
                }
            }
    }
    
}
