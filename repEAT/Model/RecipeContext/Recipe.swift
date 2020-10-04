//
//  Recipe.swift
//  repEAT
//
//  Created by Witt, Robert on 04.10.20.
//

import UIKit

extension Recipe {
    
    var image: UIImage? {
        get {
            guard let imageData = imageData else {
                return nil
            }
            return UIImage(data: imageData)
        }
        set {
            imageData = newValue?.pngData()
        }
    }
    
    func addIngredient(_ food: Food, quantity: Float = 0.0, unit: String? = nil) {
        let ingredient = Ingredient(context: managedObjectContext!)
        ingredient.food = food
        ingredient.quantity = quantity
        ingredient.unit = unit
        addToIngredients(ingredient)
    }
    
    func addDirection(_ depiction: String) {
        let step = Direction(context: managedObjectContext!)
        step.depiction = depiction
        step.orderNumber = Int16(directions?.count ?? 0) + 1
        addToDirections(step)
    }
    
}
