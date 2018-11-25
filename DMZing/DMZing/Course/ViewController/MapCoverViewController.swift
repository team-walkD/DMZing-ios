//
//  MapCoverViewController.swift
//  DMZing
//
//  Created by 김예은 on 11/11/2018.
//  Copyright © 2018 장용범. All rights reserved.
//

import UIKit
import Kingfisher

class MapCoverViewController: UIViewController, APIService, UIScrollViewDelegate {
    
    @IBOutlet weak var sView: UIScrollView!
    
    //View1 var
    @IBOutlet weak var smallLabel: UILabel!
    @IBOutlet weak var largeLabel: UILabel!
    @IBOutlet weak var pickLabel: UILabel!
    @IBOutlet weak var backImageView: UIImageView!
    @IBOutlet weak var shadowImageView: UIImageView!
    
    var cid: Int = 0
    var sub: String = ""
    var main: String = ""
    var imageUrl: String = ""
    
    //View2 var
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var courseImageView: UIImageView!
    @IBOutlet weak var subLabel: UILabel!
    @IBOutlet weak var mainLabel: UILabel!
    
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
    @IBOutlet weak var placeImageView1: UIImageView!
    @IBOutlet weak var placeImageView2: UIImageView!
    @IBOutlet weak var placeImageView3: UIImageView!
    @IBOutlet weak var placeImageView4: UIImageView!

    @IBOutlet weak var totalTimeLabel: UILabel!
    @IBOutlet weak var detailButton: UIButton!
    
    private var tMapView: TMapView? = nil
    var h: CGFloat?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.sView.delegate = self

        backImageView.snp.makeConstraints {
            (make) in
            
            make.height.equalTo(self.view.frame.height)
            h = self.view.frame.height
        }

        let barHeight = navigationController?.navigationBar.frame.maxY
        sView.contentInset = UIEdgeInsets(top: -barHeight!, left: 0, bottom: 0, right: 0)
        
        //View1
        setNavigationBar()
        setBackBtn(color: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
        
        coverViewInit()
        
        //View2
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if sView.contentOffset.y >= self.view.frame.height {
            sView.isPagingEnabled = false
            self.tabBarController?.tabBar.isHidden = false
        } else {
            sView.isPagingEnabled = true
            self.tabBarController?.tabBar.isHidden = true
        }
    }
    
    //MARK: 보러가기 액션 - View1
    @IBAction func detailAction(_ sender: UIButton) {
        sView.setContentOffset(CGPoint(x: 0, y: backImageView.frame.height), animated: true)
    }
    
    //MARK: 상세보기 액션 - View2
    @IBAction func placeDetailAction(_ sender: UIButton) {
        let detailVC = UIStoryboard(name: "Course", bundle: nil).instantiateViewController(withIdentifier: "PlaceDetailViewController") as! PlaceDetailViewController
        
        detailVC.cid = cid
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
}

//MARK: 맵 커버 뷰 설정 - View1
extension MapCoverViewController {
    
    //MARK: navigationBar transparent
    func setNavigationBar() {
    self.navigationController?.navigationBar.isTranslucent = true
        
        let bar: UINavigationBar! = self.navigationController?.navigationBar
        
        bar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        
        bar.shadowImage = UIImage()
        bar.backgroundColor = UIColor.clear
    }
    
    func coverViewInit() {
        smallLabel.text = sub
        largeLabel.text = main
    }

}

//MARK: 코스 상세보기 뷰 서버 통신 - View2
extension MapCoverViewController {
    
    //MARK: api/course/cid - 코스 상세보기 GET
    func getCourseDetailData(url : String) {
        CourseDetailService.shareInstance.getCourseDetailData(url: url,completion: { [weak self] (result) in
            guard let `self` = self else { return }
            
            switch result {
                
            case .networkSuccess(let data):
                
                let courseDetailData = data as? CourseDetailData
                
                self.pickLabel.text = String(self.gino(courseDetailData?.pickCount))
                self.courseImageView.kf.setImage(with: URL(string: self.gsno(courseDetailData?.imageUrl)), placeholder: UIImage())
                self.subLabel.text = courseDetailData?.subDescription
                self.mainLabel.text = courseDetailData?.title
                self.backImageView.kf.setImage(with: URL(string: self.gsno(courseDetailData?.backgroundGifUrl)), placeholder: UIImage())
                self.titleLabel.text = courseDetailData?.title
                self.contentTextView.text = courseDetailData?.mainDescription
                self.levelLabel.text = courseDetailData?.level
                self.timeLabel.text = String(Int(self.gdno(courseDetailData?.estimatedTime)))
                self.reviewLabel.text = String(self.gino(courseDetailData?.reviewCount))
                self.courseLabel1.text = courseDetailData?.places[0].title
                self.courseLabel2.text = courseDetailData?.places[1].title
                self.courseLabel3.text = courseDetailData?.places[2].title
                self.courseLabel4.text = courseDetailData?.places[3].title
                self.placeImageView1.kf.setImage(with: URL(string: self.gsno(courseDetailData?.places[0].mainImageUrl)), placeholder: UIImage())
                self.placeImageView2.kf.setImage(with: URL(string: self.gsno(courseDetailData?.places[1].mainImageUrl)), placeholder: UIImage())
                self.placeImageView3.kf.setImage(with: URL(string: self.gsno(courseDetailData?.places[2].mainImageUrl)), placeholder: UIImage())
                self.placeImageView4.kf.setImage(with: URL(string: self.gsno(courseDetailData?.places[3].mainImageUrl)), placeholder: UIImage())
                
                self.createTmapView(lat1: self.gdno(courseDetailData?.places[0].latitude), lat2: self.gdno(courseDetailData?.places[1].latitude), lat3: self.gdno(courseDetailData?.places[2].latitude), lat4: self.gdno(courseDetailData?.places[3].latitude), lon1: self.gdno(courseDetailData?.places[0].longitude), lon2: self.gdno(courseDetailData?.places[1].longitude), lon3: self.gdno(courseDetailData?.places[2].longitude), lon4: self.gdno(courseDetailData?.places[3].longitude))
                
                self.totalTimeLabel.text = String(self.gdno(courseDetailData?.estimatedTime))
                
            case .networkFail :
                self.networkSimpleAlert()
            default :
                self.simpleAlert(title: "오류", message: "다시 시도해주세요")
                break
            }
        })
    }
    
    func gdno(_ value : Double?) -> Double{
        return value ?? 0.0
    }
}

//MARK: - TMap extension
extension MapCoverViewController: TMapViewDelegate {
    
    func createTmapView(lat1: Double, lat2: Double, lat3: Double, lat4: Double, lon1: Double, lon2: Double, lon3: Double, lon4: Double) {
        tMapView = TMapView.init(frame: mapContainerView.bounds)
        
        guard let mapView = tMapView else {
            print("TMap을 생성하는데 실패하였습니다")
            return
        }
        
        let centerCoord = CLLocationCoordinate2D(latitude: lat1, longitude: lon1)
        
        mapView.zoom(toLatSpan: lat1, lonSpan: lon1)
        mapView.setCenter(centerCoord)
        mapView.setZoomLevel(8)
        
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

