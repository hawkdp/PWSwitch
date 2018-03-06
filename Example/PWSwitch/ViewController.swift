//
//  ViewController.swift
//  PWSwitch
//
//  Created by Nikita Shanin on 08/30/2016.
//  Copyright (c) 2016 Nikita Shanin. All rights reserved.
//

import UIKit
import PWSwitch

class ViewController: UIViewController {
    @IBOutlet var switchControls: [PWSwitch]!

    @IBAction func toggleButtonTapped(_ sender: Any) {
        switchControls.forEach { $0.toggle() }
    }
}

