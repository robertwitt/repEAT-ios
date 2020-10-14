//
//  RecipeViewController.swift
//  repEAT
//
//  Created by Witt, Robert on 04.10.20.
//

import UIKit
import CoreData

class RecipeViewController: UITableViewController {
    
    var recipe: Recipe {
        get {
            return recipeController.recipe
        }
        set {
            recipeController = RecipeController(with: newValue)
        }
    }
    
    private var recipeController: RecipeController!
    
    private var cancelButtonItem: UIBarButtonItem {
        return UIBarButtonItem(barButtonSystemItem: .cancel,
                               target: self,
                               action: #selector(cancelItemPressed))
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        setupTableViewHeader()
        registerTableViewCells()
    }
    
    private func setupNavBar() {
        navigationItem.rightBarButtonItem = editButtonItem
    }
    
    private func setupTableViewHeader() {
        guard let image = recipe.image else {
            return
        }
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 200))
        imageView.image = image
        tableView.tableHeaderView = imageView
    }
    
    private func registerTableViewCells() {
        EditableTableViewCell.register(in: tableView, reuseIdentifier: EditableTableViewCell.reuseIdentifier)
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        navigationItem.leftBarButtonItem = editing ? cancelButtonItem : nil
        recipeController.isEditing = editing
        tableView.reloadData()
        
        if !editing {
            recipeController.saveChanges()
        }
    }
    
    @objc private func cancelItemPressed() {
        recipeController.discardChanges()
        setEditing(false, animated: true)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "DirectionSegue":
            prepareDirectionViewController(for: segue, sender: sender)
        default:
            break
        }
    }
    
    private func prepareDirectionViewController(for segue: UIStoryboardSegue, sender: Any?) {
        guard let viewController = segue.destination as? DirectionViewController else {
            return
        }
        guard let indexPath = sender as? IndexPath else {
            return
        }
        
        let direction = recipeController.direction(at: indexPath.row) ?? recipe.createDirection()
        viewController.direction = direction
        viewController.maxSteps = recipe.directions?.count ?? 0 + 1
        viewController.delegate = self
    }

    // MARK: Table View Data Source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return recipeController.numberOfSections
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return recipeController.headerTitle(of: section)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipeController.numberOfObjects(in: section)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch RecipeController.Section(rawValue: indexPath.section) {
        case .details:
            return detailsCell(forRowAt: indexPath)
        case .ingredients:
            return ingredientCell(forRowAt: indexPath)
        case.directions:
            return directionCell(forRowAt: indexPath)
        default:
            return UITableViewCell()
        }
    }
    
    private func detailsCell(forRowAt indexPath: IndexPath) -> UITableViewCell {
        // swiftlint:disable force_cast
        let cell = tableView.dequeueReusableCell(withIdentifier: EditableTableViewCell.reuseIdentifier, for: indexPath) as! EditableTableViewCell
        // swiftlint:enable force_cast
        cell.textField.text = recipe.name
        cell.textField.placeholder = NSLocalizedString("placeholderRecipeName", comment: "")
        cell.textChangedHandler = { (recipeName) in
            self.recipe.name = recipeName
        }
        
        return cell
    }
    
    private func ingredientCell(forRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let ingredient = recipeController.ingredient(at: indexPath.row) else {
            return addCell(forRowAt: indexPath)
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientCell", for: indexPath)
        cell.textLabel?.text = ingredient.formattedQuantityWithUnit
        cell.detailTextLabel?.text = ingredient.food?.name
        cell.selectionStyle = isEditing ? .default : .none
        
        return cell
    }
    
    private func directionCell(forRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let direction = recipeController.direction(at: indexPath.row) else {
            return addCell(forRowAt: indexPath)
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DirectionCell", for: indexPath)
        cell.textLabel?.text = direction.depiction
        cell.selectionStyle = isEditing ? .default : .none
        
        return cell
    }
    
    private func addCell(forRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "AddCell", for: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .insert:
            insertRow(at: indexPath)
        case .delete:
            deleteRow(at: indexPath)
        default:
            break
        }
    }
    
    private func insertRow(at indexPath: IndexPath) {
        // Inserting rows behaves the same as selecting rows
        tableView(tableView, didSelectRowAt: indexPath)
    }
    
    private func deleteRow(at indexPath: IndexPath) {
        recipeController.deleteObject(at: indexPath)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return recipeController.canMoveObject(at: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        return recipeController.targetIndexPathForMoveFromObject(at: sourceIndexPath, to: proposedDestinationIndexPath)
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        recipeController.moveObject(at: sourceIndexPath, to: destinationIndexPath)
        tableView.moveRow(at: sourceIndexPath, to: destinationIndexPath)
    }
    
    // MARK: Table View Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch RecipeController.Section(rawValue: indexPath.section) {
        case .ingredients:
            // TODO https://github.com/robertwitt/repEAT-ios/issues/17
            break
        case .directions:
            performSegue(withIdentifier: "DirectionSegue", sender: indexPath)
        default:
            break
        }
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if recipeController.canDeleteObject(at: indexPath) {
            return .delete
        } else if recipeController.canInsertObject(at: indexPath) {
            return .insert
        } else {
            return .none
        }
    }
    
    override func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return indexPath.section != RecipeController.Section.details.rawValue
    }
    
}

// MARK: - Direction View Controller Delegate

extension RecipeViewController: DirectionViewControllerDelegate {
    
    func directionViewController(_ viewController: DirectionViewController, didEndEditing direction: Direction) {
        tableView.reloadData()
    }
    
    func directionViewController(_ viewController: DirectionViewController, directionToAddAfter direction: Direction) -> Direction {
        return recipe.createDirection()
    }
    
}
