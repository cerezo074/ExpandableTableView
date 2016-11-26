//
//  Expandable.swift
//  ExandableTableView
//
//  Created by Eli Pacheco Hoyos on 11/25/16.
//  Copyright © 2016 Eli Pacheco Hoyos. All rights reserved.
//

import UIKit

class Expandable<T: Equatable>: Node<T> {
    
    var isOpen: Bool = false
    var canExpand: Bool {
        return !children.isEmpty
    }
    
    func list() -> [Expandable]? {
        let container = NSMutableArray()
        walkThroughExapandable(container)
        if container.count > 0 {
            return container.map({ $0 as! Expandable })
        }
        
        return nil
    }
    
    func nodesToShow() -> Int {
        if let childs = list(), isOpen {
            return childs.count - 1
        }
        
        return 0
    }
    
    private func walkThroughExapandable(_ container: NSMutableArray) {
        if canExpand && isOpen {
            container.add(self)
            for child in children {
                guard let expandableChild = child as? Expandable else {
                    return
                }
                expandableChild.walkThroughExapandable(container)
            }
        }
        else {
            container.add(self)
        }
    }
    
}
