//
//  ContainerCell.swift
//  AR-Info
//
//  Created by Iain Munro on 07/12/2017.
//  Copyright © 2017 Antoine Engelen. All rights reserved.
//

import Foundation
import UIKit

class ContainerTableViewCell: UITableViewCell {
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var picture: UIImageView!
    
    public var container:Container? {
        didSet {
            self.name.text = container?.name
//            self.picture.image = container?.getPicture()
        }
    }
    
}
