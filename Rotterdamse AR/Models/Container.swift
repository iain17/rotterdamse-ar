//
//  Created by Timo Janssen on 17/11/2017.
//  Copyright © 2017 Timo Janssen. All rights reserved.
//

import Foundation
import EventKit
import UIKit

class Container {
    
    var id: Int?
    var containerName: String?
    var desc: String?
    var containerPicture: Data?
    var containerLat: Double?
    var containerLong: Double?
    var containerAltitude: Double?
    var containerCreated: Date?
    
    init(id: Int?, name: String?, desc: String?, picture: String?, lat: Double?, long: Double?, altitude: Double?, created: String?){
        self.id = id
        self.containerName = name
        self.desc = desc
        self.containerPicture = Data(base64Encoded: picture!, options: .ignoreUnknownCharacters)
        self.containerLat = lat
        self.containerLong = long
        self.containerAltitude = altitude
    }
    
    func getPicture() -> UIImage? {
        if let picture = self.containerPicture {
            return UIImage(data: picture)
        }
        return nil
    }
}
