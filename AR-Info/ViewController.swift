//
//  ViewController.swift
//  AR-Info
//
//  Created by Antoine Engelen on 13/10/2017.
//  Copyright © 2017 Antoine Engelen. All rights reserved.
//

import UIKit
import SceneKit
import ARCL
import CoreLocation

@available(iOS 11.0, *)
class ViewController: UIViewController, SceneLocationViewDelegate{
    let sceneLocationView = SceneLocationView()
    let annotationNode = AnnotationNode()
    let poi = POI()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneLocationView.orientToTrueNorth = true
        sceneLocationView.locationEstimateMethod = .mostRelevantEstimate
        view.addSubview(sceneLocationView)
        poi.makePointsOfinterest(sceneLocationView: sceneLocationView, viewController: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        sceneLocationView.run()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneLocationView.pause()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        sceneLocationView.frame = view.bounds
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: SceneLocationViewDelegate
    
    func sceneLocationViewDidAddSceneLocationEstimate(sceneLocationView: SceneLocationView, position: SCNVector3, location: CLLocation) {
    }
    
    func sceneLocationViewDidRemoveSceneLocationEstimate(sceneLocationView: SceneLocationView, position: SCNVector3, location: CLLocation) {
    }
    
    func sceneLocationViewDidConfirmLocationOfNode(sceneLocationView: SceneLocationView, node: LocationNode) {
    }
    
    func sceneLocationViewDidSetupSceneNode(sceneLocationView: SceneLocationView, sceneNode: SCNNode) {
    }
    
    func sceneLocationViewDidUpdateLocationAndScaleOfLocationNode(sceneLocationView: SceneLocationView, locationNode: LocationNode) {
    }
}
