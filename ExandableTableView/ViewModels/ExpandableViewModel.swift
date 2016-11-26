//
//  ExpandableViewModel.swift
//  ExandableTableView
//
//  Created by Eli Pacheco Hoyos on 11/25/16.
//  Copyright © 2016 Eli Pacheco Hoyos. All rights reserved.
//

import UIKit

enum ExpandableAction {
    case Close(indexPaths: [IndexPath])
    case Open(indexPaths: [IndexPath])
    case LeafSelected(at: IndexPath)
}

typealias ExpandableListener = (ExpandableAction) -> ()

class ExpandableViewModel: NSObject {

    private let rootExapandable: Expandable<String>
    var exapandableListener: ExpandableListener?
    var devices: [Expandable<String>]? {
        return rootExapandable.list()
    }
    
    override init() {
        
        rootExapandable = Expandable("Devices")
        
        let smarthphones = Expandable("Smarthphone")
        let ios = Expandable("IOS")
        let android = Expandable("Android")
        
        let iphone = Expandable("Iphone")
        let appleWatch = Expandable("Apple Watch")
        let tvOS = Expandable("TVOS")
        
        let iphone4s = Expandable("Iphone 4s")
        let iphone5s = Expandable("Iphone 5s")
        let iphone7 = Expandable("Iphone 7")
        
        let nexus = Expandable("Nexus")
        let samsung = Expandable("Samsung")
        let huawei = Expandable("Huawei")
        
        let pc = Expandable("PC")
        let wearable = Expandable("Wearable")
        let tv = Expandable("TV")
        
        let bravia = Expandable("Bravia")
        let trinitron = Expandable("Trinitron")
        
        rootExapandable.add([smarthphones, pc, wearable, tv])
        smarthphones.add([ios, android])
        ios.add([iphone, appleWatch, tvOS])
        iphone.add([iphone4s, iphone5s, iphone7])
        android.add([nexus, samsung, huawei])
        tv.add([bravia, trinitron])
        
        rootExapandable.isOpen = false
        ios.isOpen = false
        iphone.isOpen = false
        android.isOpen = false
        smarthphones.isOpen = false
        tv.isOpen = false

    }
    
    func value(_ at: IndexPath) -> String {
        if let device = devices?[at.row] {
            var valueForIndex = "\(device.level)." + device.value
            for _ in 0 ... device.level {
                valueForIndex.characters.insert("-", at: valueForIndex.startIndex)
            }
            return valueForIndex
        }
        
        return " "
    }
    
    func deviceSelected(_ at: IndexPath) {
        
        if let device = devices?[at.row] {
            if device.canExpand {
                if device.isOpen {
                    let indexesToClose = indexesToAfect(device, at)
                    device.isOpen = false
                    exapandableListener?(ExpandableAction.Close(indexPaths: indexesToClose))
                }
                else {
                    device.isOpen = true
                    let indexesToShow = indexesToAfect(device, at)
                    exapandableListener?(ExpandableAction.Open(indexPaths: indexesToShow))
                }
            }
            else {
                exapandableListener?(ExpandableAction.LeafSelected(at: at))
            }
            
        }
    }
    
    private func indexesToAfect(_ expandable: Expandable<String>, _ at: IndexPath) -> [IndexPath] {
        
        let devicesToInteract = expandable.nodesToShow()
        var devicesIndexesToInteract = [IndexPath]()
        let startIndex = at.row + 1
        let endIndex = at.row + devicesToInteract
        
        for index in startIndex ... endIndex {
            devicesIndexesToInteract.append(IndexPath(row: index, section: 0))
        }
        
        return devicesIndexesToInteract
    }
    
}
