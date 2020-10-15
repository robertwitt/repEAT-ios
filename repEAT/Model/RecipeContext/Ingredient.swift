//
//  Ingredient.swift
//  repEAT
//
//  Created by Witt, Robert on 05.10.20.
//

import Foundation

extension Ingredient {
    
    typealias Quantity = Float
    
    var quantityUnit: UnitOfMeasure? {
        return food?.baseUnit
    }
    
    var formattedQuantity: String? {
        guard quantity > 0 else {
            return nil
        }
        return quantity.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", quantity) : String(quantity)
    }
    
    var formattedQuantityWithUnit: String? {
        guard let quantity = formattedQuantity else {
            return nil
        }
        guard let unitCode = quantityUnit?.code else {
            return quantity
        }
        return "\(quantity) \(unitCode)"
    }
    
}
