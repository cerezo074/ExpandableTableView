//
//  Node.swift
//  ExandableTableView
//
//  Created by Eli Pacheco Hoyos on 11/25/16.
//  Copyright © 2016 Eli Pacheco Hoyos. All rights reserved.
//

import UIKit

class Node<T: Equatable> {
    
    var value: T
    var children: [Node] = []
    var level: Int = 0
    var profundity: Int {
        return maxLevels(deep: 0)
    }
    var isLeaf: Bool {
        return children.count == 0
    }
    weak var parent: Node?
    
    init(_ value: T) {
        self.value = value
    }
    
    func add(_ child: Node) {
        children.append(child)
        child.parent = self
        child.level = level + 1
    }
    
    func add(_ arrayChild: [Node]) {
        for child in arrayChild {
            add(child)
        }
    }
    
    func search(_ value: T) -> Node? {
        
        if value == self.value {
            return self
        }
        
        if !children.isEmpty {
            for child in children {
                if let result = child.search(value) {
                    return result
                }
            }
        }
        
        return nil
    }
    
    func allNodes(includeLeafs: Bool) -> [Node]? {
        let nodesContainer = NSMutableArray()
        walkThroughChildren(includeLeafs, nodesContainer)
        
        if nodesContainer.count > 0 {
            return nodesContainer.map({ $0 as! Node })
        }
        
        return nil
    }
    
    private func walkThroughChildren (_ includeLeafs: Bool, _ container: NSMutableArray) {
        if !children.isEmpty {
            container.add(self)
            for child in children {
                child.walkThroughChildren(includeLeafs, container)
            }
        }
        else {
            if includeLeafs {
                container.add(self)
            }
        }
    }
    
    private func maxLevels(deep: Int) -> Int {
        if !children.isEmpty {
            var maxProfundity = 0
            for child in children {
                let currentProfundity = child.maxLevels(deep: deep + 1)
                if maxProfundity < currentProfundity {
                    maxProfundity = currentProfundity
                }
            }
            return maxProfundity
        }
        else {
            return deep
        }
    }
    
}

extension Node: CustomStringConvertible {
    
    var description: String {
        var text = "\(value)"
        
        if !children.isEmpty {
            text += " {" + children.map({ $0.description }).joined(separator: ", ") + "} "
        }
        
        return text
    }
    
}
