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
    
    weak var delegate: RecipeViewControllerDelegate?
    
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
            saveRecipeChanges()
        }
    }
    
    private func saveRecipeChanges() {
        recipeController.saveChanges()
        delegate?.recipeViewController(self, didEditRecipe: recipe)
    }
    
    @objc private func cancelItemPressed() {
        recipeController.discardChanges()
        setEditing(false, animated: true)
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
        if editingStyle == .delete {
            recipeController.deleteObject(at: indexPath)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return recipeController.canMoveObject(at: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        recipeController.moveObject(at: sourceIndexPath, to: destinationIndexPath)
        tableView.moveRow(at: sourceIndexPath, to: destinationIndexPath)
    }
    
    // MARK: Table View Delegate
    
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
}

// MARK: - Recipe View Controller Delegate

protocol RecipeViewControllerDelegate: class {
    
    func recipeViewController(_ viewController: RecipeViewController, didEditRecipe recipe: Recipe)
    
}

extension RecipeViewController {
    
    func recipeViewController(_ viewController: RecipeViewController, didEditRecipe recipe: Recipe) {
    }
    
}
