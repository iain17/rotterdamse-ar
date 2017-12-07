//
//  DatabaseTableViewController.swift
//  AR-Info
//
//  Created by Antoine Engelen on 07/12/2017.
//  Copyright © 2017 Antoine Engelen. All rights reserved.
//

import UIKit
import EventKit
import CoreData

class GoalsTableViewController: UITableViewController {
    let reuseIdentifier = "ContainerCell"
    
    fileprivate let coreDataManager = (UIApplication.shared.delegate as! AppDelegate).coreDataManager
    
    fileprivate lazy var fetchedResultsController: NSFetchedResultsController<Container> = {
        // Create Fetch Request
        let fetchRequest: NSFetchRequest<Container> = Container.fetchRequest()
        
        // Configure Fetch Request
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "created", ascending: false)]
        
        // Create Fetched Results Controller
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.coreDataManager.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        
        // Configure Fetched Results Controller
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }()
    
    override func viewDidLoad() {
        refresh(1)
        self.refreshControl?.endRefreshing()
    }
    
    @IBAction func refresh(_ sender: Any) {
        do {
            try fetchedResultsController.performFetch()
        } catch {
            let fetchError = error as NSError
            print("Unable to fetch containers")
            print("\(fetchError), \(fetchError.localizedDescription)")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = fetchedResultsController.sections else {
            return 0
        }
        
        let sectionInfo = sections[section]
        return sectionInfo.numberOfObjects
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        let object = fetchedResultsController.object(at: indexPath)
        fetchedResultsController.managedObjectContext.delete(object)
        try? fetchedResultsController.managedObjectContext.save()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: self.reuseIdentifier, for: indexPath) as? ContainerTableViewCell else {
            fatalError("Unexpected Index Path")
        }
        
        let container = fetchedResultsController.object(at: indexPath)
        cell.container = container
        
        return cell
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let desination = segue.destination as? ContainerViewController {
            if let identifier = segue.identifier{
                switch(identifier) {
                case "editContainer":
                    if let indexPath = self.tableView.indexPathForSelectedRow {
                        desination.container = fetchedResultsController.object(at: indexPath)
                    }
                    break
                case "addContainer":
                    desination.container = Container(context: self.coreDataManager.managedObjectContext)
                    desination.container.resetToDefaults()
                    break
                default:
                    print("dunno what to do with \(identifier)")
                    break
                }
                
            }
        }
    }
    
}

