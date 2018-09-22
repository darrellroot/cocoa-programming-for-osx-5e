//
//  MainWindowController.swift
//  Thermostat
//
//  Created by Susan on 2/25/15.
//  Copyright (c) 2015 Big Nerd Ranch. All rights reserved.
//

import Cocoa

class MainWindowController: NSWindowController {

    override var windowNibName: NSNib.Name? {
        return NSNib.Name("MainWindowController")
    }

    var internalTemperature = 68
    @objc dynamic var temperature: Int {
        set {
            print("set temperature to \(newValue)")
            internalTemperature = newValue
        }
        get {
            print("get temperature")
            return internalTemperature
        }
    }
    @objc dynamic var isOn = true
    
    @IBAction func makeWarmer(sender: NSButton) {
        willChangeValue(forKey: "temperature")
        temperature += 1
        didChangeValue(forKey: "temperature")
    }
    
    @IBAction func makeCooler(sender: NSButton) {
        temperature -= 1
    }
    
    @IBAction func updateSwitch(sender: NSButton) {
        if isOn {
            isOn = false
        } else {
            isOn = true
        }
    }

}
