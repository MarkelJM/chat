//
//  ImagePickerManager.swift
//  VassQuick_iOS
//
//  Created by Markel Juaristi Mendarozketa   on 11/3/24.
//

import Foundation
import UIKit
import Combine

class ImagePickerManager: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var picker = UIImagePickerController()
    private var viewController: UIViewController?
    private let subject = PassthroughSubject<UIImage, Never>()
    
    func pickImage(_ viewController: UIViewController) -> AnyPublisher<UIImage, Never> {
        self.viewController = viewController
        
        let alertController = UIAlertController(title: "Seleccionar imagen", message: nil, preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "Cámara", style: .default) { [weak self] _ in
            self?.openCamera()
        }
        let galleryAction = UIAlertAction(title: "Galería", style: .default) { [weak self] _ in
            self?.openGallery()
        }
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel) { _ in }
        
        alertController.addAction(cameraAction)
        alertController.addAction(galleryAction)
        alertController.addAction(cancelAction)
        
        viewController.present(alertController, animated: true, completion: nil)
        
        return subject.eraseToAnyPublisher()
    }
    
    private func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
            picker.delegate = self
            viewController?.present(picker, animated: true, completion: nil)
        } else {
            presentAlert("Advertencia", "No tienes cámara")
        }
    }
    
    private func openGallery() {
        picker.sourceType = .photoLibrary
        picker.delegate = self
        viewController?.present(picker, animated: true, completion: nil)
    }
    
    private func presentAlert(_ title: String, _ message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        viewController?.present(alert, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true, completion: nil)
        if let image = info[.originalImage] as? UIImage {
            subject.send(image)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
