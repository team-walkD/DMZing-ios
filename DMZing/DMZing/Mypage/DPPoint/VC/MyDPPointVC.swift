//
//  MyDPPointVC.swift
//  DMZing
//
//  Created by 강수진 on 2018. 10. 24..
//  Copyright © 2018년 장용범. All rights reserved.
//

import UIKit

class MyDPPointVC: UIViewController, APIService {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var myDPLbl: UILabel!
    var dpArr : [MypageDPVOHistory] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupNavBar()
        setBackBtn()
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let `self` = self else { return }
            self.getDPData(url: self.url("users/dp"))
        }
    }
    
    func setupTableView(){
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView(frame : .zero)
    }
    
    func setupNavBar(){
        navigationController?.navigationBar.barTintColor = UIColor.FlatColor.Blue.lightBlue
    }

}

extension MyDPPointVC : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dpArr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MyDPPointTVCell.reuseIdentifier) as! MyDPPointTVCell
        guard dpArr.count > 0 else {
            return cell
        }
        cell.configure(data: dpArr[indexPath.row])
        return cell
    }
}

extension MyDPPointVC {
    func getDPData(url : String){
        MypageDPService.shareInstance.getMainData(url: url,completion: { [weak self] (result) in
            guard let `self` = self else { return }
            switch result {
            case .networkSuccess(let data):
                guard let dpData = data as? MypageDPVO else {return}
                self.myDPLbl.text = dpData.totalDP.description
                self.dpArr = dpData.dpHistoryDtos
            case .networkFail :
                self.networkSimpleAlert()
            default :
                self.simpleAlert(title: "오류", message: "다시 시도해주세요")
                break
            }
        })
    }
}
