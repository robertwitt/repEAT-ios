//
//  ViewController.swift
//  repEAT
//
//  Created by Witt, Robert on 03.10.20.
//

import UIKit
import CoreData

class RecipesViewController: ObjectsViewController<Recipe> {
    
    private var createdRecipe: Recipe?
    
    override var fetchRequest: NSFetchRequest<Recipe>! {
        let request = NSFetchRequest<Recipe>(entityName: "Recipe")
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        return request
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "RecipeSegue":
            prepareRecipeViewController(for: segue, sender: sender)
        default:
            break
        }
    }
    
    private func prepareRecipeViewController(for segue: UIStoryboardSegue, sender: Any?) {
        guard let viewController = segue.destination as? RecipeViewController else {
            return
        }
        
        viewController.delegate = self
        if let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell) {
            viewController.recipe = fetchedResultsController.object(at: indexPath)
        } else {
            createdRecipe = Recipe(context: managedObjectContext)
            viewController.recipe = createdRecipe!
            viewController.setEditing(true, animated: false)
        }
    }
    
    // MARK: Table View Data Source
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let recipe = fetchedResultsController.object(at: indexPath)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeCell", for: indexPath)
        cell.textLabel?.text = recipe.name
        cell.imageView?.image = recipe.thumbnail
        
        return cell
    }
    
    // MARK: Table View Delegate
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // MARK: Actions
    
    @IBAction func addItemPressed(_ sender: Any) {
        performSegue(withIdentifier: "RecipeSegue", sender: nil)
    }
    
    // MARK: - Object View Controller Delegate
    
    override func objectViewControllerDidCancel(_ viewController: UIViewController) {
        if let createdRecipe = createdRecipe {
            managedObjectContext.delete(createdRecipe)
            navigationController?.popViewController(animated: true)
        } else {
            managedObjectContext.rollback()
        }
    }
    
    override func objectViewController(_ viewController: UIViewController, didEndEditing object: NSManagedObject) {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // TODO Error handling
            }
        }
    }
    
}
