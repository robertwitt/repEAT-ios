//
//  DirectionViewController.swift
//  repEAT
//
//  Created by Witt, Robert on 13.10.20.
//

import UIKit

class DirectionViewController: UITableViewController {
    
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
    
    @IBAction func stepperValueChanged(_ sender: Any) {
        updateStepLabel()
    }
    
}

extension DirectionViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        updateTableView()
    }
    
    private func updateTableView() {
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
}
