//
//  ChatbotVC.swift
//  DMZing
//
//  Created by 강수진 on 2018. 11. 22..
//  Copyright © 2018년 장용범. All rights reserved.
//

import UIKit

class ChatbotVC: UIViewController {
   
    var content = ["워크디에게 뭐든 물어봐! \n  뭐가 궁금해?"]  {
        didSet {
            tableView.reloadData()
        }
    }
//    @IBAction func myBtnAction(_ sender: Any) {
//        content.append("DMZ의 맛집 정보가 궁금해")
//    }

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
  
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
    }
}

extension ChatbotVC : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return content.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row % 2 == 0 {
            let walkDCell = tableView.dequeueReusableCell(withIdentifier: WalkDTVCell.reuseIdentifier) as! WalkDTVCell
            walkDCell.textLbl.text = content[indexPath.row]
            return walkDCell
        }  else {
            let myChatCell = tableView.dequeueReusableCell(withIdentifier: MyChatTVCell.reuseIdentifier) as! MyChatTVCell
            myChatCell.textLbl.text = content[indexPath.row]
            return myChatCell
        }
    }
}

extension ChatbotVC : UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChatbotCVCell.reuseIdentifier, for: indexPath) as! ChatbotCVCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
}

