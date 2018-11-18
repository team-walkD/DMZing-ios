//
//  CourseDetailViewController.swift
//  DMZing
//
//  Created by 김예은 on 12/11/2018.
//  Copyright © 2018 장용범. All rights reserved.
//

import UIKit
import Kingfisher

class CourseDetailViewController: UIViewController, APIService {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var mainTitleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var backImageView: UIImageView!
    
    @IBOutlet weak var backView1: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var reviewLabel: UILabel!
    
    @IBOutlet weak var backView2: UIView!
    @IBOutlet weak var mapContainerView: UIView!
    @IBOutlet weak var courseLabel1: UILabel!
    @IBOutlet weak var courseLabel2: UILabel!
    @IBOutlet weak var courseLabel3: UILabel!
    @IBOutlet weak var courseLabel4: UILabel!
    @IBOutlet weak var courseImageView1: UIImageView!
    @IBOutlet weak var courseImageView2: UIImageView!
    @IBOutlet weak var courseImageView3: UIImageView!
    @IBOutlet weak var courseImageView4: UIImageView!
    
    @IBOutlet weak var totalTimeLabel: UILabel!
    @IBOutlet weak var detailButton: UIButton!
    @IBOutlet weak var navi: UINavigationBar!
    
    var courseNameArr: [String] = []
    var courseImageArr: [String] = []
    
    var cid: Int = 0
    var timeArr: [Int] = []
    
    private var tMapView: TMapView? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.contentInset = UIEdgeInsets(top: -44, left: 0, bottom: 0, right: 0)
        setNavigationBar()
        
        backView1.makeRounded(cornerRadius: 10)
        backView1.dropShadow(color: #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1), opacity: 0.3, offSet: CGSize(width: -0.5, height: 0.5), radius: 10, scale: true)
        
        backView2.makeRounded(cornerRadius: 10)
        backView2.dropShadow(color: #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1), opacity: 0.3, offSet: CGSize(width: -0.5, height: 0.5), radius: 10, scale: true)
        
        detailButton.makeRounded(cornerRadius: 20)
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let `self` = self else { return }
            self.getCourseDetailData(url: self.url("course/\(self.cid)"))
        }
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let `self` = self else { return }
            self.getCourseDetailData(url: self.url("course/\(self.cid)"))
        }
    }
    
    //MARK: navigationBar transparent
    func setNavigationBar() {
        
        navi.isTranslucent = true
        navi.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navi.shadowImage = UIImage()
        navi.backgroundColor = UIColor.clear
    }
    
    //MARK: 상세보기 액션
    @IBAction func detailAction(_ sender: UIButton) {
        let detailVC = UIStoryboard(name: "Course", bundle: nil).instantiateViewController(withIdentifier: "PlaceDetailViewController") as! PlaceDetailViewController
        
        detailVC.cid = cid
        
        self.present(detailVC, animated: true, completion: nil)
    }
    
    //MARK: BackBtn Action
    @IBAction func backAction(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func rightBtnAction(_ sender: UIBarButtonItem) {
    }
    
}

//MARK: Server
extension CourseDetailViewController {
    
