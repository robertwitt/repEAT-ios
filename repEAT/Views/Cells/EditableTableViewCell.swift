//
//  EditableTableViewCell.swift
//  repEAT
//
//  Created by Witt, Robert on 06.10.20.
//

import UIKit

class EditableTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "EditableTableViewCell"
    
    var textChangedHandler: ((String?) -> Void)?
    
    @IBOutlet weak var textField: UITextField!
    
    static func register(in tableView: UITableView, reuseIdentifier: String = EditableTableViewCell.reuseIdentifier) {
        let nib = UINib(nibName: "EditableTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: reuseIdentifier)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        setupTextField()
    }
    
    private func setupTextField() {
        textField.delegate = self
        textField.isEnabled = isEditing
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        textField.isEnabled = editing
    }
    
}

extension EditableTableViewCell: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textChangedHandler?(textField.text)
    }
    
}
