//
//  POI.swift
//  AR-Info
//
//  Created by Antoine Engelen on 13/10/2017.
//  Copyright © 2017 Antoine Engelen. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import ARCL
import SceneKit
import Firebase

class POI: UITableViewController {
    var refContainers: DatabaseReference!
    
    var containerList = [Container]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
                    let containerId  = containers.key
                    let containerDesc = containerObject?["desc"]
                    let containerImage = containerObject?["image"]
                    let containerLat = containerObject?["lat"]
                    let containerLong = containerObject?["long"]
                    let containerAltitude = containerObject?["altitude"]
                    let containerCreated = containerObject?["created"]
                    
                    //creating artist object with model and fetched values
                    let container = Container(id: containerId as String?, name: containerName as! String?, desc: containerDesc as! String?, picture: containerImage as! String?, lat: containerLat as! Double?, long: containerLong as! Double?, altitude: containerAltitude as! Double?, created: containerCreated as! String?)
                    
                    //appending it to list
                    self.containerList.append(container)
                }
                
                //reloading the tableview
//                self.tableViewContainers.reloadData()
            }
        })
    }
//    fileprivate let coreDataManager = (UIApplication.shared.delegate as! AppDelegate).coreDataManager
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
    
    var groups = [[String]]()
    
    func makePointsOfinterest(sceneLocationView: SceneLocationView, viewController: ARViewController) {
        sceneLocationView.removeAll()
        
        var tempLocation: CLLocation? = nil
        
        let sections = self.containerList
        for group in sections {
            let pinCoordinate = CLLocationCoordinate2D(latitude: Double(group.lat), longitude: Double(group.lng))
            let pinLocation = CLLocation(coordinate: pinCoordinate, altitude: Double(group.altitude))
            if tempLocation != nil {
                print(pinLocation.distance(from: tempLocation!))
            }
            tempLocation = pinLocation
//            let pinImage = group.getPicture()
            let pinImage: UIImage? = nil
            if pinImage == nil {
                continue
            }
            var description = ""
            if let name = group.name {
                description += name
            }
            if let notes = group.notes {
                description += "\n"
                description += notes
            }
            //Render overlay image
            if let image = overlayTextOverImage(image: pinImage!, text: description, viewController: viewController) {
                let pinLocationNode = LocationAnnotationNode(location: pinLocation, image: image)
                pinLocationNode.scaleRelativeToDistance = true
                pinLocationNode.castsShadow = true
                sceneLocationView.addLocationNodeWithConfirmedLocation(locationNode: pinLocationNode)
            }
        }
    }
    
    private func imageFrom(text: String , size:CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        let img = renderer.image { ctx in
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .left
            let attrs = [NSAttributedStringKey.font: UIFont(name: "HelveticaNeue-Bold", size: 36)!, NSAttributedStringKey.foregroundColor: UIColor.white, NSAttributedStringKey.paragraphStyle: paragraphStyle]
            text.draw(with: CGRect(x: 50, y: size.height/2-140, width: size.width - 75, height: size.height), options: .usesLineFragmentOrigin, attributes: attrs, context: nil)
        }
        return img
    }
    
    private func overlayTextOverImage (image: UIImage, text: String, viewController: ARViewController) -> UIImage? {
        let viewToRender = UIView(frame: CGRect(x: 0, y: 0, width: viewController.view.frame.size.width, height: viewController.view.frame.size.width))
        let imgView = UIImageView(frame: viewToRender.frame)
        imgView.image = image
        
        imgView.transform = imgView.transform.rotated(by: CGFloat(M_PI_2))
        
        viewToRender.addSubview(imgView)
        let textImgView = UIImageView(frame: viewToRender.frame)
        textImgView.image = imageFrom(text: text, size: viewToRender.frame.size)
        viewToRender.addSubview(textImgView)
        UIGraphicsBeginImageContextWithOptions(viewToRender.frame.size, false, 0)
        viewToRender.layer.render(in: UIGraphicsGetCurrentContext()!)
        let finalImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return finalImage
    }
}


