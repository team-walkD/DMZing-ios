//
//  MypageVC.swift
//  DMZing
//
//  Created by 강수진 on 2018. 10. 24..
//  Copyright © 2018년 장용범. All rights reserved.
//

import UIKit

class MypageVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var profileImgView: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var courseCntLbl: UILabel!
    @IBOutlet weak var reviewCntLbl: UILabel!
    @IBOutlet weak var pointCntLbl: UILabel!
    let cellTitleArr = ["FnQ", "설정 및 관리"]
    
    @IBAction func settingAction(_ sender: Any) {
        
    }
    
    @IBAction func mailMoreAction(_ sender: Any) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        // Do any additional setup after loading the view.
    }
    
    func setupTableView(){
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView(frame : .zero)
    }
    
}

extension MypageVC : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellTitleArr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MyPageTVCell.reuseIdentifier) as! MyPageTVCell
        cell.configure(data : cellTitleArr[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0{
            //FnQ로 이동
        } else {
            //설정 및 관리로 이동
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
