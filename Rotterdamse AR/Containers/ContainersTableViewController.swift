//
//  DatabaseTableViewController.swift
//  AR-Info
//
//  Created by Antoine Engelen on 07/12/2017.
//  Copyright © 2017 Antoine Engelen. All rights reserved.
//

import UIKit
import EventKit
import Firebase

class GoalsTableViewController: UITableViewController {
    let reuseIdentifier = "ContainerCell"
    
    var refContainers: DatabaseReference!
    
//    fileprivate let coreDataManager = (UIApplication.shared.delegate as! AppDelegate).coreDataManager
    
    var containerList = [Container]()
    
    
//    fileprivate lazy var fetchedResultsController: NSFetchedResultsController<Container> = {
//        // Create Fetch Request
//        let fetchRequest: NSFetchRequest<Container> = Container.fetchRequest()
//
//        // Configure Fetch Request
//        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "created", ascending: false)]
//
//        // Create Fetched Results Controller
//        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.coreDataManager.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
//
//        // Configure Fetched Results Controller
//        fetchedResultsController.delegate = self
//
//        return fetchedResultsController
//    }()
    
    override func viewDidLoad() {
        refresh(1)
        self.refreshControl?.endRefreshing()
        
        FirebaseApp.configure()
        
        refContainers = Database.database().reference().child("containers");
        
        //observing the data changes
        refContainers.observe(DataEventType.value, with: { (snapshot) in
            
            //if the reference have some values
            if snapshot.childrenCount > 0 {
                
                //clearing the list
                self.containerList.removeAll()
                
                //iterating through all the values
                for containers in snapshot.children.allObjects as! [DataSnapshot] {
                    //getting values
                    let containerObject = containers.value as? [String: AnyObject]
                    let containerName  = containerObject?["name"]
                    let containerId  = containerObject?["id"]
                    let containerDesc = containerObject?["desc"]
                    let containerImage = containerObject?["image"]
                    let containerLat = containerObject?["lat"]
                    let containerLong = containerObject?["long"]
                    
                    //creating artist object with model and fetched values
                    let container = Container(id: containerId as! String?, name: containerName as! String?, desc: containerDesc as! String?, picture: containerImage as! UIImage?, lat: containerLat as! Double?, long: containerLong as! Double?)
                    
                    //appending it to list
                    self.containerList.append(container)
                }
                
                //reloading the tableview
//                self.tableViewContainers.reloadData()
            }
        })
    }
    
    @IBAction func refresh(_ sender: Any) {
        do {
//            try fetchedResultsController.performFetch()
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
        return containerList.count
    }
    
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        guard editingStyle == .delete else { return }
//        let object = fetchedResultsController.object(at: indexPath)
//        fetchedResultsController.managedObjectContext.delete(object)
//        try? fetchedResultsController.managedObjectContext.save()
//    }
    
//    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
//        //creating a cell using the custom class
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ContainerTableViewCell
//
//        //the artist object
//        let container: Container
//
//        //getting the artist of selected position
//        container = containerList[indexPath.row]
//
//        //adding values to labels
//        cell.labelName.text = container.name
//        cell.labelGenre.text = container.desc
//
//        //returning cell
//        return cell
//    }
    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: self.reuseIdentifier, for: indexPath) as? ContainerTableViewCell else {
//            fatalError("Unexpected Index Path")
//        }
//
//        let container = fetchedResultsController.object(at: indexPath)
//        cell.container = container
//
//        return cell
//    }
//
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let desination = segue.destination as? ContainerViewController {
            if let identifier = segue.identifier{
                switch(identifier) {
                case "editContainer":
                    if let indexPath = self.tableView.indexPathForSelectedRow {
                        desination.container = self.containerList[indexPath.row]
//                            fetchedResultsController.object(at: indexPath)
                    }
                    break
                case "addContainer":
//                    desination.container = Container(context: self.coreDataManager.managedObjectContext)
//                    desination.container.resetToDefaults()
                    break
                default:
                    print("dunno what to do with \(identifier)")
                    break
                }
                
            }
        }
    }
    
}

