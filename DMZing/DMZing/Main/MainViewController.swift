//
//  ViewController.swift
//  DMZing
//
//  Created by 장한솔 on 2018. 10. 21..
//  Copyright © 2018년 장용범. All rights reserved.
//

import UIKit
import Kingfisher

enum Direction {
    case right
    case left
}


class MainViewController: UIViewController, APIService {
    
    @IBOutlet weak var themeCollectionView: UICollectionView!
    @IBOutlet weak var mainCollectionView: UICollectionView!
    
    var finalOffset : CGFloat = 0
    var startOffset  : CGFloat = 0
    var currentIdx = 0
    
    var locationManager = CLLocationManager()
    var currentLocation : CLLocation?
    
    var purchaseList : [FirstDataPurchaseList] = [] {
        didSet {
            themeCollectionView.reloadData()
        }
    }
    
    var firstData : FirstDataPickCourse?{
        didSet {
            mainCollectionView.reloadData()
        }
    }
    
    var places : [FirstDataPickCoursePlace] = []{
        didSet{
            mainCollectionView.reloadData()
        }
    }
    
    var currentMission : FirstDataPickCoursePlace?{
        didSet{
            mainCollectionView.reloadData()
        }
    }
    
    var nextMission : FirstDataPickCoursePlace?{
        didSet{
            mainCollectionView.reloadData()
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        themeCollectionView.delegate = self
        themeCollectionView.dataSource = self
        mainCollectionView.delegate = self
        mainCollectionView.dataSource = self
        setLogoButton()
        setChatButton()
        setupNavBar()
        locationInit()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getMainData(url: url("mission"))
        self.tabBarController?.tabBar.isHidden = false
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.clearAllNotice()
    }
    
    
    func setupNavBar(){
        self.navigationController?.navigationBar.barTintColor = UIColor.FlatColor.Blue.lightBlue
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    
    func getMainData(url : String){
        GetMissionService.shareInstance.getFirstData(url: url,completion: { [weak self] (result) in
            guard let `self` = self else { return }
            switch result {
            case .networkSuccess(let data):
                
                guard let firstmodel = data as? FirstVO else {return}
                self.purchaseList.removeAll()
                self.firstData = nil
                self.places.removeAll()
                self.purchaseList = firstmodel.purchaseList
                //print(firstmodel)
                self.firstData = firstmodel.pickCourse
                //print(self.firstData)
                self.places = (self.firstData?.places)!
                print(self.places.count)
               
            case .networkFail:
                self.networkSimpleAlert()
            default :
                self.simpleAlert(title: "오류", message: "다시 시도해주세요")
                break
            }
        })
    }
    
    func putCourseData(url : String){
        PutCourseService.shareInstance.putCourse(url: url,completion: { [weak self] (result) in
            guard let `self` = self else { return }
            switch result {
            case .networkSuccess(let data):
                self.clearAllNotice()
                guard let firstmodel = data as? FirstDataPickCourse else {return}
                for i in 0..<self.purchaseList.count{
                    self.purchaseList[i].isPicked = firstmodel.id == self.purchaseList[i].id ? true : false
                }
                self.firstData = nil
                self.places.removeAll()
                self.firstData = firstmodel
                self.places = (self.firstData?.places)!
            case .networkFail:
                self.clearAllNotice()
                self.networkSimpleAlert()
            default :
                self.clearAllNotice()
                self.simpleAlert(title: "오류", message: "다시 시도해주세요")
                break
            }
        })
    }
    
}





extension MainViewController : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.themeCollectionView {
            return purchaseList.count
        } else {
            if let lastSequence = self.places.last?.sequence {
                let letterImageUrl = self.places.last?.letterImageURL
                
                if lastSequence == 100{
                    if(letterImageUrl == nil){
                        return 1+self.places.count
                    }else{
                        return 2+self.places.count
                    }
                }else{
                    return 1+self.places.count
                }
                
                
                
            }else{
                
                return 1
            }
            
            
        }
    }
   
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.themeCollectionView {
            let cell = self.themeCollectionView.dequeueReusableCell(withReuseIdentifier: "ThemeCollectionViewCell", for: indexPath) as! ThemeCollectionViewCell
            guard purchaseList.count > 0 else {return cell}
            cell.titleLabel.text = purchaseList[indexPath.row].title
            
            if(purchaseList[indexPath.row].isPicked){
                cell.backView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                cell.titleLabel.textColor = UIColor.FlatColor.Blue.deepBlue
            }else{
                cell.backView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.62)
                cell.titleLabel.textColor = #colorLiteral(red: 0.1413645744, green: 0.2798363268, blue: 0.3539872766, alpha: 0.62)
            }
            
