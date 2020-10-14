//
//  DirectionViewController.swift
//  repEAT
//
//  Created by Witt, Robert on 13.10.20.
//

import UIKit

class DirectionViewController: UITableViewController {
    
    weak var delegate: DirectionViewControllerDelegate?
    var direction: Direction!
    var maxSteps = 1
    
    @IBOutlet weak var stepLabel: UILabel!
    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupStepper()
        updateStepLabel()
        setupTextView()
    }
    
    private func setupStepper() {
        stepper.maximumValue = Double(maxSteps)
        stepper.value = Double(direction.position)
    }
    
    private func updateStepLabel() {
        stepLabel.text = String(format: NSLocalizedString("labelDirectionStep", comment: ""), stepper.value)
    }
    
    private func setupTextView() {
        textView.text = direction.depiction
        textView.delegate = self
        textView.becomeFirstResponder()
    }
    
    override func willMove(toParent parent: UIViewController?) {
        super.willMove(toParent: parent)
        if parent == nil {
            updateDirection()
        }
    }
    
    private func updateDirection() {
        direction.setPosition(Direction.Position(stepper.value))
        direction.depiction = textView.text
        delegate?.directionViewController(self, didEndEditing: direction)
    }
    
    // MARK: Actions
    
    @IBAction func stepperValueChanged(_ sender: Any) {
        updateStepLabel()
    }
    
}

// MARK: - Text View Delegate

extension DirectionViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        updateTableView()
    }
    
    private func updateTableView() {
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
}

// MARK: - Direction View Controller Delegate

protocol DirectionViewControllerDelegate: class {
    
    func directionViewController(_ viewController: DirectionViewController, didEndEditing direction: Direction)
    
}

extension DirectionViewControllerDelegate {
    
    func directionViewController(_ viewController: DirectionViewController, didEndEditing direction: Direction) {}
    
}
