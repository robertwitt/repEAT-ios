//
//  UnitsOfMeasureViewController.swift
//  repEAT
//
//  Created by Witt, Robert on 16.10.20.
//

import UIKit
import CoreData

class UnitsOfMeasureViewController: ObjectsViewController<UnitOfMeasure> {
    
    override var fetchRequest: NSFetchRequest<UnitOfMeasure>! {
        let request = NSFetchRequest<UnitOfMeasure>(entityName: "UnitOfMeasure")
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        return request
    }

    // MARK: Table View Data Source

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let unit = fetchedResultsController.object(at: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: "UnitCell", for: indexPath)
        cell.textLabel?.text = unit.name
        return cell
    }

}
