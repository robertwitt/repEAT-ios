//
//  RecipeViewController.swift
//  repEAT
//
//  Created by Witt, Robert on 04.10.20.
//

import UIKit

class RecipeViewController: ObjectViewController<Recipe> {
    
    var recipe: Recipe {
        get {
            return object
        }
        set {
            object = newValue
            recipeController = RecipeController(with: newValue)
        }
    }
    
    private var recipeController: RecipeController!
    private var recipeImageView: EditableImageView!
    private var changeImageController: ChangeImageController?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupRecipeImageView()
        updateTableHeaderView()
    }
    
    private func setupRecipeImageView() {
        recipeImageView = EditableImageView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 200))
        recipeImageView.changeImagePressedButtonHandler = { () -> Void in
            self.showChangeImageController()
        }
    }
    
    private func showChangeImageController() {
        if changeImageController == nil {
            changeImageController = ChangeImageController()
            changeImageController?.delegate = self
        }
        changeImageController?.present(onto: self)
    }
    
    private func updateTableHeaderView() {
        recipeImageView.image = recipe.image
        recipeImageView.isEditing = isEditing
        tableView.tableHeaderView = isEditing || recipe.image != nil ? recipeImageView : nil
    }
    
    override func registerCustomCells() {
        EditableTableViewCell.register(in: tableView, reuseIdentifier: EditableTableViewCell.reuseIdentifier)
    }
    
    override func didBeginEditing() {
        super.didBeginEditing()
        updateView()
    }
    
    override func didEndEditing() {
        super.didEndEditing()
        updateView()
    }
    
    private func updateView() {
        recipeController.isEditing = isEditing
        updateTableHeaderView()
        tableView.reloadData()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "IngredientSegue":
            prepareIngredientViewController(for: segue, sender: sender)
        case "DirectionSegue":
            prepareDirectionViewController(for: segue, sender: sender)
        default:
            break
        }
    }
    
    private func prepareIngredientViewController(for segue: UIStoryboardSegue, sender: Any?) {
        guard let viewController = segue.destination as? IngredientViewController else {
            return
        }
        guard let indexPath = sender as? IndexPath else {
            return
        }
        
        let ingredient = recipeController.ingredient(at: indexPath.row) ?? recipe.createIngredient()
        viewController.ingredient = ingredient
        viewController.delegate = self
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
        guard isEditing else {
            return
        }
        
        switch RecipeController.Section(rawValue: indexPath.section) {
        case .ingredients:
            performSegue(withIdentifier: "IngredientSegue", sender: indexPath)
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

// MARK: - Change Image Controller Delegate

extension RecipeViewController: ChangeImageControllerDelegate {
    
    func changeImageControllerDidDeleteImage(_ viewController: ChangeImageController) {
        setRecipeImage(nil)
    }
    
    func changeImageController(_ viewController: ChangeImageController, didSelect image: UIImage) {
        setRecipeImage(image)
    }
    
    private func setRecipeImage(_ image: UIImage?) {
        recipe.image = image
        updateTableHeaderView()
    }
    
}

// MARK: - Ingredient View Controller Delegate

extension RecipeViewController: IngredientViewControllerDelegate {
    
    func ingredientViewController(_ viewController: IngredientViewController, didEndEditing ingredient: Ingredient) {
        let indexSet = IndexSet(integer: RecipeController.Section.ingredients.rawValue)
        tableView.reloadSections(indexSet, with: .none)
    }
    
    func ingredientViewControllerNewIngredient(_ viewController: IngredientViewController) -> Ingredient {
        return recipe.createIngredient()
    }
    
}

// MARK: - Direction View Controller Delegate

extension RecipeViewController: DirectionViewControllerDelegate {
    
    func directionViewController(_ viewController: DirectionViewController, didEndEditing direction: Direction) {
        let indexSet = IndexSet(integer: RecipeController.Section.directions.rawValue)
        tableView.reloadSections(indexSet, with: .none)
    }
    
    func directionViewController(_ viewController: DirectionViewController, directionToAddAfter direction: Direction) -> Direction {
        return recipe.createDirection()
    }
    
}
