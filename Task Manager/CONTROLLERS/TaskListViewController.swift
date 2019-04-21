//
//  TaskListViewController.swift
//  Task Manager
//
//  Created by Victor Blokhin on 30/03/2019.
//  Copyright © 2019 Victor Blokhin. All rights reserved.
//

import UIKit
import CoreData

class TaskListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    
    private enum ViewMode {
        case Today, Tomorrow, Done
    }
    
    // Возможные варианты секций с задачами
    private enum ViewSection: String {
        case Overdue = "Просроченные"
        case Today = "Сегодня"
        case NoDate = "Задачи без срока выполнения"
        case Tomorrow = "Завтра"
        case Future = "Послезавтра и далее"
        case StartToday = "Начать сегодня"
        case Done = "Все завершенные"
    }
    
    private var viewMode: ViewMode = .Today
    
    var tasksData:[String:[Task]] = [:] // Данные - задачи по нужным секциям
    var sections:[String] = [] // Отдельно список секций

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var buttonToday: UnderlineButton!
    @IBOutlet weak var buttonTomorrow: UnderlineButton!
    @IBOutlet weak var buttonNoDate: UnderlineButton!
    @IBOutlet weak var labelNoData: UILabel!
    
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Подписка за сообщение об изменении данных в категориях (на случай изменения цвета)
        NotificationCenter.default.addObserver(forName: .changedCategories, object: nil, queue: nil, using: handleUpdateCategories)
        
        //tableView.estimatedRowHeight = 87
        tableView.rowHeight = UITableView.automaticDimension
        //tableView.contentInset.top = 16
        
        buttonToday.selectButton() // Основной режим - "Сегодня"
        buttonTomorrow.deselectButton()
        buttonNoDate.deselectButton()
        
        getData()
        
    }
    
    // Загрузить задачи из БД, отнести к нужным секциям по критериям
    fileprivate func getData() {
        
        tasksData.removeAll()
        sections.removeAll()
        
        let request: NSFetchRequest<Task> = Task.fetchRequest()
        let app = UIApplication.shared.delegate as? AppDelegate
        let sortDone = NSSortDescriptor(key: #keyPath(Task.dateDone), ascending: true)
        let sortPlannedEnd = NSSortDescriptor(key: #keyPath(Task.datePlannedEnd), ascending: true)
        request.sortDescriptors = [sortDone, sortPlannedEnd]
        let result = try! app!.coreDataStack.managedContext.fetch(request)
    
        // Сразу проверим, есть ли вообще задачи
        tableView.isHidden = result.isEmpty
        labelNoData.isHidden = !result.isEmpty
        
        for task in result {
            
            var sectionKey: ViewSection?
            
            // Попробовать отнести задачу к нужной секции в текущем выбранном представлении
            switch viewMode {
            case .Today:
                if let plannedEnd = task.datePlannedEnd {
                    if plannedEnd.isDateLessThan(NSDate.now) && task.dateDone == nil {
                        sectionKey = ViewSection.Overdue // Просроченные - указан срок и он "вчера" и ранее; кроме завершенных
                    }
                    
                    if plannedEnd.isDateEqualTo(NSDate.now) {
                        sectionKey = ViewSection.Today // Задачи со сроком на сегодня; завершенные не исключать, здесь пусть будут
                    }
                }
                if sectionKey == nil { // если не просроченные и не срок сегодня - проверить плановую дату начала
                    if let plannedStart = task.datePlannedStart {
                        if plannedStart.isDateEqualTo(NSDate.now) && task.dateDone == nil {
                            sectionKey = ViewSection.StartToday // Задачи с плановой датой начала сегодня; кроме завершенных
                        }
                    }
                }
            case .Tomorrow:
                if let plannedEnd = task.datePlannedEnd {
                    let tomorrow = NSDate.tomorrow
                    if plannedEnd.isDateEqualTo(NSDate.tomorrow) && task.dateDone == nil {
                        sectionKey = ViewSection.Tomorrow // Если срок исполнения завтра; кроме завершенных
                    } else
                        if plannedEnd.isDateGreaterThan(NSDate.tomorrow) && task.dateDone == nil{
                        sectionKey = ViewSection.Future // Если срок послезавтра и далее; кроме завершенных
                    }
                    
                } else
                if task.dateDone == nil {
                    sectionKey = ViewSection.NoDate // Если срок не указан; кроме завершенных
                }
            case .Done:
                if task.dateDone != nil {
                    sectionKey = ViewSection.Done // Если стоит дата завершения
                }
            }

            
            // если удалось отнести эту задачу к секции, предусмотренной на текущем экране - добавляем ее в коллекцию
            if let sectionKey = sectionKey {
                if !tasksData.keys.contains(sectionKey.rawValue) {
                    tasksData.updateValue([task], forKey: sectionKey.rawValue)
                } else {
                    tasksData[sectionKey.rawValue]?.append(task)
                }
            }
            
        }
        
        // В sections получить список актуальных секци - на которые удалось отнести задачи (важен порядок; сделано грубо, можно оптимизировать, конечно)
        if tasksData.keys.contains(where: { return $0 == ViewSection.Overdue.rawValue }) {
            sections.append(ViewSection.Overdue.rawValue)
        }
        
        if tasksData.keys.contains(where: { return $0 == ViewSection.Today.rawValue }) {
            sections.append(ViewSection.Today.rawValue)
        }
        
        if tasksData.keys.contains(where: { return $0 == ViewSection.Tomorrow.rawValue }) {
            sections.append(ViewSection.Tomorrow.rawValue)
        }
        
        if tasksData.keys.contains(where: { return $0 == ViewSection.Future.rawValue }) {
            sections.append(ViewSection.Future.rawValue)
        }
        
        if tasksData.keys.contains(where: { return $0 == ViewSection.NoDate.rawValue }) {
            sections.append(ViewSection.NoDate.rawValue)
        }
 
        if tasksData.keys.contains(where: { return $0 == ViewSection.StartToday.rawValue }) {
            sections.append(ViewSection.StartToday.rawValue)
        }
        
        if tasksData.keys.contains(where: { return $0 == ViewSection.Done.rawValue }) {
            sections.append(ViewSection.Done.rawValue)
        }
    }
    
    // MARK: - TableView
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if section > sections.count - 1 {
            return ""
        }
        
        return sections[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section > sections.count - 1 {
            return 0
        }
        
        let sectionKey = sections[section]
        
        guard let cnt = tasksData[sectionKey]?.count else {
            return 0
        }
        
        return cnt
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        guard let taskCell = cell as? TaskTableViewCell else {
            return cell
        }
        
        let sectionKey = sections[indexPath.section]
        
        if let rows = tasksData[sectionKey] {
            let task = rows[indexPath.row]
            taskCell.labelName.text = task.name
            taskCell.labelState.text = task.state?.name ?? ""
            taskCell.labelState.textColor = (task.state?.isDone ?? false) ? #colorLiteral(red: 0.002038905084, green: 0.7180559962, blue: 0.003163546881, alpha: 1) : #colorLiteral(red: 0.3599199653, green: 0.9019572735, blue: 0.804747045, alpha: 1) // "Завершающий" статус подсветить зеленым
            
            if let plannedEnd = task.datePlannedEnd {
                taskCell.labelPlannedEnd.text = plannedEnd.formattedDateTime
                taskCell.labelPlannedEnd.textColor = plannedEnd.isDateLessThan(NSDate.now) && task.dateDone == nil ? Constants.overdueTextColor : Constants.normalTextColor // Подсветить просроченные, не завершенные
            }
            else {
                taskCell.labelPlannedEnd.text = ""
            }
            
            if let category = task.category {
                taskCell.viewColor.backgroundColor = UIColor.hexStringToUIColor(hex: category.color ?? "")
            } else {
                taskCell.viewColor.backgroundColor = UIColor.gray
            }
        }
        
        return taskCell
    }
    
    
    // MARK: - Actions
    
    // Выбрать режим показа Сегодня
    @IBAction func buttonTapToday(_ sender: Any) {
        if viewMode == .Today {
            return
        }
        
        viewMode = .Today
        buttonToday.deselectButton()
        buttonTomorrow.deselectButton()
        buttonNoDate.deselectButton()
        (sender as! UnderlineButton).selectButton()
        
        getData()
        tableView.reloadData()
    }
    
    // Выбрать режим показа Завтра и далее
    @IBAction func buttonTapTomorrow(_ sender: Any) {
        if viewMode == .Tomorrow {
            return
        }
        
        viewMode = .Tomorrow
        buttonToday.deselectButton()
        buttonTomorrow.deselectButton()
        buttonNoDate.deselectButton()
        (sender as! UnderlineButton).selectButton()
        
        getData()
        tableView.reloadData()
    }
    
    // Выбрать режим показа Без срока
    @IBAction func buttonTapDone(_ sender: Any) {
        if viewMode == .Done {
            return
        }

        viewMode = .Done
        buttonToday.deselectButton()
        buttonTomorrow.deselectButton()
        buttonNoDate.deselectButton()
        (sender as! UnderlineButton).selectButton()
        
        getData()
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Открыть выбранную задачу
        if segue.identifier == "Open task" {
            if let vc = segue.destination as? TaskViewController, let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell) {

                let sectionKey = sections[indexPath.section]
                if let rows = tasksData[sectionKey] {
                    vc.task = rows[indexPath.row]
                    vc.createNew = false
                }
            }
        }
    }
    
    @IBAction func backFromPreviousViewController(sender: UIStoryboardSegue) {
        // Возврат из окна редактирования/создания задачи
        if sender.identifier == "TaskViewController done tap" {
            getData()
            tableView.reloadData()
        }
    }
    
    // В другом контроллере обновились данные по категориям - обновить (на случай смены цветов)
    func handleUpdateCategories(notification: Notification) {
        tableView.reloadData()
    }
}
