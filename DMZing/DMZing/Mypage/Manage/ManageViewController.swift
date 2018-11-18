//
//  ManageViewController.swift
//  DMZing
//
//  Created by 장한솔 on 2018. 11. 18..
//  Copyright © 2018년 장용범. All rights reserved.
//

import UIKit

class ManageViewController: UIViewController {

    @IBOutlet weak var serviceInfoView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(goserviceinfo))
        serviceInfoView.addGestureRecognizer(tapGesture)
    }
    
    @objc func goserviceinfo(){
        let vc = UIStoryboard(name: "Mypage", bundle: nil).instantiateViewController(withIdentifier: "ServiceInfoViewController") as! ServiceInfoViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func logoutAction(_ sender: Any) {
    }
    @IBAction func leaveAction(_ sender: Any) {
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
