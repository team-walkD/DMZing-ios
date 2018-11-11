//
//  WriteArticleReviewVC.swift
//  DMZing
//
//  Created by 강수진 on 2018. 11. 9..
//  Copyright © 2018년 장용범. All rights reserved.
//

import UIKit

class WriteArticleReviewVC: UIViewController {
    
    @IBOutlet weak var dayLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var titleTxt: UITextField!
    @IBOutlet weak var contentTxtView: UITextView!
    @IBOutlet weak var contentCntLbl: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var doneBtn: UIButton!
    var keyboardDismissGesture : UITapGestureRecognizer?
    var imageData : [Data?] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    var selectedPhotoIdx = 0
    
    let imagePicker : UIImagePickerController = UIImagePickerController()
    override func viewDidLoad() {
        super.viewDidLoad()
        setKeyboardSetting()
        collectionView.delegate = self
        collectionView.dataSource = self
        imageData = [UIImageJPEGRepresentation(#imageLiteral(resourceName: "ccc"), 0.1),UIImageJPEGRepresentation(#imageLiteral(resourceName: "ccc"), 0.1),UIImageJPEGRepresentation(#imageLiteral(resourceName: "ccc"), 0.1),UIImageJPEGRepresentation(#imageLiteral(resourceName: "ccc"), 0.1),UIImageJPEGRepresentation(#imageLiteral(resourceName: "ccc"), 0.1)]
    }
}

extension WriteArticleReviewVC :  UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell: WriteArticleCVCell = collectionView.dequeueReusableCell(withReuseIdentifier: WriteArticleCVCell.reuseIdentifier, for: indexPath) as? WriteArticleCVCell {
            if let imageData_ = imageData[indexPath.row] {
                cell.configure(data: UIImage(data: imageData_)!)
            }
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedPhotoIdx = indexPath.row
        openGallery()
    }
  
}

//MARK: - 키보드 대응
extension WriteArticleReviewVC {
    func setKeyboardSetting() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        adjustKeyboardDismissGesture(isKeyboardVisible: true)
        
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        adjustKeyboardDismissGesture(isKeyboardVisible: false)
    }
    
    func adjustKeyboardDismissGesture(isKeyboardVisible: Bool) {
        if isKeyboardVisible {
            if keyboardDismissGesture == nil {
                keyboardDismissGesture = UITapGestureRecognizer(target: self, action: #selector(tapBackground))
                view.addGestureRecognizer(keyboardDismissGesture!)
            }
        } else {
            if keyboardDismissGesture != nil {
                view.removeGestureRecognizer(keyboardDismissGesture!)
                keyboardDismissGesture = nil
            }
        }
    }
    
    @objc func tapBackground() {
        self.view.endEditing(true)
    }
}

//MARK: - 앨범 열기 위함
extension WriteArticleReviewVC : UIImagePickerControllerDelegate,
UINavigationControllerDelegate  {
    
    // imagePickerDelegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        //사용자 취소
        self.dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        //크롭한 이미지
        if let editedImage: UIImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            imageData[selectedPhotoIdx] = UIImageJPEGRepresentation(editedImage, 0.1)
        } else if let originalImage: UIImage = info[UIImagePickerControllerOriginalImage] as? UIImage{
            imageData[selectedPhotoIdx] = UIImageJPEGRepresentation(originalImage, 0.1)
        }
        
        self.dismiss(animated: true)
    }
    
    // Method
    func openGallery() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            self.imagePicker.sourceType = .photoLibrary
            self.imagePicker.delegate = self
            //false 로 되어있으면 이미지 자르지 않고 오리지널로 들어감
            //이거 true로 하면 crop 가능
            self.imagePicker.allowsEditing = true
            
            self.present(self.imagePicker, animated: true, completion: nil)
        }
    }
    
}


