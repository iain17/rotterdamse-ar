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

class ContainerViewController: FormViewController {
    fileprivate let coreDataManager = (UIApplication.shared.delegate as! AppDelegate).coreDataManager
    public var container: Container!
    //    let sceneLocationView = (UIApplication.shared.delegate as! AppDelegate).sceneLocationView
    var locManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = container.name
        if self.title == nil {
            self.title = "Register container"
        }
        
        self.form +++ Section("Container basic info")
            <<< TextRow(){ row in
                row.title = "* Name"
                row.placeholder = "Enter container name"
                row.value = self.container.name
                }.onChange({ (row) in
                    self.container.name = row.value
                })
            <<< TextAreaRow() {
                $0.title = "Notes"
                $0.placeholder = "Anything special about this container?"
                $0.textAreaHeight = .dynamic(initialTextViewHeight: 110)
                $0.value = self.container.notes
                }.onChange({ (row) in
                    self.container.notes = row.value
                })
            <<< ImageRow() {
                $0.title = "* Picture"
                $0.sourceTypes = .All
                $0.clearAction = .no
                if let picture = self.container.picture {
                    $0.value = UIImage(data: picture)
                }
                }.cellUpdate { cell, row in
                    cell.accessoryView?.layer.cornerRadius = 17
                    cell.accessoryView?.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
                }.onChange({ (row) in
                    if let value = row.value {
                        if let data = UIImagePNGRepresentation(value) as Data? {
                            self.container.picture = data as Data
                        }
                    }
                })
            <<< TextRow(){ row in
                row.title = "Latitude"
                row.placeholder = "Enter container name"
                row.value = String(self.container.lat)
                row.disabled = true
                }
            <<< TextRow(){ row in
                row.title = "Longtitude"
                row.placeholder = "Enter container name"
                row.value = String(self.container.lng)
                row.disabled = true
                }
            <<< TextRow(){ row in
                row.title = "Altitude"
                row.placeholder = "Enter container name"
                row.value = String(self.container.altitude)
                row.disabled = true
                }
            <<< ButtonRow() {
                $0.title = "Set to current location"
                }.onCellSelection {_,_ in
                    self.updatePosition()
        }
    }
    
    func updatePosition() {
        var currentLocation: CLLocation?
        if( CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse || CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
            currentLocation = locManager.location
        }
        if let location = currentLocation {
            if location.horizontalAccuracy >= 32 || location.verticalAccuracy >= 5 {
                self.showError(title: "Can't get your location", message: "Horizontal \(location.horizontalAccuracy) meters and or the is \(location.verticalAccuracy) not accurate enough")
                return
            }
            self.container.lat = location.coordinate.latitude
            self.container.lng = location.coordinate.longitude
            self.container.altitude = Double(location.altitude)
            self.showError(title: "Location set", message: "Container location registered with horizontal \(location.horizontalAccuracy) meters of accuracy and vertical \(location.verticalAccuracy) meters of accuracy")
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
        if self.container.created == nil {
            self.container.created = Date()
        }
        
//        if self.container.lat == 0.0 || self.container.lng  == 0.0 || self.container.altitude  == 0.0 {
//            self.updatePosition()
//        }
        
        if self.container.lat == 0.0 || self.container.lng  == 0.0 || self.container.altitude  == 0.0 {
            self.showError(title: "There is no location", message: "Please give the container a position")
            return
        }
        
        if self.container.picture == nil {
            self.showError(title: "No picture", message: "Please select or make a picture of the container")
            return
        }
        
        if self.container.name == nil {
            self.showError(title: "No name", message: "Please enter a name of the container")
            return
        }
        
        do {
            try coreDataManager.managedObjectContext.save()
            self.navigationController?.popViewController(animated: true)
        } catch let error {
            print(error)
        }
    }
    
}
