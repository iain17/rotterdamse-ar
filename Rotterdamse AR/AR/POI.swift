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
import CoreData

class POI: UITableViewController {
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
    
    var groups = [[String]]()
    //    init() {
    //        // we create three simple string arrays for testing
    //        self.groups = [["51.504607", "-0.019592", "236", "pin", "Canary Wharf\nLondon\nGreat Brittian"],
    //                       ["51.7347508", "5.8657363", "8.6", "pin", "Sleedoorn 17\nCuijk\n5432AH\nThe Netherlands"],
    //                       ["51.7347484", "5.8657708", "8.6", "pin", "Example\nCuijk\n5432AH\nThe Netherlands"],
    //                       ["51.7196017", "5.8838103", "12.5", "pin", "Korhoenderveld 53\n5431HB\nCuijk\nThe Netherlands"],
    //                       ["51.988164", "5.950363", "12.5", "pin", "HAN\nRuitenberglaan 26\nArnhem\nThe Netherlands"],
    //                       ["51.986946", "5.952091", "12.5", "pin", "HAN C-Vleugel\nRuitenberglaan 26\nArnhem\nThe Netherlands"]]
    //   }
    
    func removePointsOfinterest(sceneLocationView: SceneLocationView) {
        for eachNode in sceneLocationView.scene.rootNode.childNodes {
            eachNode.removeFromParentNode()
        }
    }
    
    func makePointsOfinterest(sceneLocationView: SceneLocationView, viewController: ARViewController) {
        var tempLocation: CLLocation? = nil
        //        for group in self.groups {
        //            let pinCoordinate = CLLocationCoordinate2D(latitude: Double(group[0])!, longitude: Double(group[1])!)
        //          let pinLocation = CLLocation(coordinate: pinCoordinate, altitude: Double(group[2])!)
        //        if tempLocation != nil {
        //           print(pinLocation.distance(from: tempLocation!))
        //          }
        //           tempLocation = pinLocation
        //          let pinImage = UIImage(named: group[3])!
        //          let pinLocationNode = LocationAnnotationNode(location: pinLocation, image: overlayTextOverImage(image: pinImage, text: group[4], viewController: viewController)!)
        //         pinLocationNode.scaleRelativeToDistance = true
        //         pinLocationNode.castsShadow = true
        //           sceneLocationView.addLocationNodeWithConfirmedLocation(locationNode: pinLocationNode)
        //       }
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            let fetchError = error as NSError
            print("Unable to fetch containers")
            print("\(fetchError), \(fetchError.localizedDescription)")
        }
        
        let sections = fetchedResultsController.fetchedObjects
        for group in sections! {
            let pinCoordinate = CLLocationCoordinate2D(latitude: Double(group.lat), longitude: Double(group.lng))
            let pinLocation = CLLocation(coordinate: pinCoordinate, altitude: Double(group.altitude))
            if tempLocation != nil {
                print(pinLocation.distance(from: tempLocation!))
            }
            tempLocation = pinLocation
            let pinImage = group.getPicture()
            let pinLocationNode = LocationAnnotationNode(location: pinLocation, image: overlayTextOverImage(image: pinImage!, text: group.name! + "\n" + group.notes!, viewController: viewController)!)
            pinLocationNode.scaleRelativeToDistance = true
            pinLocationNode.castsShadow = true
            sceneLocationView.addLocationNodeWithConfirmedLocation(locationNode: pinLocationNode)
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


