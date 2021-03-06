//
//  RecipeViewControllerDataSource.swift
//  repEAT
//
//  Created by Witt, Robert on 04.10.20.
//

import CoreData

class RecipeController {
    
    enum Section: Int {
        case details = 0
        case ingredients = 1
        case directions = 2
        static let count = 3
    }
    
    let recipe: Recipe
    var isEditing = false
    
    private var managedObjectContext: NSManagedObjectContext {
        return recipe.managedObjectContext!
    }
    
    init(with recipe: Recipe) {
        self.recipe = recipe
    }
    
    var numberOfSections: Int {
        return Section.count
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
    
    func numberOfObjects(in section: Int) -> Int {
        return isEditing ? numberOfObjectsInEditMode(in: section) : numberOfObjectsInDisplayMode(in: section)
    }
    
    private func numberOfObjectsInEditMode(in section: Int) -> Int {
        switch Section(rawValue: section) {
        case .details:
            return 1
        case .ingredients:
            return (recipe.ingredients?.count ?? 0) + 1
        case .directions:
            return (recipe.directions?.count ?? 0) + 1
        default:
            return 0
        }
    }
    
    private func numberOfObjectsInDisplayMode(in section: Int) -> Int {
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
    
    func canInsertObject(at indexPath: IndexPath) -> Bool {
        switch Section(rawValue: indexPath.section) {
        case .details:
            return false
        case .ingredients:
            return ingredient(at: indexPath.row) == nil
        case .directions:
            return direction(at: indexPath.row) == nil
        default:
            return true
        }
    }
    
    func canDeleteObject(at indexPath: IndexPath) -> Bool {
        switch Section(rawValue: indexPath.section) {
        case .details:
            return false
        case .ingredients:
            return ingredient(at: indexPath.row) != nil
        case .directions:
            return direction(at: indexPath.row) != nil
        default:
            return true
        }
    }
    
    func deleteObject(at indexPath: IndexPath) {
        switch Section(rawValue: indexPath.section) {
        case .ingredients:
            deleteIngredient(at: indexPath.row)
        case .directions:
            deleteDirection(at: indexPath.row)
        default:
            break
        }
    }
    
    private func deleteIngredient(at index: Int) {
        if let ingredient = self.ingredient(at: index) {
            recipe.deleteIngredient(ingredient)
        }
    }
    
    private func deleteDirection(at index: Int) {
        if let direction = self.direction(at: index) {
            recipe.deleteDirection(direction)
        }
    }
    
    func canMoveObject(at indexPath: IndexPath) -> Bool {
        switch Section(rawValue: indexPath.section) {
        case .directions:
            return direction(at: indexPath.row) != nil
        default:
            return false
        }
    }
    
    func targetIndexPathForMoveFromObject(at sourceIndexPath: IndexPath, to proposedIndexPath: IndexPath) -> IndexPath {
        // Only directions can be moved. No check on the section here.
        // Move only within a section possible.
        let lastRow = (recipe.directions?.count ?? 1) - 1
        if sourceIndexPath.section == proposedIndexPath.section && proposedIndexPath.row <= lastRow {
            return proposedIndexPath
        }
        let targetRow = sourceIndexPath.section > proposedIndexPath.section ? 0 : lastRow
        return IndexPath(row: targetRow, section: sourceIndexPath.section)
    }
    
    func moveObject(at sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        // Only directions can be moved. No check on the section here.
        let direction = self.direction(at: sourceIndexPath.row)
        let newPosition = Direction.Position(destinationIndexPath.row + 1)
        direction?.setPosition(newPosition)
    }

}
