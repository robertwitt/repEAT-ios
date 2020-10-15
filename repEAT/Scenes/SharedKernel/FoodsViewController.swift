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

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension FoodsViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        var searchText: String?
        if let searchBarText = searchController.searchBar.text?.trimmingCharacters(in: CharacterSet.whitespaces), !searchBarText.isEmpty {
            searchText = "*\(searchBarText.replacingOccurrences(of: " ", with: "*"))*"
        }
        searchFoods(searchText)
    }
    
}

extension FoodsViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
}

// MARK: - Foods View Controller Delegate

protocol FoodsViewControllerDelegate: class {
    
}
