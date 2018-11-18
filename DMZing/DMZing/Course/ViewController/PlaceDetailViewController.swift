//
//  PlaceDetailViewController.swift
//  DMZing
//
//  Created by 김예은 on 15/11/2018.
//  Copyright © 2018 장용범. All rights reserved.
//

import UIKit
import Kingfisher

class PlaceDetailViewController: UIViewController, APIService {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var mapContainerView: UIView!
    @IBOutlet weak var navi: UINavigationBar!

    var places : [Place] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    var cid: Int = 0
    var imageArr = [#imageLiteral(resourceName: "map_one_mark"), #imageLiteral(resourceName: "map_two_mark"), #imageLiteral(resourceName: "map_three_mark"), #imageLiteral(resourceName: "map_four_mark"), #imageLiteral(resourceName: "map_four_mark")]
    
    private var tMapView: TMapView? = nil
    
    var expandedRows = Set<Int>()
    var initialTouchPoint: CGPoint = CGPoint(x: 0, y: 0)
    
    let center = NotificationCenter.default

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTableView()
        setNavigationBar()
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let `self` = self else { return }
            self.getPlaceData(url: self.url("course/\(self.cid)/places"))
        }
        
        center.addObserver(self, selector: #selector(reverseAction), name: Notification.Name("reverseAction"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let `self` = self else { return }
            self.getPlaceData(url: self.url("course/\(self.cid)/places"))
        }
    }
    
    @objc func reverseAction(noti: Notification) {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlaceDetailTableViewCell") as! PlaceDetailTableViewCell
        
        if let placeTag = noti.object as?  Int {
            
            switch cell.isExpanded {
            
            case true:
                self.expandedRows.remove(placeTag)
                
            case false:
                self.expandedRows.insert(placeTag)
            }
            
            cell.isExpanded = !cell.isExpanded
            
            self.tableView.beginUpdates()
            self.tableView.endUpdates()
        }
    }
    
    func setTableView() {
        
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    //MARK: navigationBar transparent
    func setNavigationBar() {
        
        navi.isTranslucent = true
        navi.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navi.shadowImage = UIImage()
        navi.backgroundColor = UIColor.clear
    }
    
    //MARK: Dismiss Action
    @IBAction func dismissAction(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
}

//MARK: Server
extension PlaceDetailViewController {
    
    func getPlaceData(url : String) {
        PlaceService.shareInstance.getPlaceData(url: url,completion: { [weak self] (result) in
            guard let `self` = self else { return }
            
            switch result {
                
            case .networkSuccess(let data):
                let placeData = data as? PlaceData
                
                if let placeData_ = placeData {
                    self.places = placeData_
                    self.createTmapView()
                }
            case .networkFail :
                self.networkSimpleAlert()
            default :
                self.simpleAlert(title: "오류", message: "다시 시도해주세요")
                break
            }
        })
    }
    
    //MARK: Tmap 소요시간
    func calculateCarTime(startLat : Double, startLong : Double, endLat : Double, endLong : Double) -> Int {
        
        let version = 1
        let tollgateFareOption = 1
        let url = "http://api2.sktelecom.com/tmap/routes?version=\(version)&appKey=\(tMapKey)&tollgateFareOption=\(tollgateFareOption)&endX=\(endLong)&endY=\(endLat)&startX=\(startLong)&startY=\(startLat)"
        
        CalculateTimeService.shareInstance.calculateTimeToNext(url: url, params: [:], completion: { [weak self] (result) in
            
            guard let `self` = self else { return }
            switch result {
            case .networkSuccess(let data):
                guard let data_ = data as? CalculateTimeVO else {return}
                guard let time = data_.features.first?.properties.carTime else {return}
                print("dd\(time)")
                
                UserDefaults.standard.set(time, forKey: "carTime")
            case .networkFail :
                self.networkSimpleAlert()
            default :
                self.simpleAlert(title: "오류", message: "다시 시도해주세요")
            }
        })
        
        var car = UserDefaults.standard.integer(forKey: "carTime") / 60
        
        return car
    }
    
    func getCatTime(lat1: Double, lat2: Double, lon1: Double, lon2: Double) -> Double {
        var time: Double = 0.0
        
        time = Double(self.calculateCarTime(startLat: lat1, startLong: lon1, endLat: lat2, endLong: lon2) / 3600)
        
        return time
    }
}

//MARK: - TableView extension
extension PlaceDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlaceDetailTableViewCell") as! PlaceDetailTableViewCell
        
        cell.numImageView.image = imageArr[indexPath.row]
        cell.mainImageView.kf.setImage(with: URL(string: places[indexPath.row].mainImageUrl), placeholder: UIImage())
        cell.placeLabel.text = places[indexPath.row].title
        cell.carLabel.text = "10분"
        cell.nextLabel1.text = places[indexPath.row].peripheries[0].title
        cell.nextLabel2.text = places[indexPath.row].peripheries[1].title
        cell.nextLabel3.text = places[indexPath.row].peripheries[2].title
        cell.nextImageView1.kf.setImage(with: URL(string: gsno(places[indexPath.row].peripheries[0].firstimage)), placeholder: UIImage())
        cell.nextImageView2.kf.setImage(with: URL(string: gsno(places[indexPath.row].peripheries[1].firstimage)), placeholder: UIImage())
        cell.nextImageView3.kf.setImage(with: URL(string: gsno(places[indexPath.row].peripheries[2].firstimage)), placeholder: UIImage())
        cell.tag = indexPath.row
        
        if indexPath.row == 0 {
            cell.lineView.isHidden = true
        } else {
            cell.lineView.isHidden = false
        }
        
        if indexPath.row == places.count - 1 {
            cell.hiddenTimeLabel.isHidden = true
            cell.hiddenStackView.isHidden = true
        } else {
            cell.hiddenTimeLabel.isHidden = false
            cell.hiddenStackView.isHidden = false
            cell.carLabel.text = String("\(self.calculateCarTime(startLat: places[indexPath.row].latitude, startLong: places[indexPath.row].longitude, endLat: places[indexPath.row + 1].latitude, endLong: places[indexPath.row + 1].longitude))분")
        }
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let infoVC = UIStoryboard(name: "Course", bundle: nil).instantiateViewController(withIdentifier: "PlaceInfoViewController") as! PlaceInfoViewController
        
        infoVC.cid = cid
        infoVC.content = places[indexPath.row].description
        infoVC.num = String(places[indexPath.row].id)
        infoVC.restDay = gsno(places[indexPath.row].restDate)
        infoVC.parking = gsno(places[indexPath.row].parking)
        infoVC.infoCenter = gsno(places[indexPath.row].infoCenter)
        infoVC.imageUrl = gsno(places[indexPath.row].mainImageUrl)
        
        self.present(infoVC, animated: true, completion: nil)
    }
    
}

