//
//  ErrorAlertController.swift
//  repEAT
//
//  Created by Witt, Robert on 23.10.20.
//

import UIKit

class ErrorAlertController: UIAlertController {

    convenience init(_ error: Error) {
        self.init(title: NSLocalizedString("alertTitleError", comment: ""),
                  message: error.localizedDescription,
                  preferredStyle: .alert)
        addAction(UIAlertAction(title: "actionOK", style: .cancel))
    }

}
