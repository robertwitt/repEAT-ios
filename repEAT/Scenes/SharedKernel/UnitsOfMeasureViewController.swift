//
//  UnitsOfMeasureViewController.swift
//  repEAT
//
//  Created by Witt, Robert on 16.10.20.
//

import UIKit
import CoreData

class UnitsOfMeasureViewController: UITableViewController {
    
    weak var delegate: UnitsOfMeasureViewControllerDelegate?
    
    private var managedObjectContext: NSManagedObjectContext {
        // TODO Find better way to get pointer to managed object context
        // swiftlint:disable force_cast
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        // swiftlint:enable force_cast
    }
    
    private var fetchedResultsController: NSFetchedResultsController<UnitOfMeasure>!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupFetchedResultsController()
    }
    
    private func setupFetchedResultsController() {
        let request = NSFetchRequest<UnitOfMeasure>(entityName: "UnitOfMeasure")
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request,
                                                              managedObjectContext: managedObjectContext,
                                                              sectionNameKeyPath: nil,
                                                              cacheName: nil)
        do {
            try fetchedResultsController.performFetch()
        } catch {
            // TODO Error handling
        }
    }

    // MARK: Table View Data Source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let unit = fetchedResultsController.object(at: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: "UnitCell", for: indexPath)
        cell.textLabel?.text = unit.name
        return cell
    }

    // MARK: Table View Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let unit = fetchedResultsController.object(at: indexPath)
        delegate?.unitsOfMeasureViewController(self, didSelectUnit: unit)
    }

}

// MARK: - Units of Measure View Controller Delegate

protocol UnitsOfMeasureViewControllerDelegate: class {
    
    func unitsOfMeasureViewController(_ viewController: UnitsOfMeasureViewController, didSelectUnit unit: UnitOfMeasure)
    
}

extension UnitsOfMeasureViewControllerDelegate {
    
    func unitsOfMeasureViewController(_ viewController: UnitsOfMeasureViewController, didSelectUnit unit: UnitOfMeasure) {}
    
}