//MARK: - TMap extension
extension PlaceDetailViewController: TMapViewDelegate {
    
    func createTmapView() {
        tMapView = TMapView.init(frame: mapContainerView.bounds)
        
        guard let mapView = tMapView else {
            print("TMap을 생성하는데 실패하였습니다")
            return
        }

        let centerCoord = CLLocationCoordinate2D(latitude: places[0].latitude, longitude: places[0].longitude)
        mapView.zoom(toLatSpan: places[0].latitude, lonSpan: places[0].longitude)
        mapView.setCenter(centerCoord)
        mapView.setZoomLevel(7)
        
        mapView.setSKTMapApiKey(tMapKey)// 발급 받은 apiKey 설정
        mapContainerView.addSubview(mapView)
        mapView.delegate = self
        
        addMarker()
        addPolyLine()
    }
    
    func addMarker() {
        
        let mapPoint1 = TMapPoint(coordinate: CLLocationCoordinate2D(latitude: places[0].latitude, longitude: places[0].longitude))
        let marker1 = TMapMarkerItem()
        marker1.setTMapPoint(mapPoint1)
        marker1.setIcon(#imageLiteral(resourceName: "map_one_mark"), anchorPoint: CGPoint(x: 0.5, y: 1.0))
        marker1.enableClustering = true
        tMapView?.addTMapMarkerItemID("1", marker: marker1, animated: true)
        
        let mapPoint2 = TMapPoint(coordinate: CLLocationCoordinate2D(latitude:  places[1].latitude, longitude: places[1].longitude))
        let marker2 = TMapMarkerItem()
        marker2.setTMapPoint(mapPoint2)
        marker2.setIcon(#imageLiteral(resourceName: "map_two_mark"), anchorPoint: CGPoint(x: 0.5, y: 1.0))
        marker2.enableClustering = true
        tMapView?.addTMapMarkerItemID("22ㅇㄹㅁ", marker: marker2, animated: true)
        
        let mapPoint3 = TMapPoint(coordinate: CLLocationCoordinate2D(latitude: places[2].latitude, longitude: places[2].longitude))
        let marker3 = TMapMarkerItem()
        marker3.setTMapPoint(mapPoint3)
        marker3.setIcon(#imageLiteral(resourceName: "map_three_mark"), anchorPoint: CGPoint(x: 0.5, y: 1.0))
        marker3.enableClustering = true
        tMapView?.addTMapMarkerItemID("3", marker: marker3, animated: true)
        
        let mapPoint4 = TMapPoint(coordinate: CLLocationCoordinate2D(latitude: places[3].latitude, longitude: places[3].longitude))
        let marker4 = TMapMarkerItem()
        marker4.setTMapPoint(mapPoint4)
        marker4.setIcon(#imageLiteral(resourceName: "map_four_mark"), anchorPoint: CGPoint(x: 0.5, y: 1.0))
        marker4.enableClustering = true
        tMapView?.addTMapMarkerItemID("4", marker: marker4, animated: true)
    }
    
    func addPolyLine() {
        
        var array = [TMapPoint(coordinate: CLLocationCoordinate2D(latitude: places[0].latitude, longitude: places[0].longitude)), TMapPoint(coordinate: CLLocationCoordinate2D(latitude: places[1].latitude, longitude: places[1].longitude)), TMapPoint(coordinate: CLLocationCoordinate2D(latitude: places[2].latitude, longitude: places[2].longitude)), TMapPoint(coordinate: CLLocationCoordinate2D(latitude: places[3].latitude, longitude: places[3].longitude))]
        
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
