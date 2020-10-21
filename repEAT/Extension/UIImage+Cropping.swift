//
//  UIImage+Cropping.swift
//  repEAT
//
//  Created by Witt, Robert on 19.10.20.
//

import UIKit

extension UIImage {
    
    func imageCroppedTo(_ rect: CGRect) -> UIImage {
        let ratio = size.width / size.height
        let rectRatio = rect.size.width / rect.size.height
        let width = ratio > rectRatio ? size.height * rectRatio : size.width
        let height = ratio > rectRatio ? size.height : size.width / rectRatio
        
        let x = (size.width - width) / 2
        let y = (size.height - height) / 2
        
        guard let croppedImage = cgImage?.cropping(to: CGRect(x: x, y: y, width: width, height: height)) else {
            return self
        }
        return UIImage(cgImage: croppedImage)
    }
    
}
