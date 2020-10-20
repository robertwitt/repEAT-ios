//
//  EditableImageView.swift
//  repEAT
//
//  Created by Witt, Robert on 19.10.20.
//

import UIKit

class EditableImageView: UIView {
    
    var image: UIImage?
    var isEditing = false
    var changeImagePressedHandler: (() -> Void)?
    
    private var imageView: UIImageView?
    
    override func layoutSubviews() {
        super.layoutSubviews()
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

}
