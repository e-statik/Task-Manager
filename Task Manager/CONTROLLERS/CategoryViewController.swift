//
//  CategoryViewController.swift
//  Task Manager
//
//  Created by Victor Blokhin on 03/04/2019.
//  Copyright © 2019 Victor Blokhin. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, CollectionColorDelegate {

    var category:Category?
    var states:[State] = [] {
        didSet {
            tableView.isHidden = states.isEmpty
            labelNoData.isHidden = !states.isEmpty
        }
    }
    var currentColorName:String = Constants.categoryColors[0] {
        didSet {
            currentColorNameIndex = Constants.getCategoryColorNameIndex(forColor: currentColorName)
        }
    }
    private var currentColorNameIndex:Int = 0
    var selectedColorCell: ColorCollectionViewCell?
    
    @IBOutlet weak var fieldName: UITextField!
    @IBOutlet weak var collectionColors: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var labelNoData: UILabel!
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fnColor = fieldName.textColor!
        fieldName.attributedPlaceholder = NSAttributedString(string: fieldName.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor: fnColor.withAlphaComponent(0.35)])
        
        if let category = category {
            fieldName.text = category.name
            
            if Constants.categoryColors.contains(category.color?.uppercased() ?? "") {
                currentColorName = category.color!
            }
            else {
                currentColorName = Constants.categoryColors[0]
            }
        }
        
        getStatesData()
    }
   
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // проскроллить до текущего выбранного цвета
        collectionColors.scrollToItem(at: IndexPath(row: currentColorNameIndex, section: 0), at: .centeredHorizontally, animated: false)
    }
    
    // Загрузить из БД статусы по текущей категории в states
    private func getStatesData() {
        if let category = category, let catStates = category.states {
            for state in catStates {
                if let state = state as? State {
                    states.append(state)
                }
            }
        }
    }
    
    // MARK: - TableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return states.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        guard let stateCell = cell as? StateTableViewCell else {
            return cell
        }
        
        stateCell.labelName.text = states[indexPath.row].name
        stateCell.labelName.textColor = states[indexPath.row].isDone ? #colorLiteral(red: 0.002038905084, green: 0.7180559962, blue: 0.003163546881, alpha: 1) : #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0) // "Завершающие" статусы подсветить зеленым
        
        return stateCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    
    // MARK: - CollectionView
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Constants.categoryColors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionColors.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        
        guard let colorCell = cell as? ColorCollectionViewCell else {
            return cell
        }
        
        colorCell.delegate = self
        
        let color:UIColor = UIColor.hexStringToUIColor(hex: Constants.categoryColors[indexPath.row])
        colorCell.setCellColor(color)
        
        if indexPath.row == currentColorNameIndex {
            colorCell.selectCell()
            selectedColorCell = colorCell
        } else {
            colorCell.deselectCell()
        }
        
        return colorCell
    }
    
 
    // MARK: - Actions
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        // Если попытка сохранить и не указано название - подсветка поля красным + отказ
        if identifier == "CategoryViewController done tap" && (fieldName.text ?? "") == "" {
            let color = #colorLiteral(red: 1, green: 0.4932718873, blue: 0.4739984274, alpha: 1)
            fieldName.attributedPlaceholder = NSAttributedString(string: (fieldName.placeholder ?? "") + " *", attributes: [NSAttributedString.Key.foregroundColor: color])
            return false
        }
        
        return true
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Переход к редактированию выбранного статуса
        if segue.identifier == "Open state" {
            if let vc = segue.destination as? StateViewController, let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell) {
                vc.state = states[indexPath.row]
                vc.isCreateNew = false
            }
        } else {
            // Нажатие кнопки - сохранение данных
            let app = UIApplication.shared.delegate as? AppDelegate
            guard let context = app?.coreDataStack.managedContext else { return }
            
            if let category = category {
                category.name = fieldName.text
                category.color = currentColorName
            } else {
                category = Category(context: context)
                category!.name = fieldName.text
                category!.color = currentColorName
                states.forEach({category!.addToStates($0)})
            }
            
            do {
                try context.save()
            } catch let error as NSError {
                print("Произошла ошибка сохранения данных")
                print(error)
            }
            
            // Отправить сообщение - список задач должен обновить цвета (могли измениться при сохранении)
            NotificationCenter.default.post(name: .changedCategories, object: self)
        }
    }
    
    /*
    // Окно добавления нового статуса в текущую категорию
    @IBAction func buttonTapNewState(_ sender: Any) {
        let alertViewController = UIAlertController(title: "Добавить статус", message: "", preferredStyle: .alert)
        
        alertViewController.addTextField(configurationHandler: { textField in
            textField.placeholder = "Название"
            textField.autocapitalizationType = .sentences
        })
        
        
        alertViewController.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
        
        alertViewController.addAction(UIAlertAction(title: "Добавить", style: .default, handler: { _ in
            guard let nameTextField = alertViewController.textFields?[0] else {
                return
            }
            
            if let stateName = nameTextField.text {
                let app = UIApplication.shared.delegate as? AppDelegate
                guard let context = app?.coreDataStack.managedContext else { return }
                
                let newState = State(context: context)
                newState.name = stateName
                self.states.append(newState)
                self.category?.addToStates(newState)
                self.tableView.reloadData()
            }
        }))
        
        let subview = (alertViewController.view.subviews.first?.subviews.first?.subviews.first!)! as UIView
        subview.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        
        present(alertViewController, animated: true, completion: nil)
    }
    */
    
    // Событие выбора пользователем цвета в collectionColors
    @objc func collectionColorSelect(sender: ColorCollectionViewCell) {
        if let cell = selectedColorCell {
            cell.deselectCell()
        }
        
        selectedColorCell = sender
        currentColorName = sender.cellColor.toHexString()
    }
    
    @IBAction func backFromPreviousViewController(sender: UIStoryboardSegue) {
        // Возврат из окна создания статуса
        if sender.identifier == "StateViewController done tap" {
            guard let vc = sender.source as? StateViewController else {
                return
            }
            
            if vc.isCreateNew {
                if let state = vc.state {
                    self.states.append(state)
                    self.category?.addToStates(state)
                }
            }
            
            self.tableView.reloadData()
        }
    }
    
}
