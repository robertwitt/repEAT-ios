//
//  TextViewTableViewCell.swift
//  repEAT
//
//  Created by Witt, Robert on 07.10.20.
//

import UIKit

class TextViewTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "TextViewTableViewCell"
    
    static func register(in tableView: UITableView, reuseIdentifier: String = TextViewTableViewCell.reuseIdentifier) {
        let nib = UINib(nibName: "TextViewTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: reuseIdentifier)
    }
    
    var textChangedHandler: ((String?) -> Void)?
    
    @IBOutlet weak var textView: UITextView!

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        setupTextView()
    }
    
    private func setupTextView() {
        textView.delegate = self
        textView.isEditable = isEditing
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        textView.becomeFirstResponder()
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        textView.isEditable = editing
    }
    
}

extension TextViewTableViewCell: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        textChangedHandler?(textView.text)
    }
    
}
