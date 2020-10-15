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
        setupView()
    }
    
    private func setupView() {
        updateLabels()
        setupTextField()
    }
    
    private func updateLabels() {
        foodLabel.text = ingredient.food?.name
        
        if let quantityUnitCode = ingredient.quantityUnit?.code {
            quantityLabel.text = String(format: NSLocalizedString("labelIngredientQuantityWithUnit", comment: ""), quantityUnitCode)
        } else {
            quantityLabel.text = NSLocalizedString("labelIngredientQuantity", comment: "")
        }
    }
    
    private func setupTextField() {
        quantityTextField.text = ingredient.formattedQuantity
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
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

// MARK: - Ingredient View Controller Delegate

protocol IngredientViewControllerDelegate: class {
    
}
