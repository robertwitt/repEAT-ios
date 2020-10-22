//
//  ObjectsViewController.swift
//  repEAT
//
//  Created by Witt, Robert on 22.10.20.
//

import UIKit
import CoreData

class ObjectsViewController<Object: NSManagedObject>: UITableViewController, NSFetchedResultsControllerDelegate, UISearchResultsUpdating, UISearchBarDelegate, ObjectViewControllerDelegate {
    
    var isSearchable = false
    weak var delegate: ObjectsViewControllerDelegate?
    
    var managedObjectContext: NSManagedObjectContext {
        // TODO Find better way to get pointer to managed object context
        // swiftlint:disable force_cast
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        // swiftlint:enable force_cast
    }
    
    var fetchedResultsController: NSFetchedResultsController<Object>!
    private(set) var fetchRequest: NSFetchRequest<Object>!
    var searchController: UISearchController?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupFetchedResultsController()
        
        if isSearchable {
            setupSearchController()
        }
    }
    
    func setupFetchedResultsController() {
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                              managedObjectContext: managedObjectContext,
                                                              sectionNameKeyPath: nil,
                                                              cacheName: nil)
        fetchedResultsController.delegate = self
        searchObjects()
    }
    
    func searchObjects(_ searchText: String? = nil) {
        fetchedResultsController.fetchRequest.predicate = predicate(with: searchText)
        do {
            try fetchedResultsController.performFetch()
            tableView.reloadData()
        } catch {
            // TODO Error handling
        }
    }
    
    func predicate(with searchText: String?) -> NSPredicate? {
        return nil
    }
    
    private func setupSearchController() {
        searchController = UISearchController(searchResultsController: nil)
        searchController?.searchResultsUpdater = self
        searchController?.searchBar.delegate = self
        searchController?.searchBar.autocapitalizationType = .none
        searchController?.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
    }

    // MARK: Table View Data Source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
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
        let object = fetchedResultsController.object(at: indexPath)
        managedObjectContext.delete(object)
        
        do {
            try managedObjectContext.save()
        } catch {
            // TODO Error handling
        }
    }

    // MARK: Table View Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let object = fetchedResultsController.object(at: indexPath)
        delegate?.objectsViewController(self, didSelect: object)
    }
    
    // MARK: Fetched Results Controller Delegate
    
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
    
    // MARK: Search Results Updating
        
    func updateSearchResults(for searchController: UISearchController) {
        var searchText: String?
        if let searchBarText = searchController.searchBar.text?.trimmingCharacters(in: CharacterSet.whitespaces), !searchBarText.isEmpty {
            searchText = "*\(searchBarText.replacingOccurrences(of: " ", with: "*"))*"
        }
        searchObjects(searchText)
    }

    // MARK: Search Bar Delegate

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }

}

// MARK: - Objects View Controller Delegate

protocol ObjectsViewControllerDelegate: class {
    func objectsViewController(_ viewController: UIViewController, didSelect object: NSManagedObject)
}

extension ObjectsViewControllerDelegate {
    func objectsViewController(_ viewController: UIViewController, didSelect object: NSManagedObject) {}
}
