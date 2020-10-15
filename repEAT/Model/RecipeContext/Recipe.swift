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
    
    func createIngredient(_ food: Food? = nil, quantity: Ingredient.Quantity = 0.0) -> Ingredient {
        let ingredient = Ingredient(context: managedObjectContext!)
        ingredient.food = food
        ingredient.quantity = quantity
        addToIngredients(ingredient)
        return ingredient
    }
    
    func deleteIngredient(_ ingredient: Ingredient) {
        removeFromIngredients(ingredient)
        managedObjectContext?.delete(ingredient)
    }
    
    var sortedDirections: [Direction] {
        let sortDescriptor = NSSortDescriptor(key: "position", ascending: true)
        return directions?.sortedArray(using: [sortDescriptor]) as? [Direction] ?? []
    }
    
    func createDirection(_ depiction: String? = nil) -> Direction {
        let direction = Direction(context: managedObjectContext!)
        direction.depiction = depiction
        direction.position = Direction.Position(directions?.count ?? 0) + 1
        addToDirections(direction)
        return direction
    }
    
    func deleteDirection(_ direction: Direction) {
        removeFromDirections(direction)
        managedObjectContext?.delete(direction)
        reorderDirections(sortedDirections)
    }
    
    func moveDirection(_ direction: Direction, to newPosition: Direction.Position) {
        var directions = sortedDirections
        directions.removeAll { (object) -> Bool in
            return object == direction
        }
        directions.insert(direction, at: Int(newPosition) - 1)
        reorderDirections(directions)

        direction.position = newPosition
    }
    
    private func reorderDirections(_ directions: [Direction]) {
        var position: Direction.Position = 1
        directions.forEach { (remainingDirection) in
            remainingDirection.position = position
            position += 1
        }
    }
    
}