    //MARK: api/course/cid - 코스 상세보기 GET
    func getCourseDetailData(url : String) {
        CourseDetailService.shareInstance.getCourseDetailData(url: url,completion: { [weak self] (result) in
            guard let `self` = self else { return }
            
            switch result {
                
            case .networkSuccess(let data):
                
                let courseDetailData = data as? CourseDetailData
        
                self.backImageView.kf.setImage(with: URL(string: self.gsno(courseDetailData?.imageUrl)), placeholder: UIImage())
                self.mainTitleLabel.text = courseDetailData?.subDescription
                self.subTitleLabel.text = courseDetailData?.title
                self.titleLabel.text = courseDetailData?.title
                self.contentTextView.text = courseDetailData?.mainDescription
                self.levelLabel.text = courseDetailData?.level
                self.timeLabel.text = String(self.gino(courseDetailData?.estimatedTime))
                self.reviewLabel.text = String(self.gino(courseDetailData?.reviewCount))
                self.courseLabel1.text = courseDetailData?.places[0].title
                self.courseLabel2.text = courseDetailData?.places[1].title
                self.courseLabel3.text = courseDetailData?.places[2].title
                self.courseLabel4.text = courseDetailData?.places[3].title
                self.courseImageView1.kf.setImage(with: URL(string: self.gsno(courseDetailData?.places[0].mainImageUrl)), placeholder: UIImage())
                self.courseImageView2.kf.setImage(with: URL(string: self.gsno(courseDetailData?.places[1].mainImageUrl)), placeholder: UIImage())
                self.courseImageView3.kf.setImage(with: URL(string: self.gsno(courseDetailData?.places[2].mainImageUrl)), placeholder: UIImage())
                self.courseImageView4.kf.setImage(with: URL(string: self.gsno(courseDetailData?.places[3].mainImageUrl)), placeholder: UIImage())
                
                self.createTmapView(lat1: self.gdno(courseDetailData?.places[0].latitude), lat2: self.gdno(courseDetailData?.places[1].latitude), lat3: self.gdno(courseDetailData?.places[2].latitude), lat4: self.gdno(courseDetailData?.places[3].latitude), lon1: self.gdno(courseDetailData?.places[0].longitude), lon2: self.gdno(courseDetailData?.places[1].longitude), lon3: self.gdno(courseDetailData?.places[2].longitude), lon4: self.gdno(courseDetailData?.places[3].longitude))
                
                self.totalTimeLabel.text = self.totalTime(lat1: self.gdno(courseDetailData?.places[0].latitude), lat2: self.gdno(courseDetailData?.places[1].latitude), lat3: self.gdno(courseDetailData?.places[2].latitude), lat4: self.gdno(courseDetailData?.places[3].latitude), lon1: self.gdno(courseDetailData?.places[0].longitude), lon2: self.gdno(courseDetailData?.places[1].longitude), lon3: self.gdno(courseDetailData?.places[2].longitude), lon4: self.gdno(courseDetailData?.places[3].longitude))

            case .networkFail :
                self.networkSimpleAlert()
            default :
                self.simpleAlert(title: "오류", message: "다시 시도해주세요")
                break
            }
        })
    }
    
    //MARK: Tmap 소요시간
    func calculateCarTime(startLat : Double, startLong : Double, endLat : Double, endLong : Double) -> Int{
        let version = 1
        let tollgateFareOption = 1
        let url = "http://api2.sktelecom.com/tmap/routes?version=\(version)&appKey=\(tMapKey)&tollgateFareOption=\(tollgateFareOption)&endX=\(endLong)&endY=\(endLat)&startX=\(startLong)&startY=\(startLat)"

        CalculateTimeService.shareInstance.calculateTimeToNext(url: url, params: [:], completion: { [weak self] (result) in
            
            guard let `self` = self else { return}
            switch result {
            case .networkSuccess(let data):
                guard let data_ = data as? CalculateTimeVO else {return}
                guard let time = data_.features.first?.properties.carTime else {return}
                print("dd\(time)")

                UserDefaults.standard.set(time, forKey: "time")
            case .networkFail :
                self.networkSimpleAlert()
            default :
                self.simpleAlert(title: "오류", message: "다시 시도해주세요")
            }
        })
        
        return UserDefaults.standard.integer(forKey: "time")
    }
    
    func totalTime(lat1: Double, lat2: Double, lat3: Double, lat4: Double, lon1: Double, lon2: Double, lon3: Double, lon4: Double) -> String {
            let a = self.calculateCarTime(startLat: lat1, startLong: lon1, endLat: lat2, endLong: lon2)
            let b = self.calculateCarTime(startLat: lat2, startLong: lon2, endLat: lat3, endLong: lon3)
            let c = self.calculateCarTime(startLat: lat3, startLong: lon3, endLat: lat4, endLong: lon4)

            let total:Double = Double((a + b + c) / 3600)

            return String(total)
    }
    
    func gdno(_ value : Double?) -> Double{
        return value ?? 0.0
    }
}

