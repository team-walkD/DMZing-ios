//
//  CourseDetailViewController.swift
//  DMZing
//
//  Created by 김예은 on 12/11/2018.
//  Copyright © 2018 장용범. All rights reserved.
//

import UIKit

class CourseDetailViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var mainTitleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    
    @IBOutlet weak var backView1: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var reviewLabel: UILabel!
    
    @IBOutlet weak var backView2: UIView!
    @IBOutlet weak var mapContainerView: UIView!
    @IBOutlet weak var totalTimeLabel: UILabel!
    @IBOutlet weak var detailButton: UIButton!
    @IBOutlet weak var navi: UINavigationBar!
    
    private var tMapView: TMapView? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.contentInset = UIEdgeInsets(top: -88, left: 0, bottom: 0, right: 0)
        setNavigationBar()
        
        backView1.makeRounded(cornerRadius: 10)
        backView1.dropShadow(color: #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1), opacity: 0.3, offSet: CGSize(width: -0.5, height: 0.5), radius: 10, scale: true)
        
        backView2.makeRounded(cornerRadius: 10)
        backView2.dropShadow(color: #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1), opacity: 0.3, offSet: CGSize(width: -0.5, height: 0.5), radius: 10, scale: true)
        
        detailButton.makeRounded(cornerRadius: 20)
        
        createTmapView()

        // Do any additional setup after loading the view.
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
        
        self.present(detailVC, animated: true, completion: nil)
    }
    
    //MARK: BackBtn Action
    @IBAction func backAction(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func rightBtnAction(_ sender: UIBarButtonItem) {
    }
    
    
    

    
}

//MARK: - TMap extension
extension CourseDetailViewController: TMapViewDelegate {
    
    func createTmapView() {
        tMapView = TMapView.init(frame: mapContainerView.bounds)
        
        guard let mapView = tMapView else {
            print("TMap을 생성하는데 실패하였습니다")
            return
        }
        
        let minLat: Double = 37.5536067
        let maxLat: Double = 37.5662952
        let minLon: Double = 126.96961950000002
        let maxLon: Double = 126.97794509999994
        let centerCoord = CLLocationCoordinate2D(latitude: (minLat + maxLat) / 2, longitude: (minLon + maxLon) / 2)
        
        
        mapView.zoom(toLatSpan: maxLat - minLat, lonSpan: maxLon - minLon)
        mapView.setCenter(centerCoord)
        
        mapView.setZoomLevel(11)
        
        
        mapView.setSKTMapApiKey(tMapKey)// 발급 받은 apiKey 설정
        mapContainerView.addSubview(mapView)
        mapView.delegate = self
        
        addMarker()
        addPolyLine()
    }
    
    func addMarker() {
        
        let mapPoint = TMapPoint(coordinate: CLLocationCoordinate2D(latitude: 37.5662952, longitude: 126.97794509999994))
        let marker1 = TMapMarkerItem()
        marker1.setTMapPoint(mapPoint)
        marker1.setIcon(#imageLiteral(resourceName: "map_one_mark"), anchorPoint: CGPoint(x: 0.5, y: 1.0))
        
        marker1.enableClustering = true
        tMapView?.addTMapMarkerItemID("1", marker: marker1, animated: true)
        
        let mapPoint1 = TMapPoint(coordinate: CLLocationCoordinate2D(latitude: 37.5536067, longitude: 126.96961950000002))
        let marker2 = TMapMarkerItem()
        marker2.setTMapPoint(mapPoint1)
        marker2.setIcon(#imageLiteral(resourceName: "map_two_mark"), anchorPoint: CGPoint(x: 0.5, y: 1.0))
        
        marker2.enableClustering = true
        tMapView?.addTMapMarkerItemID("22ㅇㄹㅁ", marker: marker2, animated: true)
    }
    
    func addPolyLine() {
        
        var array = [TMapPoint(coordinate: CLLocationCoordinate2D(latitude: 37.5662952, longitude: 126.97794509999994)), TMapPoint(coordinate: CLLocationCoordinate2D(latitude: 37.5536067, longitude: 126.96961950000002))]
        
        let line = TMapPolyLine()
        line.setLineColor(#colorLiteral(red: 0.4268620908, green: 0.6586153507, blue: 0.781027019, alpha: 1))
        line.setLineWidth(5)
        
        
        for i in 0..<array.count {
            let point = array[i]
            line.addPoint(point)
        }
        
        tMapView?.addCustomObject(line, id: "line")
        
    }
    
}
