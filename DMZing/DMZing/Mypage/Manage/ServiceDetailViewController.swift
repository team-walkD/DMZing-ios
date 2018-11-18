//
//  ServiceDetailViewController.swift
//  DMZing
//
//  Created by 장한솔 on 2018. 11. 18..
//  Copyright © 2018년 장용범. All rights reserved.
//

import UIKit

class ServiceDetailViewController: UIViewController {

    @IBOutlet weak var contentTextView: UITextView!
    var titlevalue : String = ""
    var contentvalue : String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackBtn()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = self.titlevalue
        contentTextView.text = self.contentvalue
    }

    @IBAction func cancelAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    


}
