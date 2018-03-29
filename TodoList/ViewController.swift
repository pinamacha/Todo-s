//
//  ViewController.swift
//  ToDo
//
//  Created by Yeswanth varma Kanumuri on 6/14/17.
//  Copyright © 2017 Yeswanth varma Kanumuri. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var tasks :[Task] = []
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        // Do any additional setup after loading the view, typically from a nib.
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //        let userDefaults = UserDefaults.standard
        //        print(userDefaults.value(forKey: "backgroundColor"))
        getData()
        tableView.reloadData()
    }
    
    func getData(){
        
        do {
            
            tasks = try context.fetch(Task.fetchRequest())
        }
        catch {
            
            print("error fetching data")
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        let rowtask = tasks[indexPath.row]
        if let taskName = rowtask.name {
            cell.textLabel?.text = taskName
        }
        if let time = rowtask.time?.description {
            cell.detailTextLabel?.text = time
        }
        if rowtask.regular {
            cell.accessoryType = .checkmark
        }
        return cell
        
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let task = tasks[indexPath.row]
            context.delete(task)
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            getData()
            tableView.reloadData()
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

