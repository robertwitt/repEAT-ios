//
//  Direction.swift
//  repEAT
//
//  Created by Witt, Robert on 13.10.20.
//

import Foundation

extension Direction {
    
    typealias Position = Int16
    
    func setPosition(_ position: Position) {
        recipe?.moveDirection(self, to: position)
    }
    
}
