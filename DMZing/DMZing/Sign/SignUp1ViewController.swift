//
//  SignUp1ViewController.swift
//  DMZing
//
//  Created by 장한솔 on 2018. 11. 1..
//  Copyright © 2018년 장용범. All rights reserved.
//

import UIKit

class SignUp1ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavBar()
    }

    func setupNavBar(){
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func nextAction(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "SignUp2ViewController") as! SignUp2ViewController
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    

}
