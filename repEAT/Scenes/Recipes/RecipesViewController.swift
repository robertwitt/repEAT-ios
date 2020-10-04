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
        guard let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell) else {
            return
        }
        
        let recipe = fetchedResultsController.object(at: indexPath)
        viewController.recipe = recipe
        viewController.managedObjectContext = managedObjectContext
    }
    
    // MARK: Table View Data Source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let recipe = fetchedResultsController.object(at: indexPath)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeCell", for: indexPath)
        cell.textLabel?.text = recipe.name
        cell.imageView?.image = recipe.image
        
        return cell
    }
    
    // MARK: Actions
    
    @IBAction func addItemPressed(_ sender: Any) {
    }
    
}