//MARK: - TMap extension
extension CourseDetailViewController: TMapViewDelegate {
    
    
    func createTmapView(lat1: Double, lat2: Double, lat3: Double, lat4: Double, lon1: Double, lon2: Double, lon3: Double, lon4: Double) {
        tMapView = TMapView.init(frame: mapContainerView.bounds)
        
        guard let mapView = tMapView else {
            print("TMap을 생성하는데 실패하였습니다")
            return
        }

        let centerCoord = CLLocationCoordinate2D(latitude: lat1, longitude: lon1)

        mapView.zoom(toLatSpan: lat1, lonSpan: lon1)
        mapView.setCenter(centerCoord)
        mapView.setZoomLevel(7)
        
        mapView.setSKTMapApiKey(tMapKey)// 발급 받은 apiKey 설정
        mapContainerView.addSubview(mapView)
        mapView.delegate = self
        
        addMarker(lat1: lat1, lat2: lat2, lat3: lat3, lat4: lat4, lon1: lon1, lon2: lon2, lon3: lon3, lon4: lon4)
        addPolyLine(lat1: lat1, lat2: lat2, lat3: lat3, lat4: lat4, lon1: lon1, lon2: lon2, lon3: lon3, lon4: lon4)
    }
    
    func addMarker(lat1: Double, lat2: Double, lat3: Double, lat4: Double, lon1: Double, lon2: Double, lon3: Double, lon4: Double) {

        let mapPoint1 = TMapPoint(coordinate: CLLocationCoordinate2D(latitude: lat1, longitude: lon1))
        let marker1 = TMapMarkerItem()
        marker1.setTMapPoint(mapPoint1)
        marker1.setIcon(#imageLiteral(resourceName: "map_one_mark"), anchorPoint: CGPoint(x: 0.5, y: 1.0))
        
        marker1.enableClustering = true
        tMapView?.addTMapMarkerItemID("1", marker: marker1, animated: true)
        
        let mapPoint2 = TMapPoint(coordinate: CLLocationCoordinate2D(latitude: lat2, longitude: lon2))
        let marker2 = TMapMarkerItem()
        marker2.setTMapPoint(mapPoint2)
        marker2.setIcon(#imageLiteral(resourceName: "map_two_mark"), anchorPoint: CGPoint(x: 0.5, y: 1.0))
        
        marker2.enableClustering = true
        tMapView?.addTMapMarkerItemID("2", marker: marker2, animated: true)
        
        let mapPoint3 = TMapPoint(coordinate: CLLocationCoordinate2D(latitude: lat3, longitude: lon3))
        let marker3 = TMapMarkerItem()
        marker3.setTMapPoint(mapPoint3)
        marker3.setIcon(#imageLiteral(resourceName: "map_three_mark"), anchorPoint: CGPoint(x: 0.5, y: 1.0))
        
        marker3.enableClustering = true
        tMapView?.addTMapMarkerItemID("3", marker: marker3, animated: true)
        
        let mapPoint4 = TMapPoint(coordinate: CLLocationCoordinate2D(latitude: lat4, longitude: lon4))
        let marker4 = TMapMarkerItem()
        marker4.setTMapPoint(mapPoint4)
        marker4.setIcon(#imageLiteral(resourceName: "map_four_mark"), anchorPoint: CGPoint(x: 0.5, y: 1.0))
        
        marker4.enableClustering = true
        tMapView?.addTMapMarkerItemID("4", marker: marker4, animated: true)
    }
    
    func addPolyLine(lat1: Double, lat2: Double, lat3: Double, lat4: Double, lon1: Double, lon2: Double, lon3: Double, lon4: Double) {
        
        var array = [TMapPoint(coordinate: CLLocationCoordinate2D(latitude: lat1, longitude: lon1)), TMapPoint(coordinate: CLLocationCoordinate2D(latitude: lat2, longitude: lon2)), TMapPoint(coordinate: CLLocationCoordinate2D(latitude: lat3, longitude: lon3)), TMapPoint(coordinate: CLLocationCoordinate2D(latitude: lat4, longitude: lon4))]
        
        let line = TMapPolyLine()
        line.setLineColor(#colorLiteral(red: 0.4268620908, green: 0.6586153507, blue: 0.781027019, alpha: 1))
        line.setLineWidth(2)
        
        for i in 0..<array.count {
            let point = array[i]
            line.addPoint(point)
        }
        
        tMapView?.addCustomObject(line, id: "line")
        
    }
    
}
