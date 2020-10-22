//
//  FoodsViewController.swift
//  repEAT
//
//  Created by Witt, Robert on 15.10.20.
//

import UIKit
import CoreData

class FoodsViewController: ObjectsViewController<Food> {
    
    override var fetchRequest: NSFetchRequest<Food>! {
        let request = NSFetchRequest<Food>(entityName: "Food")
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        return request
    }
    
    override func predicate(with searchText: String?) -> NSPredicate? {
        guard let searchText = searchText else {
            return nil
        }
        let predicate = NSPredicate(format: "name LIKE[c] %@", searchText)
        return predicate
    }
    
    override var isSearchable: Bool {
        return true
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
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let food = fetchedResultsController.object(at: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: "FoodCell", for: indexPath)
        cell.textLabel?.text = food.name
        return cell
    }
    
    // MARK: - Object View Controller Delegate
    
    override func objectViewControllerDidCancel(_ viewController: UIViewController) {
        guard let food = (viewController as? FoodViewController)?.food else {
            return
        }
        managedObjectContext.delete(food)
        viewController.dismiss(animated: true)
    }
    
    override func objectViewController(_ viewController: UIViewController, didEndEditing object: NSManagedObject) {
        viewController.dismiss(animated: true)
    }
    
}
