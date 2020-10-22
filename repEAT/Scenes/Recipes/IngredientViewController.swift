//
//  IngredientViewController.swift
//  repEAT
//
//  Created by Witt, Robert on 15.10.20.
//

import UIKit
import CoreData

class IngredientViewController: UITableViewController {
    
    enum Row: Int {
        case food = 0
        case quantity = 1
    }
    
    weak var delegate: IngredientViewControllerDelegate?
    var ingredient: Ingredient!
    
    @IBOutlet weak var foodLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var quantityTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        updateView()
    }
    
    private func updateView() {
        updateFoodCell()
        updateQuantityCell()
    }
    
    private func updateFoodCell() {
        foodLabel.text = ingredient.food?.name
    }
    
    private func updateQuantityCell() {
        if let quantityUnitCode = ingredient.quantityUnit?.code {
            quantityLabel.text = String(format: NSLocalizedString("labelIngredientQuantityWithUnit", comment: ""), quantityUnitCode)
        } else {
            quantityLabel.text = NSLocalizedString("labelIngredientQuantity", comment: "")
        }
        quantityTextField.text = ingredient.formattedQuantity
        
        let quantityCellEnabled = ingredient.quantityUnit != nil
        quantityTextField.isEnabled = quantityCellEnabled
    }
    
    override func willMove(toParent parent: UIViewController?) {
        super.willMove(toParent: parent)
        if parent == nil {
            updateIngredient()
        }
    }
    
    private func updateIngredient() {
        ingredient.quantity = parseQuantity(from: quantityTextField.text)
        delegate?.ingredientViewController(self, didEndEditing: ingredient)
    }
    
    private func parseQuantity(from string: String?) -> Ingredient.Quantity {
        guard let string = string else {
            return 0.0
        }
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        let quantity = formatter.number(from: string)
        
        return quantity?.floatValue ?? 0.0
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "FoodsSegue":
            prepareFoodsViewController(for: segue, sender: sender)
        default:
            break
        }
    }
    
    private func prepareFoodsViewController(for segue: UIStoryboardSegue, sender: Any?) {
        let viewController = segue.destination as? FoodsViewController
        viewController?.delegate = self
    }
    
    // MARK: Table View Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch Row(rawValue: indexPath.row) {
        case .quantity:
            quantityTextField.becomeFirstResponder()
        default:
            break
        }
    }
    
    // MARK: Actions
    
    @IBAction func addItemPressed(_ sender: Any) {
        guard let delegate = delegate else {
            return
        }
        
        updateIngredient()
        ingredient = delegate.ingredientViewControllerNewIngredient(self)
        updateView()
    }

}

// MARK: - Foods View Controller Delegate

extension IngredientViewController: ObjectsViewControllerDelegate {
    
    func objectsViewController(_ viewController: UIViewController, didSelect object: NSManagedObject) {
        ingredient.food = object as? Food
        ingredient.quantity = 0.0
        updateView()
        navigationController?.popViewController(animated: true)
    }
    
}

// MARK: - Ingredient View Controller Delegate

protocol IngredientViewControllerDelegate: class {
    func ingredientViewController(_ viewController: IngredientViewController, didEndEditing ingredient: Ingredient)
    func ingredientViewControllerNewIngredient(_ viewController: IngredientViewController) -> Ingredient
}

extension IngredientViewControllerDelegate {
    func ingredientViewController(_ viewController: IngredientViewController, didEndEditing ingredient: Ingredient) {}
}
