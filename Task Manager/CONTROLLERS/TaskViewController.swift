//
//  TaskViewController.swift
//  Task Manager
//
//  Created by Victor Blokhin on 31/03/2019.
//  Copyright © 2019 Victor Blokhin. All rights reserved.
//

import UIKit
import MapKit

class TaskViewController: UIViewController {
    
    var task:Task?
    var createNew:Bool = true
    var category:Category?
    var state:State?
    var locationAddress:String?
    var locationLatitude:Double = 0.0
    var locationLongitude:Double = 0.0
    
    var plannedEnd: NSDate? {
        didSet {
            if let dt = plannedEnd {
                let now = NSDate(timeIntervalSinceNow: 0)
                if dt.timeIntervalSince1970 < now.timeIntervalSince1970 {
                    labelPlannedEnd.textColor = Constants.overdueTextColor
                    return
                }
            }
            
            labelPlannedEnd.textColor = Constants.normalTextColor
        }
    }
    var plannedStart: NSDate?
    
    @IBOutlet weak var viewAdditionalDescription: UIView!
    @IBOutlet weak var viewPlannedEnd: UIView!
    @IBOutlet weak var viewPlannedStart: UIView!
    @IBOutlet weak var labelPlannedEnd: UILabel!
    @IBOutlet weak var labelPlannedStart: UILabel!
    @IBOutlet weak var fieldName: UITextField!
    @IBOutlet weak var textAdditionalDescription: UITextView!
    @IBOutlet weak var labelState: UILabel!
    @IBOutlet weak var labelCreated: UILabel!
    @IBOutlet weak var labelDone: UILabel!
    @IBOutlet weak var labelCategory: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var labelAddress: UILabel!
    
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Подписаться на события выбора в других контрооллерах срока выполнения, категории, статуса
        NotificationCenter.default.addObserver(forName: .selectedDateTime, object: nil, queue: nil, using: handleDateTimeSelect)
        NotificationCenter.default.addObserver(forName: .selectedCategory, object: nil, queue: nil, using: handleCategorySelect)
        NotificationCenter.default.addObserver(forName: .selectedState, object: nil, queue: nil, using: handleStateSelect)
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillChangeFrameNotification, object: nil, queue: nil, using: adjustForKeyboard)
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: nil, using: adjustForKeyboard)
        
        
        let fnColor = fieldName.textColor!
        fieldName.attributedPlaceholder = NSAttributedString(string: fieldName.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor: fnColor.withAlphaComponent(0.35)])
        
        if let task = task {
            fieldName.text = task.name
            textAdditionalDescription.text = task.additionalDescription
            plannedStart = task.datePlannedStart
            labelPlannedStart.text = task.datePlannedStart?.formattedDateTime
            plannedEnd = task.datePlannedEnd
            labelPlannedEnd.text = task.datePlannedEnd?.formattedDateTime
            labelDone.text = task.dateDone?.formattedDateTime
            labelCreated.text = "Создана: " + (task.dateCreated?.formattedDateTime ?? "-")
            labelCategory.text = task.category?.name ?? ""
            category = task.category
            labelState.text = task.state?.name ?? ""
            labelState.textColor = (task.state?.isDone ?? false) ? #colorLiteral(red: 0.002038905084, green: 0.7180559962, blue: 0.003163546881, alpha: 1) : #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0) // "Завершающий" статус подсветить зеленым
            locationLongitude = task.locationLongitude
            locationLatitude = task.locationLatitude
            locationAddress = task.locationAddress
            labelAddress.text = locationAddress
            state = task.state
        } else {
            fieldName.text = ""
            textAdditionalDescription.text = ""
            labelPlannedStart.text = ""
            labelPlannedEnd.text = ""
            labelCategory.text = ""
            labelState.text = ""
            labelCreated.text = ""
            labelDone.text = ""
            labelAddress.text = ""
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Actions
    
    // Открытие окна выбора срока выполнения
    @IBAction func buttonTapChangePlannedEnd(_ sender: Any) {
        openDateTimePicker(targetFieldName: "plannedEnd", date: plannedEnd)
    }
    
    // Открытие окна выбора категории
    @IBAction func buttonTapCategory(_ sender: Any) {
        openCategoryPicker()
    }
    
    // Открытие окна выбора статуса
    @IBAction func buttonTapState(_ sender: Any) {
        openStatePicker()
    }
    
    // Открытие окна выбора плановой даты начала выполнения
    @IBAction func buttonTapPlannedStart(_ sender: Any) {
        openDateTimePicker(targetFieldName: "plannedStart", date: plannedStart)
    }
    
    private func openDateTimePicker(targetFieldName:String, date: NSDate?) {
        let storyboard = UIStoryboard(name:"Main", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "SelectDateViewController") as! SelectDateViewController
        vc.targetFieldName = targetFieldName
        vc.dateTime = date
        self.present(vc, animated: true, completion: nil)
    }
    
    private func openCategoryPicker() {
        let storyboard = UIStoryboard(name:"Main", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "SelectCategoryViewController") as! SelectCategoryViewController
        vc.category = task?.category
        self.present(vc, animated: true, completion: nil)
    }
    
    private func openStatePicker() {
        // Выбор статуса только если выбрана конкретная категория
        if let category = category {
            let storyboard = UIStoryboard(name:"Main", bundle: Bundle.main)
            let vc = storyboard.instantiateViewController(withIdentifier: "SelectStateViewController") as! SelectStateViewController
            vc.category = category
            vc.state = state
            self.present(vc, animated: true, completion: nil)
        }
    }

    // Обработка события выбора даты/времени в другом контроллере
    @objc func handleDateTimeSelect(notification: Notification) {
        if let vc = notification.object as? SelectDateViewController {
            
            switch vc.targetFieldName {
            case "plannedStart":
                plannedStart = vc.dateTime
                labelPlannedStart.text = vc.dateTime?.formattedDateTime ?? ""
            case "plannedEnd":
                plannedEnd = vc.dateTime
                labelPlannedEnd.text = vc.dateTime?.formattedDateTime ?? ""
            default:
                print("")
            }
        }
    }
    
    // Обработка события выбора категории в другом контроллере
    @objc func handleCategorySelect(notification: Notification) {
        if let vc = notification.object as? SelectCategoryViewController {
            
            // Если изменилась категория - удалить текущий статус
            if (category?.name ?? "") != (vc.category?.name ?? "") {
                labelState.text = ""
                state = nil
            }
            
            category = vc.category
            labelCategory.text = vc.category?.name ?? ""
        }
    }
    
    // Обработка события выбора статуса в другом контроллере
    @objc func handleStateSelect(notification: Notification) {
        if let vc = notification.object as? SelectStateViewController {
            state = vc.state
            labelState.text = vc.state?.name ?? ""
            labelState.textColor = (vc.state?.isDone ?? false) ? #colorLiteral(red: 0.002038905084, green: 0.7180559962, blue: 0.003163546881, alpha: 1) : #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0) // "Завершающий" статус подсветить зеленым
            labelDone.text = (vc.state?.isDone ?? false) ? NSDate.now.formattedDate : ""
        }
    }
    
    @IBAction func backFromPreviousViewController(sender: UIStoryboardSegue) {
        // Возврат из окна выбора локации
        if sender.identifier == "MapViewController done tap" {
            guard let vc = sender.source as? MapViewController else {
                return
            }
            
            locationAddress = vc.locationAddress
            labelAddress.text = locationAddress
            locationLatitude = vc.selectedAnnotation?.coordinate.latitude ?? 0.0
            locationLongitude = vc.selectedAnnotation?.coordinate.longitude ?? 0.0
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        // Если попытка сохранить задачу без названия - подсветить поле красным - отказ
        if identifier == "TaskViewController done tap" && (fieldName.text ?? "") == "" {
            let color = #colorLiteral(red: 1, green: 0.4932718873, blue: 0.4739984274, alpha: 1)
            fieldName.attributedPlaceholder = NSAttributedString(string: (fieldName.placeholder ?? "") + " *", attributes: [NSAttributedString.Key.foregroundColor: color])
            scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
            return false
        }
        
        return true
    }
    
    // Нажата кнопка сохранения данных
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Open map" {
            if let vc = segue.destination as? MapViewController {
                
                if locationLongitude != 0.00 || locationLatitude != 0.00 {
                    vc.locationAddress = locationAddress
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = CLLocationCoordinate2D(latitude: locationLatitude, longitude: locationLongitude)
                    vc.selectedAnnotation = annotation
                }
            }
        } else {
           
            let app = UIApplication.shared.delegate as? AppDelegate
            guard let context = app?.coreDataStack.managedContext else { return }
            
            if let task = task {
                task.name = fieldName.text
                task.additionalDescription = textAdditionalDescription.text
                task.datePlannedEnd = plannedEnd
                task.datePlannedStart = plannedStart
                task.category = category
                task.state = state
                task.dateDone = nil
                task.locationAddress = locationAddress
                task.locationLongitude = locationLongitude
                task.locationLatitude = locationLatitude
                if let state = state {
                    if state.isDone {
                        task.dateDone = NSDate.now
                    }
                }
            } else {
                task = Task(context: context)
                task!.name = fieldName.text
                task!.additionalDescription = textAdditionalDescription.text
                task!.datePlannedEnd = plannedEnd
                task!.datePlannedStart = plannedStart
                task!.category = category
                task!.state = state
                task!.dateCreated = NSDate.now
                task!.dateDone = nil
                task!.locationAddress = locationAddress
                task!.locationLongitude = locationLongitude
                task!.locationLatitude = locationLatitude
                if let state = state {
                    if state.isDone {
                        task!.dateDone = NSDate.now
                    }
                }
            }
            
            do {
                try context.save()
            } catch let error as NSError {
                print("Произошла ошибка сохранения данных")
                print(error)
            }
        }
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        
        guard notification.name != UIResponder.keyboardWillHideNotification else {
            scrollView.contentInset.bottom = 0
            scrollView.scrollIndicatorInsets.bottom = 0
            return
        }
        
        guard let userInfo = notification.userInfo else {
            return
        }
        
        guard let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        
        let keyboardHeight = keyboardFrame.cgRectValue.height
        scrollView.contentInset.bottom = keyboardHeight
        scrollView.scrollIndicatorInsets.bottom = keyboardHeight
    }
    
    @IBAction func focusTextView() {
        textAdditionalDescription.becomeFirstResponder()
    }
}
