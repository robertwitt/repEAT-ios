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
    }
    
    func didBeginEditing() {}
    
    func didEndEditing() {
        updateObject()
        updateNavBar()
    }
    
    private func updateObject() {
        if isCancellationRequested {
            cancelEdit()
        } else {
            commitEdit()
        }
    }
    
    func cancelEdit() {
        // swiftlint:disable force_cast
        delegate?.objectViewControllerDidCancel(self as! ObjectViewController<NSManagedObject>)
        // swiftlint:enable force_cast
        isCancellationRequested = false
    }
    
    func commitEdit() {
        // swiftlint:disable force_cast
        delegate?.objectViewController(self as! ObjectViewController<NSManagedObject>, didEndEditing: object)
        // swiftlint:enable force_cast
    }

}

protocol ObjectViewControllerDelegate: class {
    func objectViewControllerDidCancel(_ viewController: ObjectViewController<NSManagedObject>)
    func objectViewController(_ viewController: ObjectViewController<NSManagedObject>, didEndEditing object: NSManagedObject)
}

extension ObjectViewControllerDelegate {
    func objectViewControllerDidCancel(_ viewController: ObjectViewController<NSManagedObject>) {}
    func objectViewController(_ viewController: ObjectViewController<NSManagedObject>, didEndEditing object: NSManagedObject) {}
}
