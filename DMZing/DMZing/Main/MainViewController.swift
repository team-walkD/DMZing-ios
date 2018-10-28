//
//  ViewController.swift
//  DMZing
//
//  Created by 장한솔 on 2018. 10. 21..
//  Copyright © 2018년 장용범. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var themeCollectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        themeCollectionView.delegate = self
        themeCollectionView.dataSource = self


        setupNavBar()
        
    }
    
    
    func setupNavBar(){
        self.navigationController?.navigationBar.barTintColor = ColorChip.shared().lightBlue
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }


}

extension MainViewController : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
           return 7
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
            let cell = self.themeCollectionView.dequeueReusableCell(withReuseIdentifier: "ThemeCollectionViewCell", for: indexPath) as! ThemeCollectionViewCell
            
            cell.titleLabel.text = "theme\(indexPath.row)"
            cell.backView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        
            return cell
    
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
        
//        let selectedCell = self.themeCollectionView.cellForItem(at: indexPath) as! ThemeCollectionViewCell
//        selectedCell.backView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        
    }
    
    
    
}

