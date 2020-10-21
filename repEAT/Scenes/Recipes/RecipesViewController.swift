//
//  ViewController.swift
//  repEAT
//
//  Created by Witt, Robert on 03.10.20.
//

import UIKit
import CoreData

class RecipesViewController: UITableViewController {
    
    private var managedObjectContext: NSManagedObjectContext {
        // TODO Find better way to get pointer to managed object context
        // swiftlint:disable force_cast
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        // swiftlint:enable force_cast
    }
    
    private var fetchedResultsController: NSFetchedResultsController<Recipe>!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupFetchedResultsController()
    }
    
    private func setupFetchedResultsController() {
        let request = NSFetchRequest<Recipe>(entityName: "Recipe")
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request,
                                                              managedObjectContext: managedObjectContext,
                                                              sectionNameKeyPath: nil,
                                                              cacheName: nil)
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            // TODO Handle error
        }
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
            viewController.recipe = Recipe(context: managedObjectContext)
            viewController.isCreatingRecipe = true
            viewController.setEditing(true, animated: false)
        }
    }
    
    // MARK: Table View Data Source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let recipe = fetchedResultsController.object(at: indexPath)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeCell", for: indexPath)
        cell.textLabel?.text = recipe.name
        cell.imageView?.image = recipe.thumbnail
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            deleteRow(at: indexPath)
        default:
            break
        }
    }
    
    private func deleteRow(at indexPath: IndexPath) {
        let recipe = fetchedResultsController.object(at: indexPath)
        managedObjectContext.delete(recipe)
        
        do {
            try managedObjectContext.save()
        } catch {
            // TODO Error handling
        }
    }
    
    // MARK: Actions
    
    @IBAction func addItemPressed(_ sender: Any) {
        performSegue(withIdentifier: "RecipeSegue", sender: nil)
    }
    
}

// MARK: - Fetched Results Controller Delegate

extension RecipesViewController: NSFetchedResultsControllerDelegate {
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .automatic)
        case .update:
            tableView.reloadRows(at: [indexPath!], with: .automatic)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .automatic)
        case .move:
            tableView.moveRow(at: indexPath!, to: newIndexPath!)
            tableView.reloadRows(at: [newIndexPath!], with: .none)
        default:
            break
        }
    }

}

// MARK: - Recipe View Controller Delegate

extension RecipesViewController: RecipeViewControllerDelegate {
    
    func recipeViewControllerDidCancel(_ viewController: RecipeViewController) {
        if viewController.isCreatingRecipe {
            managedObjectContext.delete(viewController.recipe)
            navigationController?.popViewController(animated: true)
        } else {
            managedObjectContext.rollback()
        }
    }
    
    func recipeViewController(_ viewController: RecipeViewController, didEndEditingRecipe recipe: Recipe) {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // TODO Error handling
            }
        }
        if viewController.isCreatingRecipe {
            navigationController?.popViewController(animated: true)
        }
    }
    
}
