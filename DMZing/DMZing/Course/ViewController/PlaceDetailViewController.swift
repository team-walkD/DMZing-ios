//
//  PlaceDetailViewController.swift
//  DMZing
//
//  Created by 김예은 on 15/11/2018.
//  Copyright © 2018 장용범. All rights reserved.
//

import UIKit

class PlaceDetailViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var mapContainerView: UIView!
    @IBOutlet weak var navi: UINavigationBar!
    
    private var tMapView: TMapView? = nil
    
    var expandedRows = Set<Int>()
    var initialTouchPoint: CGPoint = CGPoint(x: 0, y: 0)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTableView()
        setNavigationBar()
        createTmapView()
    
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

//MARK: - TableView extension
extension PlaceDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlaceDetailTableViewCell") as! PlaceDetailTableViewCell
        
        cell.placeLabel.text = "평화 전망대"
        cell.amLabel.text = "8:00"
        cell.pmLabel.text = "7:00"
        cell.busLabel.text = "20분"
        cell.walkLabel.text = "30분"
        cell.carLabel.text = "10분"
        cell.nextLabel1.text = "맛집"
        cell.nextLabel2.text = "포토존"
        cell.nextLabel3.text = "산책로"
        cell.isExpanded = self.expandedRows.contains(indexPath.row)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let cell = tableView.cellForRow(at: indexPath) as? PlaceDetailTableViewCell else { return }

        switch cell.isExpanded {
            
            case true:
                self.expandedRows.remove(indexPath.row)
            
            case false:
                self.expandedRows.insert(indexPath.row)
            
        }
        
        cell.isExpanded = !cell.isExpanded
        
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
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
        
        let minLat: Double = 37.5536067
        let maxLat: Double = 37.5662952
        let minLon: Double = 126.96961950000002
        let maxLon: Double = 126.97794509999994
        let centerCoord = CLLocationCoordinate2D(latitude: (minLat + maxLat) / 2, longitude: (minLon + maxLon) / 2)
        
        
        mapView.zoom(toLatSpan: maxLat - minLat, lonSpan: maxLon - minLon)
        mapView.setCenter(centerCoord)
        
        mapView.setZoomLevel(12)
        
        
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
        marker1.setIcon(#imageLiteral(resourceName: "heart_fill_icon.png"), anchorPoint: CGPoint(x: 0.5, y: 1.0))
        
        marker1.enableClustering = true
        tMapView?.addTMapMarkerItemID("1", marker: marker1, animated: true)
        
        let mapPoint1 = TMapPoint(coordinate: CLLocationCoordinate2D(latitude: 37.5536067, longitude: 126.96961950000002))
        let marker2 = TMapMarkerItem()
        marker2.setTMapPoint(mapPoint1)
        marker2.setIcon(#imageLiteral(resourceName: "heart_fill_icon.png"), anchorPoint: CGPoint(x: 0.5, y: 1.0))
        
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
