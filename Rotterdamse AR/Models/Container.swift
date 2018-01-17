//
//  Calendar.swift
//  CalSum
//
//  Created by Iain Munro on 25/11/2017.
//  Copyright © 2017 Iain Munro. All rights reserved.
//

import Foundation
//import CoreData
import EventKit
import UIKit

//public class Container: NSManagedObject {
//    func resetToDefaults() {
//
//    }
//
//    func getPicture() -> UIImage? {
//        if let picture = self.picture {
//            return UIImage(data: picture)
//        }
//        return nil
//    }
//}

class Container {
    
    var id: String?
    var containerName: String?
    var desc: String?
    var containerPicture: UIImage?
    var containerLat: Double?
    var containerLong: Double?
    
    init(id: String?, name: String?, desc: String?, picture: UIImage?, lat: Double?, long: Double?){
        self.id = id
        self.containerName = name
        self.desc = desc
        self.containerPicture = picture
        self.containerLat = lat
        self.containerLong = long
    }
}
