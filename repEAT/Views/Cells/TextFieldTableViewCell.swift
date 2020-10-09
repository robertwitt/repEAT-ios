//
//  TextFieldTableViewCell.swift
//  repEAT
//
//  Created by Witt, Robert on 06.10.20.
//

import UIKit

class TextFieldTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "TextFieldTableViewCell"
    
    var textChangedHandler: ((String?) -> Void)?
    
    @IBOutlet weak var textField: UITextField!
    
    static func register(in tableView: UITableView, reuseIdentifier: String = TextFieldTableViewCell.reuseIdentifier) {
        let nib = UINib(nibName: "TextFieldTableViewCell", bundle: nil)
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

extension TextFieldTableViewCell: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textChangedHandler?(textField.text)
    }
    
}
