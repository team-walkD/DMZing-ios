//
//  WritePhotoReviewVC.swift
//  DMZing
//
//  Created by 강수진 on 2018. 11. 11..
//  Copyright © 2018년 장용범. All rights reserved.
//

import UIKit
import Photos

extension UIViewController  {
    // Gallery Method
    func checkPermission() {
        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        switch photoAuthorizationStatus {
        case .authorized:
            openGallery()
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({
                (newStatus) in
                if newStatus ==  PHAuthorizationStatus.authorized {
                    self.openGallery()
                }
            })
            print("It is not determined until now")
        case .restricted:
            showAlbumDisableAlert()
        case .denied:
            showAlbumDisableAlert()
        }
    }

    func openGallery() {
        let imagePicker : UIImagePickerController = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func showAlbumDisableAlert() {
        let alertController = UIAlertController(title: "앨범 접근이 제한되었습니다.", message: "앨범 접근 권한이 필요합니다.", preferredStyle: .alert)
        let openAction = UIAlertAction(title: "설정으로 가기", style: .default) { (action) in
            if let url = URL(string: UIApplicationOpenSettingsURLString) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
        
        alertController.addAction(openAction)
        self.present(alertController, animated: true, completion: nil)
    }
   @objc func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true)
    }
}

class WritePhotoReviewVC: UIViewController, APIService {
    let datePickerView = UIDatePicker()
    @IBOutlet weak var dateTxt: UITextField!
    @IBOutlet weak var titleLbl: UILabel!
    @IBAction func dismissAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func touchImgAction(_ sender: Any) {
        self.checkPermission()
    }
    @IBOutlet weak var myImgView: UIImageView!
    @IBOutlet weak var doneBtn: UIButton!
    var imgUrl : String?
    var selectedCourse : (courseId : Int, courseName : String) = (1, "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLbl.text = selectedCourse.courseName
        doneBtn.addTarget(self, action: #selector(doneAction), for: .touchUpInside)
        initDatePicker()
    }
    
    @objc func doneAction(){
        guard let dateString = dateTxt.text, let imageUrl_ = imgUrl else {return}
        let date = dateString.dateTxtToTimeStamp()
        let params : [String : Any] = [
            "imageUrl": imageUrl_,
            "startAt": date,
            "placeName": selectedCourse.courseName,
            "courseId": selectedCourse.courseId
        ]
        writeImgReview(url: url("reviews/photo"), params: params)
    }
}
//MARK: - 앨범 열기 위함
extension WritePhotoReviewVC : UIImagePickerControllerDelegate,
UINavigationControllerDelegate  {
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        //크롭한 이미지
        if let editedImage: UIImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            let image = UIImageJPEGRepresentation(editedImage, 1.0)
            addImage(url: url("reviews/images"), image: image)
        } else if let originalImage: UIImage = info[UIImagePickerControllerOriginalImage] as? UIImage{
            let image = UIImageJPEGRepresentation(originalImage, 1.0)
            addImage(url: url("reviews/images"), image: image)
            
        }
        self.dismiss(animated: true)
    }
    
}

extension WritePhotoReviewVC {
    func initDatePicker(){
        datePickerView.datePickerMode = .date
        let loc = Locale(identifier: "ko_KR")
        self.datePickerView.locale = loc
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy.MM.dd"
        let date = dateformatter.string(from: Date())
        dateTxt.text = date
        datePickerView.maximumDate = Date()
        
        setTextfieldView(textField: dateTxt, selector: #selector(selectedDatePicker(sender:)), inputView: datePickerView)
    }
    
    func setTextfieldView(textField:UITextField, selector : Selector, inputView : Any){
        let bar = UIToolbar()
        bar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "확인", style: .done
            , target: self, action: selector)
        let flexibleButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        bar.setItems([flexibleButton, doneButton], animated: true)
        textField.inputAccessoryView = bar
        textField.inputView = inputView as? UIControl
        textField.layer.borderColor = UIColor.white.cgColor
        textField.layer.borderWidth = 1.0
    }
    
    @objc func selectedDatePicker(sender : UIBarButtonItem){
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy.MM.dd"
        let date = dateformatter.string(from: datePickerView.date)
        dateTxt.text = date
        view.endEditing(true)
    }
}

//통신
extension WritePhotoReviewVC {
    func writeImgReview(url : String, params : [String : Any]){
        WritePhotoReviewService.shareInstance.writePhotoReview(url: url, params: params, completion: { [weak self] (result) in
            guard let `self` = self else { return }
            switch result {
            case .networkSuccess(_):
                self.simpleAlertwithHandler(title: "성공", message: "리뷰를 등록했습니다", isCancleBtnExist : false, okHandler: { (_) in
                    self.dismiss(animated: true, completion: nil)
                })
                break
            case .networkFail :
                self.networkSimpleAlert()
            default :
                self.simpleAlert(title: "오류", message: "다시 시도해주세요")
                break
            }
        })
    }
    
    func addImage(url : String, image : Data?){
        let params : [String : Any] = [:]
        var images : [String : Data]?
        
        if let image_ = image {
            images = [
                "data" : image_
            ]
        }
        
        PostImageService.shareInstance.addPhoto(url: url, params: params, image: images, completion: { [weak self] (result) in
            guard let `self` = self else { return }
            switch result {
            case .networkSuccess(let data):
                let data = data as? PostImageVO
                if let img = data?.image {
                    self.myImgView.setImgWithKF(url: img, defaultImg: #imageLiteral(resourceName: "photo_review_plus_img"))
                    self.imgUrl = img
                    self.doneBtn.isEnabled = true
                    self.doneBtn.backgroundColor = UIColor.FlatColor.Blue.middleBlue
                }
                break
            case .networkFail :
                self.networkSimpleAlert()
            default :
                self.simpleAlert(title: "오류", message: "다시 시도해주세요")
                break
            }
        })
    }
}
