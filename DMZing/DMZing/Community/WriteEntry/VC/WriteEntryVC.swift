//
//  WriteEntryVC.swift
//  DMZing
//
//  Created by 강수진 on 2018. 11. 8..
//  Copyright © 2018년 장용범. All rights reserved.
//

import UIKit
extension String {
    func dateTxtToTimeStamp() -> TimeInterval{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        guard let date = dateFormatter.date(from: self) else {
            fatalError("포맷과 맞지 않아 데이터 변환이 실패했습니다")
        }
        return date.timeIntervalSince1970*1000
    }
}
class WriteEntryVC: UIViewController, APIService{
    
    var selectedCourseId  = -1
    let datePickerView = UIDatePicker()
    let imagePicker : UIImagePickerController = UIImagePickerController()
    var keyboardDismissGesture: UITapGestureRecognizer?
    var rowCount = 0 {
        didSet {
            tableView.isHidden = !(rowCount > 0)
            tableView.reloadData()
            articleArr = Array.init(repeatElement(ArticleStruct(), count: rowCount))
        }
    }
    
    var articleArr : [ArticleStruct] = []
    var bgImgUrl = ""
    
    @IBAction func dismissAction(_ sender: Any) {
        
        if let navi = self.parent as? UINavigationController {
            navi.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBOutlet weak var writeDescLbl: UILabel!
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
        checkAlbumPermission()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initDatePicker()
        setKeyboardSetting()
        setUpTableView()
        writeDescLbl.adjustsFontSizeToFitWidth = true
        titleTxt.addTarget(self, action: #selector(isBtnValid), for: .editingChanged)
        doneBtn.addTarget(self, action: #selector(doneAction), for: .touchUpInside)
        titleTxt.attributedPlaceholder = NSAttributedString(string: "제목을 입력해주세요", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        self.navigationController?.navigationBar.isTranslucent = false
    }
    
    func setUpTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView(frame : .zero)
        tableView.isHidden = true
    }
    @objc func doneAction(){
        let writtenArticle = articleArr.filter { (item) in
            return item.day != 0
        }
        print(writtenArticle)
        let postDTO = writtenArticle.map { (item) -> [String : Any] in
            let postDto = [
                "day": item.day,
                "postImgUrl": item.imageArr,
                "title": item.title,
                "content": item.content
                ] as [String : Any]
            return postDto
        }
        guard let startDateString = startTxt.text, let endDateString = endTxt.text else {return}
        let startTime = startDateString.dateTxtToTimeStamp()
        let endTime = endDateString.dateTxtToTimeStamp()
        let params : [String : Any] = [
            "title": titleTxt.text ?? "",
            "thumbnailUrl": bgImgUrl,
            "courseId": selectedCourseId,
            "startAt": startTime,
            "endAt": endTime,
            "postDto" : postDTO
        ]
        writeArticleReview(url: url("reviews"), params: params)
        
    }
    @objc func isBtnValid(){
        //완료 버튼 활성화
        if titleTxt.text != "" && (articleArr.filter { (item) in
            return item.day != 0
        }).count > 0 {
            doneBtn.isEnabled = true
            doneBtn.backgroundColor = UIColor.FlatColor.Blue.middleBlue
        } else {
            doneBtn.isEnabled = false
            doneBtn.backgroundColor = #colorLiteral(red: 0.8666666667, green: 0.8666666667, blue: 0.8666666667, alpha: 1)
        }
    }
}


extension WriteEntryVC : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rowCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: WriteEntryTVCell.reuseIdentifier) as! WriteEntryTVCell
        cell.configure(data: (indexPath.row+1).description, isEmpty : articleArr[indexPath.row].day == 0)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let reviewStoryboard = Storyboard.shared().reviewStoryboard
        
        if let writeArticleReviewVC = reviewStoryboard.instantiateViewController(withIdentifier:WriteArticleReviewVC.reuseIdentifier) as? WriteArticleReviewVC {
            
            writeArticleReviewVC.writeArticleHandler = {(article : ArticleStruct)  in
                self.articleArr[article.day-1] = article
                let cell = self.tableView.cellForRow(at: IndexPath(row : article.day-1, section : 0)) as! WriteEntryTVCell
                cell.configure(data: (article.day).description, isEmpty : self.articleArr[article.day-1].day == 0)
                self.isBtnValid()
            }
            writeArticleReviewVC.selectedArticle = articleArr[indexPath.row]
            writeArticleReviewVC.selectedDay = indexPath.row+1
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy.MM.dd"
            guard let date = dateFormatter.date(from: startTxt.text!) else {
                fatalError("포맷과 맞지 않아 데이터 변환이 실패했습니다")
            }
            datePickerView.date = date
            let strDate = dateFormatter.string(from: date.addingTimeInterval(TimeInterval(60*60*24*indexPath.row+1)))
            writeArticleReviewVC.selectedDate = strDate
            self.navigationController?.pushViewController(writeArticleReviewVC, animated: true)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

//DatePicker
extension WriteEntryVC {
    
    func initDatePicker(){
        datePickerView.datePickerMode = .date
        
        let loc = Locale(identifier: "ko_KR")
        self.datePickerView.locale = loc
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
        let flexibleButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        doneButton.tag = (textField == startTxt) ? 0 : 1
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

//통신
extension WriteEntryVC {
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
                    self.bgImgView.setImgWithKF(url: img, defaultImg: #imageLiteral(resourceName: "review_default_basic_img"))
                    self.bgImgUrl = img
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
    
    func writeArticleReview(url : String, params : [String : Any]){
        WriteArticleService.shareInstance.writeArticleReview(url: url, params: params, completion: { [weak self] (result) in
            guard let `self` = self else { return }
            switch result {
            case .networkSuccess(_):
                self.simpleAlertwithHandler(title: "성공", message: "리뷰를 등록했습니다", isCancleBtnExist : false, okHandler: { (_) in
                    self.dismissAction("")
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
}

