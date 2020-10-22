//
//  ChangeImageController.swift
//  repEAT
//
//  Created by Witt, Robert on 22.10.20.
//

import UIKit
import AVFoundation

class ChangeImageController: NSObject {
    
    weak var delegate: ChangeImageControllerDelegate?
    private var viewController: UIViewController?
    
    private var imagePickerController: UIImagePickerController {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        return imagePickerController
    }
    
    func present(onto viewController: UIViewController) {
        self.viewController = viewController
        showChangeImageOptions()
    }
    
    private func showChangeImageOptions() {
        let actionSheet = UIAlertController(title: NSLocalizedString("alertTitleChangeImage", comment: ""),
                                            message: nil,
                                            preferredStyle: .actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            actionSheet.addAction(UIAlertAction(title: NSLocalizedString("actionPhotoLibrary", comment: ""), style: .default, handler: { (_) in
                self.showPhotoLibrary()
            }))
        }
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            actionSheet.addAction(UIAlertAction(title: NSLocalizedString("actionCamera", comment: ""), style: .default, handler: { (_) in
                self.showCamera()
            }))
        }
        
        actionSheet.addAction(UIAlertAction(title: NSLocalizedString("actionDelete", comment: ""), style: .destructive, handler: { (_) in
            self.deleteImage()
        }))
        actionSheet.addAction(UIAlertAction(title: NSLocalizedString("actionCancel", comment: ""), style: .cancel))
        
        viewController?.present(actionSheet, animated: true)
    }
    
    private func showPhotoLibrary() {
        let imagePickerController = self.imagePickerController
        imagePickerController.sourceType = .photoLibrary
        viewController?.present(imagePickerController, animated: true)
    }
    
    private func showCamera() {
        switch AVCaptureDevice.authorizationStatus(for: AVMediaType.video) {
        case .denied:
            showCameraDisabledAlert()
        case .notDetermined:
            requestCameraAccess()
        default:
            showCameraIfAccessGranted()
        }
    }
    
    private func showCameraDisabledAlert() {
        let alert = UIAlertController(title: NSLocalizedString("alertTitleCameraUnavailable", comment: ""),
                                      message: NSLocalizedString("alertMessageCameraUnavailable", comment: ""),
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("actionOK", comment: ""), style: .cancel))
        alert.addAction(UIAlertAction(title: NSLocalizedString("actionSettings", comment: ""), style: .default, handler: { (_) in
            AppDelegate.singleton.openSettings()
        }))
        
        viewController?.present(alert, animated: true)
    }
    
    private func requestCameraAccess() {
        AVCaptureDevice.requestAccess(for: AVMediaType.video) { (granted) in
            if granted {
                DispatchQueue.main.async {
                    self.showCameraIfAccessGranted()
                }
            }
        }
    }
    
    private func showCameraIfAccessGranted() {
        let imagePickerController = self.imagePickerController
        imagePickerController.sourceType = .photoLibrary
        viewController?.present(imagePickerController, animated: true)
    }
    
    private func deleteImage() {
        delegate?.changeImageControllerDidDeleteImage(self)
    }
    
}

// MARK: - Image Picker Controller Delegate

extension ChangeImageController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true)
        guard let image = info[.editedImage] as? UIImage else {
            return
        }
        delegate?.changeImageController(self, didSelect: image)
    }
    
}

// MARK: - Change Image Controller Delegate

protocol ChangeImageControllerDelegate: class {
    func changeImageController(_ viewController: ChangeImageController, didSelect image: UIImage)
    func changeImageControllerDidDeleteImage(_ viewController: ChangeImageController)
}

extension ChangeImageControllerDelegate {
    func changeImageController(_ viewController: ChangeImageController, didSelect image: UIImage) {}
    func changeImageControllerDidDeleteImage(_ viewController: ChangeImageController) {}
}
