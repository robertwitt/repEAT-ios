//
//  FoodsViewController.swift
//  repEAT
//
//  Created by Witt, Robert on 15.10.20.
//

import UIKit
import CoreData

class FoodsViewController: UITableViewController {
    
    weak var delegate: FoodsViewControllerDelegate?
    
    private var managedObjectContext: NSManagedObjectContext {
        // TODO Find better way to get pointer to managed object context
        // swiftlint:disable force_cast
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        // swiftlint:enable force_cast
    }
    
    private var fetchedResultsController: NSFetchedResultsController<Food>!
    private var searchController: UISearchController!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupFetchedResultsController()
        setupSearchController()
    }
    
    private func setupFetchedResultsController() {
        let request = NSFetchRequest<Food>(entityName: "Food")
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request,
                                                              managedObjectContext: managedObjectContext,
                                                              sectionNameKeyPath: nil,
                                                              cacheName: nil)
        fetchedResultsController.delegate = self
        searchFoods()
    }
    
    private func searchFoods(_ searchText: String? = nil) {
        var predicate: NSPredicate?
        if let searchText = searchText {
            predicate = NSPredicate(format: "name LIKE[c] %@", searchText)
        }
        fetchedResultsController.fetchRequest.predicate = predicate
        
        do {
            try fetchedResultsController.performFetch()
            tableView.reloadData()
        } catch {
            // TODO Error handling
        }
    }
    
    private func setupSearchController() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.searchBar.autocapitalizationType = .none
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "FoodSegue":
            prepareFoodViewController(for: segue, sender: sender)
        default:
            break
        }
    }
    
    private func prepareFoodViewController(for segue: UIStoryboardSegue, sender: Any?) {
        guard let viewController = (segue.destination as? UINavigationController)?.topViewController as? FoodViewController else {
            return
        }
        
        viewController.delegate = self
        viewController.food = Food(context: managedObjectContext)
        viewController.setEditing(true, animated: false)
    }

    // MARK: Table View Data Source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let food = fetchedResultsController.object(at: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: "FoodCell", for: indexPath)
        cell.textLabel?.text = food.name
        return cell
    }

    // MARK: Table View Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let food = fetchedResultsController.object(at: indexPath)
        delegate?.foodsViewController(self, didSelectFood: food)
    }

}

// MARK: - Fetched Results Controller Delegate

extension FoodsViewController: NSFetchedResultsControllerDelegate {
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .none)
        case .update:
            tableView.reloadRows(at: [indexPath!], with: .none)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .none)
        case .move:
            tableView.moveRow(at: indexPath!, to: newIndexPath!)
            tableView.reloadRows(at: [newIndexPath!], with: .none)
        default:
            break
        }
    }
    
}

// MARK: - Search Results Updating

extension FoodsViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        var searchText: String?
        if let searchBarText = searchController.searchBar.text?.trimmingCharacters(in: CharacterSet.whitespaces), !searchBarText.isEmpty {
            searchText = "*\(searchBarText.replacingOccurrences(of: " ", with: "*"))*"
        }
        searchFoods(searchText)
    }
    
}

// MARK: - Search Bar Delegate

extension FoodsViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
}

// MARK: - Object View Controller Delegate

extension FoodsViewController: ObjectViewControllerDelegate {
    
    func objectViewControllerDidCancel(_ viewController: UIViewController) {
        guard let food = (viewController as? FoodViewController)?.food else {
            return
        }
        managedObjectContext.delete(food)
        viewController.dismiss(animated: true)
    }
    
    func objectViewController(_ viewController: UIViewController, didEndEditing object: NSManagedObject) {
        viewController.dismiss(animated: true)
    }
    
}

// MARK: - Foods View Controller Delegate

protocol FoodsViewControllerDelegate: class {
    func foodsViewController(_ viewController: FoodsViewController, didSelectFood food: Food)
}

extension FoodsViewControllerDelegate {
    func foodsViewController(_ viewController: FoodsViewController, didSelectFood food: Food) {}
}
