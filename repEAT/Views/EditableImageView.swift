//
//  EditableImageView.swift
//  repEAT
//
//  Created by Witt, Robert on 19.10.20.
//

import UIKit

class EditableImageView: UIView {
    
    var image: UIImage? {
        didSet {
            setNeedsLayout()
        }
    }
    
    var isEditing = false {
        didSet {
            setNeedsLayout()
        }
    }
    
    var changeImagePressedButtonHandler: (() -> Void)?
    
    private var imageView: UIImageView?
    private var changeImageButton: UIButton?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateImageView()
        updateChangeImageButton()
    }
    
    private func updateImageView() {
        setupImageViewIfNeeded()
        imageView?.frame = frame
        imageView?.image = image?.imageCroppedTo(frame)
    }
    
    private func setupImageViewIfNeeded() {
        guard imageView == nil else {
            return
        }
        let imageView = UIImageView(frame: frame)
        addSubview(imageView)
        self.imageView = imageView
    }
    
    private func updateChangeImageButton() {
        setupChangeImageButtonIfNeeded()
        if isEditing {
            addSubview(changeImageButton!)
            changeImageButton?.frame = frame
        } else {
            changeImageButton?.removeFromSuperview()
        }
    }
    
    private func setupChangeImageButtonIfNeeded() {
        guard changeImageButton == nil else {
            return
        }
        
        let buttonActionHandler: ((UIAction) -> Void) = { (_) in
            self.changeImagePressedButtonHandler?()
        }
        let buttonAction = UIAction(title: "",
                                    image: UIImage(systemName: "photo.fill"),
                                    identifier: nil,
                                    discoverabilityTitle: nil,
                                    attributes: [],
                                    state: .on,
                                    handler: buttonActionHandler)
        let button = UIButton(frame: frame, primaryAction: buttonAction)
        button.backgroundColor = .black
        button.alpha = 0.5
        
        changeImageButton = button
    }

}
