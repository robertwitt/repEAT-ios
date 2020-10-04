//
//  Recipe.swift
//  repEAT
//
//  Created by Witt, Robert on 04.10.20.
//

import UIKit

extension Recipe {
    
    var image: UIImage? {
        guard let imageData = imageData else {
            return nil
        }
        return UIImage(data: imageData)
    }
    
}
