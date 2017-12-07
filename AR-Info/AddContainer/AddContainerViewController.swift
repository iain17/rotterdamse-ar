//
//  AddContainerViewController.swift
//  AR-Info
//
//  Created by Iain Munro on 07/12/2017.
//  Copyright © 2017 Antoine Engelen. All rights reserved.
//

import UIKit
import Eureka

class AddContainerViewController: FormViewController {

    public var container: Container!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.form +++ Section("Container basic info")
            <<< TextRow(){ row in
                row.title = "Name"
                row.placeholder = "Enter container name"
            }.onChange({ (row) in
                self.container.name = row.value
            })
            <<< TextAreaRow() {
                $0.title = "Notes"
                $0.placeholder = "Anything special about this container?"
                $0.textAreaHeight = .dynamic(initialTextViewHeight: 110)
            }

    }
    
}
