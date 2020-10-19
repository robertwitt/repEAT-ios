//
//  UIImage+Cropping.swift
//  repEAT
//
//  Created by Witt, Robert on 19.10.20.
//

import UIKit

extension UIImage {
    
    func imageCroppedTo(_ rect: CGRect) -> UIImage {
        let isPortraitImage = size.width < size.height

        let width = isPortraitImage ? size.width : size.height * rect.size.width / rect.size.height
        let height = isPortraitImage ? size.width * rect.size.height / rect.size.width : size.height
        let x = size.width > width ? (size.width - width) / 2 : 0.0
        let y = size.height > height ? (size.height - height) / 2 : 0.0
        
        guard let croppedImage = cgImage?.cropping(to: CGRect(x: x, y: y, width: width, height: height)) else {
            return self
        }
        return UIImage(cgImage: croppedImage)
    }
    
}
