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

    @IBOutlet weak var tableViewContainers: UITableView!
    
    var containerList = [Container]()
    
    override func viewDidLoad() {
        refresh(1)
        self.refreshControl?.endRefreshing()
        
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
                    let containerAltitude = containerObject?["altitude"]
                    let containerCreated = containerObject?["created"]
                    
                    //creating artist object with model and fetched values
                    let container = Container(id: containerId as! Int?, name: containerName as! String?, desc: containerDesc as! String?, picture: containerImage as! String?, lat: containerLat as! Double?, long: containerLong as! Double?, altitude: containerAltitude as! Double?, created: containerCreated as! String?)
                    
                    //appending it to list
                    self.containerList.append(container)
                }
                
                //reloading the tableview
                self.tableViewContainers.reloadData()
            }
        })
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
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: self.reuseIdentifier, for: indexPath) as? ContainerTableViewCell else {
            fatalError("Unexpected Index Path")
        }
        
        let container = self.containerList[indexPath.row]
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
                        desination.container = self.containerList[indexPath.row]
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

