//
//  AddContainerViewController.swift
//  AR-Info
//
//  Created by Iain Munro on 07/12/2017.
//  Copyright © 2017 Antoine Engelen. All rights reserved.
//

import UIKit
import Eureka
import ImageRow
import CoreLocation
import Firebase

class ContainerViewController: FormViewController {
//    fileprivate let coreDataManager = (UIApplication.shared.delegate as! AppDelegate).coreDataManager
    public var container: Container!
    let sceneLocationView = (UIApplication.shared.delegate as! AppDelegate).sceneLocationView
    var refContainers: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refContainers = Database.database().reference().child("containers");
        self.title = container.containerName
        if self.title == nil {
            self.title = "Register container"
        }
        
        self.form +++ Section("Container basic info")
            <<< TextRow(){ row in
                row.title = "* Name"
                row.placeholder = "Enter container name"
                row.value = self.container.containerName
            }.onChange({ (row) in
                self.container.containerName = row.value
            })
            <<< TextAreaRow() {
                $0.title = "Notes"
                $0.placeholder = "Anything special about this container?"
                $0.textAreaHeight = .dynamic(initialTextViewHeight: 110)
                $0.value = self.container.desc
            }.onChange({ (row) in
                self.container.desc = row.value
            })
            <<< ImageRow() {
                $0.title = "* Picture"
                $0.sourceTypes = .All
                $0.clearAction = .no
                if let picture = self.container.containerPicture {
                    $0.value = UIImage(data: picture)
                }
            }.cellUpdate { cell, row in
                cell.accessoryView?.layer.cornerRadius = 17
                cell.accessoryView?.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
            }.onChange({ (row) in
                if let value = row.value {
                    if let data = UIImagePNGRepresentation(value) as Data? {
                        self.container.containerPicture = data as Data
                    }
                }
            })
            <<< ButtonRow() {
                $0.title = "Set to current location"
                }.onCellSelection {_,_ in
                self.updatePosition()
            }
    }

    func updatePosition() {
        if let location = self.sceneLocationView.currentLocation() {
            if location.horizontalAccuracy >= 32 {
                self.showError(title: "Can't get your location", message: "\(location.horizontalAccuracy) meters is not accurate enough")
                return
            }
            self.container.containerLat = location.coordinate.latitude
            self.container.containerLong = location.coordinate.longitude
            self.container.containerAltitude = Double(location.altitude)
            self.showError(title: "Location set", message: "Container location registered with \(location.horizontalAccuracy) meters of accuracy")
        }
    }
    
    func showError(title: String, message: String) {
        DispatchQueue.main.async {
            // create the alert
            let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
            // add an action (button)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            // show the alert
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func save(_ sender: Any) {
        if self.container.containerCreated == nil {
            self.container.containerCreated = Date()
        }
        
        if self.container.containerLat == 0.0 || self.container.containerLong  == 0.0 || self.container.containerAltitude  == 0.0 {
            self.updatePosition()
        }
        
//        if self.container.containerLat == 0.0 || self.container.containerLong  == 0.0 || self.container.containerAltitude  == 0.0 {
//            return
//        }
        
        if self.container.containerPicture == nil {
            self.showError(title: "No picture", message: "Please select or make a picture of the container")
            return
        }
        
        if self.container.containerName == nil {
            self.showError(title: "No name", message: "Please enter a name of the container")
            return
        }
        
        if self.container.desc == nil {
            self.showError(title: "No description", message: "Please set a description for this container")
            return
        }
        
        do {
//            try coreDataManager.managedObjectContext.save()
            print("HEREREAREA1")
            print(self.container.id)
            if self.container.id == nil {
                let newBookRef = self.refContainers!
                    .childByAutoId()
                
                let newContainerId = newBookRef.key
                self.container.id = newContainerId
                
                let dateFormatter = DateFormatter()
                
                print("HERERERER")
                print(self.container.containerLat)
                
                let newContainerData = [
                    "created": dateFormatter.string(from: self.container.containerCreated!) as! NSString,
                    "desc": self.container.desc as! NSString,
                    "image": self.container.containerPicture!.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0)) as NSString,
                    "lat": self.container.containerLat! as! NSNumber,
                    "long": self.container.containerLong! as! NSNumber,
                    "name": self.container.containerName as! NSString,
                    "altitude": self.container.containerAltitude! as! NSNumber
                ]
                
                newBookRef.setValue(newContainerData)
            }
            self.navigationController?.popViewController(animated: true)
        } catch let error {
            print(error)
        }
    }
    
}
