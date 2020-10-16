//
//  FoodViewController.swift
//  repEAT
//
//  Created by Witt, Robert on 16.10.20.
//

import UIKit

class FoodViewController: UITableViewController {
    
    var food: Food!
    
    private enum Row: Int {
        case name = 0
        case unit = 1
        static let count = 2
    }
    
    private var cancelButtonItem: UIBarButtonItem {
        return UIBarButtonItem(barButtonSystemItem: .cancel,
                               target: self,
                               action: #selector(cancelItemPressed))
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        registerTableViewCells()
    }
    
    private func setupNavBar() {
        navigationItem.rightBarButtonItem = editButtonItem
    }
    
    private func registerTableViewCells() {
        EditableTableViewCell.register(in: tableView, reuseIdentifier: EditableTableViewCell.reuseIdentifier)
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        navigationItem.leftBarButtonItem = editing ? cancelButtonItem : nil
        
        if !editing {
            dismiss(animated: true)
        }
    }
    
    @objc private func cancelItemPressed() {
        food.managedObjectContext?.delete(food)
        setEditing(false, animated: true)
        dismiss(animated: true)
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
            return UITableViewCell()
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
    
    // MARK: Table View Delegate
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
    override func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }

}
