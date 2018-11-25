//
//  ChatbotVC.swift
//  DMZing
//
//  Created by 강수진 on 2018. 11. 22..
//  Copyright © 2018년 장용범. All rights reserved.
//

import UIKit

class ChatbotVC: UIViewController, APIService {
    
   
    //collectionView 에 대분류 / 중분류 데이터 뿌림 판단 위한 변수
    var isMajor = true
    //마지막거 뿌려줄지 말지에 대한 변수
    var isFinal = false
    var selectedMajor = ""
    var selectedMiddle = ""
    var majorData : [MajorChatVOResult] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    var middleData : [MiddleChatVOResult] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    var subData : [SubChatVOResult] = []{
        didSet {
            tableView.reloadData()
        }
    }
   
    var content = ["워크디에게 뭐든 물어봐! \n뭐가 궁금해?"]  {
        didSet {
            tableView.reloadData()
        }
    }

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var bottomGrayView: UIView!
    @IBOutlet weak var collectionViewHeightConstraint: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        collectionView.delegate = self
        collectionView.dataSource = self
        getMajorData(url: url("", isChatbot: true))
    }

    
    func openSafari(url : String){
        if let url = URL(string: url) {
            UIApplication.shared.open(url, options: [:])
        }
    }
    @IBAction func touchFirstTap(_ sender: UIView) {
        let url = subData[0].webURL
       openSafari(url: url)
    }
    
    @IBAction func touchSecondTap(_ sender: UIView) {
       let url = subData[1].webURL
        openSafari(url: url)
    }
    
    @IBAction func touchThirdTap(_ sender: UIView) {
       let url = subData[2].webURL
        openSafari(url: url)
    }
    
    @IBAction func dismissAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension ChatbotVC : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isFinal ? content.count + 1 : content.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if isFinal && indexPath.row == content.count {
            let linkTVCell = tableView.dequeueReusableCell(withIdentifier: LinkTableViewCell.reuseIdentifier) as! LinkTableViewCell
            guard subData.count > 0 else {return linkTVCell}
            linkTVCell.configure(data : subData, selectedMajor : selectedMajor, selectedMiddle : selectedMiddle)
            return linkTVCell
        } else if indexPath.row % 2 == 0 {
            let walkDCell = tableView.dequeueReusableCell(withIdentifier: WalkDTVCell.reuseIdentifier) as! WalkDTVCell
            walkDCell.textLbl.text = content[indexPath.row]
            return walkDCell
        } else {
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
        if isMajor {
           return majorData.count
        } else {
            return middleData.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChatbotCVCell.reuseIdentifier, for: indexPath) as! ChatbotCVCell
        if isMajor {
            guard majorData.count > 0 else {return cell}
            cell.titleLbl.text = majorData[indexPath.row].description
            
        } else {
            guard middleData.count > 0 else {return cell}
            cell.titleLbl.text = middleData[indexPath.row].description
            
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isMajor {
            content.append("\(majorData[indexPath.row].description)이 궁금해")
            selectedMajor = majorData[indexPath.row].description
            getMiddleData(url: url("division/\(majorData[indexPath.row].groups)", isChatbot: true), desc : majorData[indexPath.row].description)
        } else {
            content.append("\(middleData[indexPath.row].description) 관련 장소에 대해 알려줘")
            selectedMiddle = middleData[indexPath.row].description
            getSubData(url: url("section/\(middleData[indexPath.row].id)", isChatbot: true), desc : middleData[indexPath.row].description)
        }

    }
}

extension ChatbotVC {
    func getMajorData(url : String){
        GetMajorChatService.shareInstance.getMajorData(url: url,completion: { [weak self] (result) in
            guard let `self` = self else { return }
            switch result {
            case .networkSuccess(let data):
                guard let chatMajorData = data as? MajorChatVO else {return}
                self.majorData = chatMajorData.result
            case .networkFail :
                self.networkSimpleAlert()
            default :
                self.simpleAlert(title: "오류", message: "다시 시도해주세요")
                break
            }
        })
    }
    
    func getMiddleData(url : String, desc : String){
        GetMiddleChatService.shareInstance.getMiddleData(url: url,completion: { [weak self] (result) in
            guard let `self` = self else { return }
            switch result {
            case .networkSuccess(let data):
                guard let chatMiddleData = data as? MiddleChatVO else {return}
                self.content.append("\(desc)대해 알려줄게!\n어떤 정보를 알려줄까?")
                self.isMajor = false
                self.middleData = chatMiddleData.result
            case .networkFail :
                self.networkSimpleAlert()
            default :
                self.simpleAlert(title: "오류", message: "다시 시도해주세요")
                break
            }
        })
    }
    
    func getSubData(url : String, desc : String){
        GetSubChatService.shareInstance.getSubData(url: url,completion: { [weak self] (result) in
            guard let `self` = self else { return }
            switch result {
            case .networkSuccess(let data):
                guard let chatSubData = data as? SubChatVO else {return}
                self.content.append("\(desc) 관련 장소들이야! 필요할땐 언제든 워크디를 찾아줘 :D")
                self.isFinal = true
                self.subData = chatSubData.result
                self.collectionViewHeightConstraint.constant = 0
                self.bottomGrayView.backgroundColor = UIColor.FlatColor.Blue.lightBlue
            case .networkFail :
                self.networkSimpleAlert()
            default :
                self.simpleAlert(title: "오류", message: "다시 시도해주세요")
                break
            }
        })
    }
}