            return cell
        } else {
            if indexPath.row == 0{
                let cell = self.mainCollectionView.dequeueReusableCell(withReuseIdentifier: FirstCVCell.reuseIdentifier, for: indexPath) as! FirstCVCell
                cell.configure()
                cell.subtitleLabel.text = firstData?.subDescription
                cell.subtitleLabel.adjustsFontSizeToFitWidth = true
                cell.titleLabel.text = firstData?.title
                cell.titleLabel.adjustsFontSizeToFitWidth = true
                
                cell.difficultyLabel.text = firstData?.level
                cell.courseDetailHandler = goToCourseDetail
                if let imageurl = firstData?.imageUrl{
                    cell.titleImgView.setImgWithKF(url: imageurl, defaultImg: UIImage())
                }
                cell.timeLabel.text = "\(Int(firstData?.estimatedTime ?? 0))"
                cell.peopleLabel.text = "\(firstData?.reviewCount ?? 0)"
                
                return cell
            }else if indexPath.row > 0 && indexPath.row <= places.count{
                let cell = self.mainCollectionView.dequeueReusableCell(withReuseIdentifier: MainCVCell.reuseIdentifier, for: indexPath) as! MainCVCell
                cell.configure()
                cell.titleImgView.setImgWithKF(url: places[indexPath.row-1].mainImageURL, defaultImg: UIImage())
                cell.subtitleLabel.text = ""
                cell.titleLabel.text = places[indexPath.row-1].title
                cell.contentTextView.text = places[indexPath.row-1].hint
                
                cell.findLetterButton.tag = indexPath.row-1
                cell.findLetterHandler = touchLetterBtn
                
                if places[indexPath.row-1].letterImageURL != nil{
                    
                    cell.findLetterButton.setTitle("편지 보기", for: .normal )
                    
                }else{
                    cell.findLetterButton.setTitle("편지 찾기", for: .normal)
                }
                
                return cell
                
            }else{
                
                let cell = self.mainCollectionView.dequeueReusableCell(withReuseIdentifier: LastCVCell.reuseIdentifier, for: indexPath) as! LastCVCell
                
                var currentTitle = ""
                
                for i in 0..<self.purchaseList.count{
                    if purchaseList[i].isPicked == true{
                        currentTitle = purchaseList[i].title
                    }
                }
                cell.titleLabel.text = currentTitle
                return cell
            }
            
        }
    }
    
    
    
    func findLetteAction(index : Int, lat : Double, long : Double){
        let URL = url("mission")
        let cid = self.firstData?.id ?? 0
        let pid = places[index].id
        
        /*
         //핵심여행
         백마고지위령비와기념관 (38.2700172415, 127.1652863536)
         철원노동당사 (38.2551779840, 127.2018389901)
         평화전망대 (38.3094166046, 127.2304208676)
         제2땅굴 (38.1879930099, 127.2893135057)

         //데이트
         임진각 (37.8895234711, 126.7405308247)
         통일공원 (37.8513232698, 126.7905662159)
         카트랜드 (37.7773633354, 126.684436368)
         파주아울렛 (37.7689256453, 126.6964910575)
         
         //역사
         고성 DMZ (38.5763238583, 128.3826570629)
         통일 전망대 (38.5148483857,128.4171836237)
         이승만 (38.4709844380, 128.4362804829)
         화암사 (38.2269885423, 128.4693434396)
         
         //자연
         하늘빛 호수마을 (38.0631006539,127.6638496162)
         카트레일카 (38.1007385507,127.6970121290)
         파로호 (38.0993652277,127.7779270055)
         평화의댐 (38.2116284404,127.8474561554)
         
         typealias location = (lat : Double, long : Double)
         var arr : [location] = [(37.8895234711,126.7405308247), (37.8513232698, 126.7905662159), (37.7773633354, 126.684436368), (37.7689256453, 126.6964910575),(38.5763238583, 128.3826570629),(38.5148483857,128.4171836237), (38.4709844380, 128.4362804829), (38.2269885423, 128.4693434396), (38.0631006539,127.6638496162), (38.1007385507,127.6970121290), (38.0993652277,127.7779270055), (38.2116284404,127.8474561554), (38.2700172415, 127.1652863536), (38.2551779840, 127.2018389901), (38.3094166046, 127.2304208676), (38.1879930099, 127.2893135057)]
        
         */
       
        let body: [String: Any] = [
            "cid": cid,
            "pid": pid,
            "latitude": lat,
            "longitude": long
        ]
        findLetterNetworking(url: URL , params: body)
    }
    
    func goToCourseDetail(){
        let cid = self.firstData?.id ?? 0
        let mapCoverViewController = UIStoryboard(name: "Course", bundle: nil).instantiateViewController(withIdentifier: "MapCoverViewController") as! MapCoverViewController
        mapCoverViewController.cid = cid
        mapCoverViewController.sub = gsno(firstData?.subDescription)
        mapCoverViewController.main = gsno(firstData?.title)
        self.navigationController?.pushViewController(mapCoverViewController, animated: true)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if(collectionView == themeCollectionView){
            self.pleaseWait()
            let cId = self.purchaseList[indexPath.row].id
            putCourseData(url: url("course/pick/\(cId)"))
            
        }
        
        
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.themeCollectionView {
            return CGSize(width: 118, height: 41)
        } else {
            return CGSize(width: 325/375*UIScreen.main.bounds.width, height: self.mainCollectionView.frame.height)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == self.themeCollectionView {
            return 15
        } else {
            return 12
        }
    }
    
}

