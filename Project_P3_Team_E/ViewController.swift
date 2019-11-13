//
//  ViewController.swift
//  Project_P3_Team_E
//
//  Created by Mack Ross on 10/22/19.
//  Copyright © 2019 Mack Ross. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var prompts: Results<Prompt>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        navigationController?.navigationBar.tintColor = .orange
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        if let index = self.tableView.indexPathForSelectedRow
        {
            self.tableView.deselectRow(at: index, animated: true)
        }
        queryPrompts()
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem()
        backItem.title = "Back"
        navigationItem.backBarButtonItem = backItem
        
        if segue.identifier == "selectedPrompt" {
            let nextVC = segue.destination as? SelectedViewController
            let index = (self.tableView.indexPathForSelectedRow?.row)!
            let selectedPrompt = prompts?[index]
            nextVC!.prompt = selectedPrompt
        }
    }
    
    func queryPrompts() {
        let realm = try! Realm()
        prompts = realm.objects(Prompt.self)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return prompts?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        cell.textLabel?.text = prompts?[indexPath.row].name
        cell.detailTextLabel?.text = prompts?[indexPath.row].date
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "selectedPrompt", sender: self)
    }

}

