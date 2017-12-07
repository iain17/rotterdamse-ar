//
//  Calendar.swift
//  CalSum
//
//  Created by Iain Munro on 25/11/2017.
//  Copyright © 2017 Iain Munro. All rights reserved.
//

import Foundation
import CoreData
import EventKit
import UIKit

public class Container: NSManagedObject {
    func resetToDefaults() {
        
    }
    
    func getPicture() -> UIImage? {
        if let picture = self.picture {
            return UIImage(data: picture)
        }
        return nil
    }
}
