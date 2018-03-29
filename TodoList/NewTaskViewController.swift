//
//  NewTaskViewController.swift
//  TodoList
//
//  Created by Ravi Pinamacha on 6/16/17.
//  Copyright © 2017 Ravi Pinamacha. All rights reserved.
//

import UIKit
import UserNotifications

class NewTaskViewController: UIViewController {
  
    @IBOutlet weak var taskText: UITextField!
    
    @IBOutlet weak var addReminder: UISwitch!
    
    @IBOutlet weak var repeatLabel: UILabel!
   
    @IBOutlet weak var addRepeat: UISwitch!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        datePicker.locale = NSLocale.current
        datePicker.timeZone = NSTimeZone.local
        
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func reminderAction(_ sender: Any) {
        //        datePicker.isHidden = !addReminder.isOn
        //        repeatLabel.isHidden  = !addReminder.isOn
        //        addRepeat.isHidden = !addReminder.isOn
        
        
        if addReminder.isOn {
            UNUserNotificationCenter.current().getNotificationSettings { (settings) in
                if(settings.authorizationStatus == .authorized){
                    DispatchQueue.main.async {
                        self.datePicker.isHidden = !self.addReminder.isOn
                        self.repeatLabel.isHidden  = !self.addReminder.isOn
                        self.addRepeat.isHidden = !self.addReminder.isOn
                    }
                    
                }else {
                    print("change settings")
                    
                    let uialertView = UIAlertController(title: "settings", message: " Enable Local notificatons in settings if you want this feature", preferredStyle: .alert)
                    
                    
                    uialertView.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: nil))
                    uialertView.addAction(UIAlertAction(title: "Change Settings", style: .default) { value in
                        let path = UIApplicationOpenSettingsURLString
                        if let settingsURL = URL(string: path), UIApplication.shared.canOpenURL(settingsURL) {
                            UIApplication.shared.open(settingsURL,options: [:], completionHandler: nil)
                        }
                    })
                    
                    
                    self.present(uialertView, animated: true, completion: nil)
                }
            }
            
            
            
        }
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    @IBAction func addNewTask(_ sender: Any) {
        
        let task = Task(context: context)
        task.name = taskText.text!
        task.reminder = addReminder.isOn
        task.time = addReminder.isOn ? datePicker.date as NSDate : nil
        task.regular = addRepeat.isOn
        
        
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        if addReminder.isOn {
            addLocalNotification(time: datePicker.date as NSDate, title: "to do app demo", descp:taskText.text ?? "no task is entered" , regular: addRepeat.isOn)
        }
        
        let _ = navigationController?.popViewController(animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func addLocalNotification(time:NSDate,title:String,descp:String,regular:Bool){
        
        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()
            let content = UNMutableNotificationContent()
            content.title = title
            content.body = descp
            content.categoryIdentifier = "alarm"
            content.userInfo = ["customData": "fizzbuzz"]
            content.sound = UNNotificationSound.default()
            
            let triggerDate = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second,], from: time as Date)
            let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: regular)
            
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            center.add(request)
            
        } else {
            
            // ios 9
            let notification = UILocalNotification()
            notification.fireDate = time as Date
            notification.alertBody = descp
            notification.alertAction = title
            notification.soundName = UILocalNotificationDefaultSoundName
            UIApplication.shared.scheduleLocalNotification(notification)
            
        }
    }
    
    
}
