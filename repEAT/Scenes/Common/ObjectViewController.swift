//
//  ObjectViewController.swift
//  repEAT
//
//  Created by Witt, Robert on 22.10.20.
//

import UIKit
import CoreData

class ObjectViewController<Object: NSManagedObject>: UITableViewController {
    
    var object: Object!
    var shouldShowEditButtons = true
    weak var delegate: ObjectViewControllerDelegate?
    
    var cancelButtonItem: UIBarButtonItem {
        return UIBarButtonItem(barButtonSystemItem: .cancel,
                               target: self,
                               action: #selector(cancelItemPressed))
    }
    
    @objc private func cancelItemPressed() {
        isCancellationRequested = true
        setEditing(false, animated: true)
    }
    
    private var isCancellationRequested = false

    override func viewDidLoad() {
        super.viewDidLoad()
        updateNavBar()
        registerCustomCells()
    }
    
    private func updateNavBar() {
        if shouldShowEditButtons {
            navigationItem.rightBarButtonItem = editButtonItem
            navigationItem.leftBarButtonItem = isEditing ? cancelButtonItem : nil
        }
    }
    
    func registerCustomCells() {}
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        editing ? didBeginEditing() : didEndEditing()
        updateNavBar()
    }
    
    func didBeginEditing() {}
    
    func didEndEditing() {
        updateObject()
    }
    
    private func updateObject() {
        if isCancellationRequested {
            cancelEdit()
        } else {
            commitEdit()
        }
    }
    
    func cancelEdit() {
        delegate?.objectViewControllerDidCancel(self)
        isCancellationRequested = false
    }
    
    func commitEdit() {
        delegate?.objectViewController(self, didEndEditing: object)
    }

}

protocol ObjectViewControllerDelegate: class {
    func objectViewControllerDidCancel(_ viewController: UIViewController)
    func objectViewController(_ viewController: UIViewController, didEndEditing object: NSManagedObject)
}

extension ObjectViewControllerDelegate {
    func objectViewControllerDidCancel(_ viewController: UIViewController) {}
    func objectViewController(_ viewController: UIViewController, didEndEditing object: NSManagedObject) {}
}
