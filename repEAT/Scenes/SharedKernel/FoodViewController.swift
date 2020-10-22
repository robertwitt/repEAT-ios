//
//  FoodViewController.swift
//  repEAT
//
//  Created by Witt, Robert on 16.10.20.
//

import UIKit

class FoodViewController: ObjectViewController {
    
    var food: Food! {
        get {
            // swiftlint:disable force_cast
            return (object as! Food)
            // swiftlint:enable force_cast
        }
        set {
            object = newValue
        }
    }
    
    private enum Row: Int {
        case name = 0
        case unit = 1
        static let count = 2
    }
    
    override func registerCustomCells() {
        EditableTableViewCell.register(in: tableView, reuseIdentifier: EditableTableViewCell.reuseIdentifier)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "UnitSegue":
            prepareUnitOfMeasureViewController(for: segue, sender: sender)
        default:
            break
        }
    }
    
    private func prepareUnitOfMeasureViewController(for segue: UIStoryboardSegue, sender: Any?) {
        guard let viewController = segue.destination as? UnitsOfMeasureViewController else {
            return
        }
        viewController.delegate = self
    }

    // MARK: Table View Data Source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Row.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch Row(rawValue: indexPath.row) {
        case .name:
            return nameCell(forRowAt: indexPath)
        default:
            return unitCell(forRowAt: indexPath)
        }
    }
    
    private func nameCell(forRowAt indexPath: IndexPath) -> UITableViewCell {
        // swiftlint:disable force_cast
        let cell = tableView.dequeueReusableCell(withIdentifier: EditableTableViewCell.reuseIdentifier, for: indexPath) as! EditableTableViewCell
        // swiftlint:enable force_cast
        cell.textField.text = food.name
        cell.textField.placeholder = NSLocalizedString("placeHolderFoodName", comment: "")
        cell.textChangedHandler = { (foodName) in
            self.food.name = foodName
        }
        
        return cell
    }
    
    private func unitCell(forRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UnitCell", for: indexPath)
        cell.textLabel?.text = NSLocalizedString("labelUnit", comment: "")
        cell.detailTextLabel?.text = food.baseUnit?.name
        return cell
    }
    
    // MARK: Table View Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch Row(rawValue: indexPath.row) {
        case .unit:
            performSegue(withIdentifier: "UnitSegue", sender: nil)
        default:
            break
        }
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
    override func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }

}

// MARK: - Unit of Measure View Controller Delegate

extension FoodViewController: UnitsOfMeasureViewControllerDelegate {
    
    func unitsOfMeasureViewController(_ viewController: UnitsOfMeasureViewController, didSelectUnit unit: UnitOfMeasure) {
        food.baseUnit = unit
        let indexPath = IndexPath(row: Row.unit.rawValue, section: 0)
        tableView.reloadRows(at: [indexPath], with: .none)
        navigationController?.popViewController(animated: true)
    }
    
}
