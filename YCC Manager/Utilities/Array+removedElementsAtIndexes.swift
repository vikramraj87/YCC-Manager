//
//  Array+removedElementsAtIndexes.swift
//  YCC Manager
//
//  Created by Vikram Raj Gopinathan on 13/06/19.
//  Copyright © 2019 Vikram Raj Gopinathan. All rights reserved.
//

import Foundation


extension Array {
    func removedElementsAtIndexes(_ indexes: [Int]) -> [Element] {
        var newElements: [Element] = []
        newElements.reserveCapacity(self.count - indexes.count + 1)
        
        for (index, item) in enumerated() {
            if !indexes.contains(index) {
                newElements.append(item)
            }
        }
        return newElements
        
    }
}
