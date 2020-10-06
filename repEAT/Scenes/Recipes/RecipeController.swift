//
//  RecipeViewControllerDataSource.swift
//  repEAT
//
//  Created by Witt, Robert on 04.10.20.
//

import UIKit

class RecipeController {
    
    enum Section: Int {
        case details = 0
        case ingredients = 1
        case directions = 2
    }
    
    let recipe: Recipe
    
    init(with recipe: Recipe) {
        self.recipe = recipe
    }
    
    var numberOfSections: Int {
        var count = 1
        if recipe.ingredients?.count ?? 0 > 0 {
            count += 1
        }
        if recipe.directions?.count ?? 00 > 0 {
            count += 1
        }
        return count
    }
    
    func headerTitle(of section: Int) -> String? {
        switch Section(rawValue: section) {
        case .details:
            return NSLocalizedString("titleDetails", comment: "")
        case .ingredients:
            return NSLocalizedString("titleIngredients", comment: "")
        case .directions:
            return NSLocalizedString("titleDirections", comment: "")
        default:
            return nil
        }
    }
    
    func numberOfRows(in section: Int) -> Int {
        switch Section(rawValue: section) {
        case .details:
            return 1
        case .ingredients:
            return recipe.ingredients?.count ?? 0
        case .directions:
            return recipe.directions?.count ?? 0
        default:
            return 0
        }
    }
    
    func ingredient(at index: Int) -> Ingredient? {
        let ingredients = recipe.sortedIngredients
        return ingredients.indices.contains(index) ? ingredients[index] : nil
    }
    
    func direction(at index: Int) -> Direction? {
        let directions = recipe.sortedDirections
        return directions.indices.contains(index) ? directions[index] : nil
    }

}