//MARK: - 컬렉션 뷰 드래깅
extension MainViewController : UIScrollViewDelegate {
    /**
     현재 메인셀의 인덱스를 구하는 함수
     */
    private func indexOfMajorCell(direction : Direction) -> Int {
        var index = 0
        switch direction {
        case .right :
            index = currentIdx + 1
        case .left :
            index = currentIdx - 1
        }
        let numberOfItems = mainCollectionView.numberOfItems(inSection: 0)
        let safeIndex = max(0, min(numberOfItems - 1, index))
        currentIdx = safeIndex
        return safeIndex
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        startOffset = mainCollectionView.contentOffset.x
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        finalOffset = mainCollectionView.contentOffset.x
        //stop scrollview sliding
        targetContentOffset.pointee = scrollView.contentOffset
        if finalOffset > startOffset {
            //뒤로 넘기기
            let majorIdx = indexOfMajorCell(direction: .right)
            let indexPath = IndexPath(row: majorIdx, section: 0)
            mainCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        } else if finalOffset < startOffset {
            //앞으로 가기
            let majorIdx = indexOfMajorCell(direction: .left)
            let indexPath = IndexPath(row: majorIdx, section: 0)
            mainCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        } else {
            //print("둘다 아님")
        }
    }
}


extension MainViewController : CLLocationManagerDelegate{
    func locationInit(){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    
    func touchLetterBtn(index : Int, sender : UIButton){
        if sender.currentTitle == "편지 보기"{
            let mainStoryboard = Storyboard.shared().mainStoryboard
            if let letterPopupVC = mainStoryboard.instantiateViewController(withIdentifier:LetterPopupVC.reuseIdentifier) as? LetterPopupVC {
                letterPopupVC.letterImgUrl = places[index].letterImageURL ?? ""
                self.present(letterPopupVC, animated: true, completion: nil)
            }
        } else {
            getLocation(index: index)
        }
    }
    
    func getLocation(index : Int){
        let loacationAuthorizationStatus =  CLLocationManager.authorizationStatus()
        switch loacationAuthorizationStatus {
        case .authorizedWhenInUse:
            currentLocation = locationManager.location
            guard let latitude = currentLocation?.coordinate.latitude,
                let longitude = currentLocation?.coordinate.longitude else {return}
            findLetteAction(index: index, lat : latitude , long : longitude)
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            showLocationDisableAlert()
        case .denied:
            showLocationDisableAlert()
        default :
            break
        }
    }
    
    func showLocationDisableAlert() {
        let alertController = UIAlertController(title: "위치 접근이 제한되었습니다.", message: "위치 접근 권한이 필요합니다.", preferredStyle: .alert)
        let openAction = UIAlertAction(title: "설정으로 가기", style: .default) { (action) in
            if let url = URL(string: UIApplicationOpenSettingsURLString) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
        let cancelTitle = "취소"
        let cancelAction = UIAlertAction(title: cancelTitle,style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        alertController.addAction(openAction)
        self.present(alertController, animated: true, completion: nil)
    }
}

extension MainViewController {
    func findLetterNetworking(url : String, params : [String : Any]){
        PostableMissionService.shareInstance.sendMission(url: url, params: params, completion: { [weak self] (result) in
            guard let `self` = self else { return }
            switch result {
            case .networkSuccess(let data):
                guard let data = data as? MissionVO else{return}
                
                
                self.currentMission = data.first
                self.nextMission = data.last
                self.places.remove(at: self.places.count-1)
                self.places.append(self.currentMission!)
                self.places.append(self.nextMission!)
                self.simpleAlert(title: "편지 찾기 성공", message: "숨겨진 편지를 \n 발견했어요!\n +\((self.currentMission?.reward)!)DP")
                //print(self.currentMission)
                break
            case .badRequest :
                self.simpleAlert(title: "편지 찾기 실패", message: "편지가 없어요! \n 다른 위치로 이동하세요")
            case .networkFail :
                self.networkSimpleAlert()
            default :
                self.simpleAlert(title: "오류", message: "다시 시도해주세요")
                break
            }
        })
    }
}
