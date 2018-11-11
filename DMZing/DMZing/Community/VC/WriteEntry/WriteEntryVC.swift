//
//  WriteEntryVC.swift
//  DMZing
//
//  Created by 강수진 on 2018. 11. 8..
//  Copyright © 2018년 장용범. All rights reserved.
//

import UIKit

class WriteEntryVC: UIViewController {
    
    let datePickerView = UIDatePicker()
    let imagePicker : UIImagePickerController = UIImagePickerController()
    var keyboardDismissGesture: UITapGestureRecognizer?
    var rowCount = 0 {
        didSet {
            tableView.isHidden = !(rowCount > 0)
            tableView.reloadData()
        }
    }
    var imageData : Data? {
        didSet {
            if imageData != nil {
                if let imageData_ = imageData {
                    bgImgView.image =  UIImage(data: imageData_)
                }
            }
        }
    }
    
   
    @IBAction func dismissAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var bgImgView: UIImageView!
    @IBOutlet weak var titleTxt: UITextField!
    @IBOutlet weak var startTxt: UITextField!
    @IBOutlet weak var endTxt: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var doneBtn: UIButton!
    @IBOutlet weak var startDateView: UIView!
    @IBOutlet weak var endDateView: UIView!
    
    @IBOutlet weak var tableViewBgView: UIView!
    @IBAction func selectThumbnailAction(_ sender: Any) {
        openGallery()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initDatePicker()
        setKeyboardSetting()
        setUpTableView()
        titleTxt.attributedPlaceholder = NSAttributedString(string: "제목을 입력해주세요", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
    }
    
    func setUpTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView(frame : .zero)
        tableView.isHidden = true
    }
    
    
}


extension WriteEntryVC : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rowCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: WriteEntryTVCell.reuseIdentifier) as! WriteEntryTVCell
        cell.configure(data: (indexPath.row+1).description)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

//DatePicker
extension WriteEntryVC {
    func initDatePicker(){
        datePickerView.datePickerMode = .date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        datePickerView.date = Date()
        datePickerView.maximumDate = Date()
        
        setTextfieldView(textField: startTxt, selector: #selector(selectedDatePicker(sender:)), inputView: datePickerView)
        setTextfieldView(textField: endTxt, selector: #selector(selectedDatePicker(sender:)), inputView: datePickerView)
    }
    
    func setTextfieldView(textField:UITextField, selector : Selector, inputView : Any){
        let bar = UIToolbar()
        bar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "확인", style: .done
            , target: self, action: selector)
        doneButton.tag = (textField == startTxt) ? 0 : 1
        bar.setItems([doneButton], animated: true)
        textField.inputAccessoryView = bar
        textField.inputView = inputView as? UIControl
        textField.layer.borderColor = UIColor.white.cgColor
        textField.layer.borderWidth = 1.0
    }
    
    @objc func selectedDatePicker(sender : UIBarButtonItem){
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy.MM.dd"
        let date = dateformatter.string(from: datePickerView.date)
        if sender.tag ==  0 {
           startTxt.text = date
        }else {
            endTxt.text = date
        }
        isDateValid()
        view.endEditing(true)
    }
    
    func isDateValid(){
        if startTxt.text == "START DATE" || endTxt.text == "END DATE" {
            return
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        guard let startDate = dateFormatter.date(from: startTxt.text!), let endDate =  dateFormatter.date(from: endTxt.text!) else {
            fatalError("포맷과 맞지 않아 데이터 변환이 실패했습니다")
        }
        let interval = endDate.timeIntervalSince(startDate)
        let days = Int(interval / 86400)
        rowCount = days >= 0 ? days+1 : 0
    }
}

//MARK: - 앨범 열기 위함
extension WriteEntryVC : UIImagePickerControllerDelegate,
UINavigationControllerDelegate  {
    
    // imagePickerDelegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        //사용자 취소
        self.dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        //크롭한 이미지
        if let editedImage: UIImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            imageData = UIImageJPEGRepresentation(editedImage, 0.1)
        } else if let originalImage: UIImage = info[UIImagePickerControllerOriginalImage] as? UIImage{
            imageData = UIImageJPEGRepresentation(originalImage, 0.1)
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

//MARK: - 키보드 대응
extension WriteEntryVC {
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


