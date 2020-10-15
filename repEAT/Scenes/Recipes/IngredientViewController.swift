//
//  IngredientViewController.swift
//  repEAT
//
//  Created by Witt, Robert on 15.10.20.
//

import UIKit

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
        quantityLabel.textColor = quantityCellEnabled ? .black : .gray
        quantityTextField.isEnabled = quantityCellEnabled
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

}

// MARK: - Foods View Controller Delegate

extension IngredientViewController: FoodsViewControllerDelegate {
    
    func foodsViewController(_ viewController: FoodsViewController, didSelectFood food: Food) {
        ingredient.food = food
        ingredient.quantity = 0.0
        updateView()
    }
    
}

// MARK: - Ingredient View Controller Delegate

protocol IngredientViewControllerDelegate: class {
    
}
