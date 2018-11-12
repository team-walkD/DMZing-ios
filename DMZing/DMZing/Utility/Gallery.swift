//
//  Gallery.swift
//  DMZing
//
//  Created by 강수진 on 2018. 11. 12..
//  Copyright © 2018년 장용범. All rights reserved.
//

import UIKit

protocol Gallery : UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    var homeController : UIViewController? {get set}
    func openGallery()
    
}

extension Gallery {
    
        // imagePickerDelegate
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            //사용자 취소
            homeController?.dismiss(animated: true)
        }

    
        // Method
        func openGallery() {
            let available = UIImagePickerController.isSourceTypeAvailable(.photoLibrary)
            if (available) {
                let imagePicker = UIImagePickerController()
                imagePicker.sourceType = .photoLibrary
               imagePicker.delegate = self
                
               imagePicker.allowsEditing = true
    
                homeController?.present(imagePicker, animated: true, completion: nil)
            }
        }
}
