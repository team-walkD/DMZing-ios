//
//  MyDPPointVC.swift
//  DMZing
//
//  Created by 강수진 on 2018. 10. 24..
//  Copyright © 2018년 장용범. All rights reserved.
//

import UIKit

class MyDPPointVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupNavBar()
        setBackBtn()
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
        return 20
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MyDPPointTVCell.reuseIdentifier) as! MyDPPointTVCell

        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
