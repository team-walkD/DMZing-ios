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
        setBackBtn()
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let `self` = self else { return }
            self.getPlaceData(url: self.url("course/\(self.cid)/places"))
        }
    }

    func setTableView() {
        
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.rowHeight = UITableViewAutomaticDimension
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
                    for i in 0..<placeData_.count - 1 {
                        self.calculateCarTime(startLat: placeData_[i].latitude, startLong: placeData_[i].longitude, endLat: placeData_[i+1].latitude, endLong: placeData_[i+1].longitude, idx : i)
                    }
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
    func calculateCarTime(startLat : Double, startLong : Double, endLat : Double, endLong : Double, idx : Int){
        
        let version = 1
        let tollgateFareOption = 1
        let url = "http://api2.sktelecom.com/tmap/routes?version=\(version)&appKey=\(tMapKey)&tollgateFareOption=\(tollgateFareOption)&endX=\(endLong)&endY=\(endLat)&startX=\(startLong)&startY=\(startLat)"
        
        CalculateTimeService.shareInstance.calculateTimeToNext(url: url, params: [:], completion: { [weak self] (result) in
            
            guard let `self` = self else { return }
            switch result {
            case .networkSuccess(let data):
                guard let data_ = data as? CalculateTimeVO else {return}
                guard let time = data_.features.first?.properties.carTime else {return}
                self.places[idx].timeToNextPlace = time

            case .networkFail :
                self.networkSimpleAlert()
            default :
                self.simpleAlert(title: "오류", message: "다시 시도해주세요")
            }
        })
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
        cell.nextLabel1.text = places[indexPath.row].peripheries[0].title
        cell.nextLabel2.text = places[indexPath.row].peripheries[1].title
        cell.nextLabel3.text = places[indexPath.row].peripheries[2].title
        
        cell.nextImageView1.kf.setImage(with: URL(string: gsno(places[indexPath.row].peripheries[0].firstimage)), placeholder: UIImage())
        cell.nextImageView2.kf.setImage(with: URL(string: gsno(places[indexPath.row].peripheries[1].firstimage)), placeholder: UIImage())
        cell.nextImageView3.kf.setImage(with: URL(string: gsno(places[indexPath.row].peripheries[2].firstimage)), placeholder: UIImage())

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
            cell.carLabel.text = (gino(places[indexPath.row].timeToNextPlace)/60).description + "분"
        }
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let infoVC = UIStoryboard(name: "Course", bundle: nil).instantiateViewController(withIdentifier: "PlaceInfoViewController") as! PlaceInfoViewController
        
        infoVC.cid = cid
        infoVC.content = places[indexPath.row].description
        infoVC.num = String(indexPath.row + 1)
        infoVC.restDay = gsno(places[indexPath.row].restDate)
        infoVC.parking = gsno(places[indexPath.row].parking)
        infoVC.infoCenter = gsno(places[indexPath.row].infoCenter)
        infoVC.imageUrl = gsno(places[indexPath.row].mainImageUrl)
        infoVC.name = gsno(places[indexPath.row].title)
        
        self.navigationController?.pushViewController(infoVC, animated: true)
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
        mapView.setZoomLevel(9)
        
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
