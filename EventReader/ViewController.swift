//
//  ViewController.swift
//  EventReader
//
//  Created by Himadri Sekhar Jyoti on 04/02/18.
//  Copyright © 2018 Himadri Jyoti. All rights reserved.
//

import UIKit
import ObjectMapper

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let event = HTEventControlClick(appName: "HimApp", appBundleId: "com.him.app", timeStamp: 1234567890, controlName: "HimControlName", title: "HimTitle", accessibilityIdentifier: "HimAccId")
        let events = [event]
        let JSONString = Mapper().toJSONString(events, prettyPrint: false)
        print(JSONString)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

