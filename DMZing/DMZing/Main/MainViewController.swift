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
    let userDefault = UserDefaults.standard
    
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
    
    var secondData : SecondDataPickCourse?{
        didSet{
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
        setupNavBar()
        locationInit()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getMainData(url: url("mission"))

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
                
                self.userDefault.set(self.firstData?.id, forKey: "cid")
            
                
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
                
                guard let firstmodel = data as? FirstDataPickCourse else {return}
                for i in 0..<self.purchaseList.count{
                    self.purchaseList[i].isPicked = false
                }
                self.purchaseList[firstmodel.id-1].isPicked = true
                self.firstData = nil
                self.places.removeAll()
                //print(firstmodel)
                self.firstData = firstmodel
                //print(self.firstData)
                self.places = (self.firstData?.places)!
                print(self.places.count)
                
                self.userDefault.set(self.firstData?.id, forKey: "cid")
            
                
            case .networkFail:
                self.networkSimpleAlert()
            default :
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
           
            var themeTitle = ""
            switch purchaseList[indexPath.row].id {
            case 1 :
                themeTitle = "데이트 코스"
            case 2 :
                themeTitle = "역사기행 코스"
            case 3 :
                themeTitle = "자연탐방 코스"
            default :
                themeTitle = ""
             
            }
             cell.titleLabel.text = themeTitle
            
            if(purchaseList[indexPath.row].isPicked){
                cell.backView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            }else{
                cell.backView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            }
            
            return cell
        } else {
            if indexPath.row == 0{
                let cell = self.mainCollectionView.dequeueReusableCell(withReuseIdentifier: FirstCVCell.reuseIdentifier, for: indexPath) as! FirstCVCell
                cell.subtitleLabel.text = firstData?.subDescription
                cell.titleLabel.text = firstData?.mainDescription
                cell.titleLabel.adjustsFontSizeToFitWidth = true
                cell.difficultyLabel.text = firstData?.level
                cell.courseDetailHandler = goToCourseDetail
                if let imageurl = firstData?.imageUrl{
                    cell.titleImgView.setImgWithKF(url: imageurl, defaultImg: UIImage())
                }
                cell.timeLabel.text = "\(firstData?.estimatedTime ?? 0)"
                cell.peopleLabel.text = "\(firstData?.reviewCount ?? 0)"
              
                return cell
            }else if indexPath.row > 0 && indexPath.row <= places.count{
                let cell = self.mainCollectionView.dequeueReusableCell(withReuseIdentifier: MainCVCell.reuseIdentifier, for: indexPath) as! MainCVCell
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
        
        /*임진각 lat 37.8895234711
        임진각 long 126.7405308247
         
         통일공원 lat 37.8513232698,
         통일공원 long 126.7905662159
   
        데이트코스 마지막 lat 37.7689256453
        데이트코스 마지막 long 126.6964910575*/
        
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
        let infoVC = UIStoryboard(name: "Course", bundle: nil).instantiateViewController(withIdentifier: "CourseDetailViewController") as! CourseDetailViewController
        infoVC.cid = cid
        self.present(infoVC, animated: true, completion: nil)
    }

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if(collectionView == themeCollectionView){
            
            putCourseData(url: url("course/pick/\(indexPath.row+1)"))

        }
        

        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.themeCollectionView {
            return CGSize(width: 118, height: 41)
        } else {
           return CGSize(width: 325/375*self.view.frame.width, height: self.mainCollectionView.frame.height)
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
