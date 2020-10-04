//
//  RecipeViewControllerDataSource.swift
//  repEAT
//
//  Created by Witt, Robert on 04.10.20.
//

import UIKit

class RecipeController {
    
    let recipe: Recipe
    
    init(with recipe: Recipe) {
        self.recipe = recipe
    }
    
    var numberOfSections: Int {
        return Section.count
    }
    
    func headerTitle(of section: Int) -> String? {
        switch Section(rawValue: section) {
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
        case .ingredients:
            return recipe.ingredients?.count ?? 0
        case .directions:
            return recipe.directions?.count ?? 0
        default:
            return 0
        }
    }

}

private enum Section: Int {
    case ingredients = 0
    case directions = 1
    static let count = 2
}
