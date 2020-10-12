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
    
    var sortedIngredients: [Ingredient] {
        let sortDescriptor = NSSortDescriptor(key: "food", ascending: true) { (food1, food2) -> ComparisonResult in
            guard let food1 = food1 as? Food, let food2 = food2 as? Food else {
                return .orderedSame
            }
            if food1.name == food2.name {
                return .orderedSame
            } else if food1.name ?? "" < food2.name ?? "" {
                return .orderedAscending
            } else {
                return .orderedDescending
            }
        }
        
        return ingredients?.sortedArray(using: [sortDescriptor]) as? [Ingredient] ?? []
    }
    
    func addIngredient(_ food: Food, quantity: Float = 0.0, unit: String? = nil) {
        let ingredient = Ingredient(context: managedObjectContext!)
        ingredient.food = food
        ingredient.quantity = quantity
        ingredient.unit = unit
        addToIngredients(ingredient)
    }
    
    func deleteIngredient(_ ingredient: Ingredient) {
        removeFromIngredients(ingredient)
        managedObjectContext?.delete(ingredient)
    }
    
    var sortedDirections: [Direction] {
        let sortDescriptor = NSSortDescriptor(key: "orderNumber", ascending: true)
        return directions?.sortedArray(using: [sortDescriptor]) as? [Direction] ?? []
    }
    
    func addDirection(_ depiction: String) {
        let step = Direction(context: managedObjectContext!)
        step.depiction = depiction
        step.orderNumber = Int16(directions?.count ?? 0) + 1
        addToDirections(step)
    }
    
    func deleteDirection(_ direction: Direction) {
        removeFromDirections(direction)
        managedObjectContext?.delete(direction)
        reorderDirections()
    }
    
    private func reorderDirections() {
        var order: Int16 = 1
        sortedDirections.forEach { (remainingDirection) in
            remainingDirection.orderNumber = order
            order += 1
        }
    }
    
}
