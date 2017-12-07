//
//  annotationNode.swift
//  AR-Info
//
//  Created by Antoine Engelen on 13/10/2017.
//  Copyright © 2017 Antoine Engelen. All rights reserved.
//

import UIKit
import ARCL
import CoreLocation

struct AnnotationNode {
    func makeAnnotationNode() -> LocationAnnotationNode {
        //Currently set to Canary Wharf
        let coordinate = CLLocationCoordinate2D(latitude: 51.504607, longitude: -0.019592)
        let location = CLLocation(coordinate: coordinate, altitude: 300)
        let image = UIImage(named: "pin")!
        
        let annotationNode = LocationAnnotationNode(location: location, image: image)
        annotationNode.scaleRelativeToDistance = true
        
        return annotationNode
    }
}
