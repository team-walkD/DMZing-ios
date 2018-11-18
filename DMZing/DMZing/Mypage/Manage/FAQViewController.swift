//
//  FNQViewController.swift
//  DMZing
//
//  Created by 장한솔 on 2018. 11. 18..
//  Copyright © 2018년 장용범. All rights reserved.
//

import UIKit

struct Question{
    var title: String
    var content: String
}

class FAQViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var questions = [Question]()
    
    @IBOutlet weak var tableView: UITableView!
    var selectedCell: FAQTableViewCell? = nil
    var selectedSection = 0
    var selectedCellRow = -1
    var expandedCells   = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView(frame : .zero)
        
        let q1 = Question(title: "디엠징은 어떤 앱인가요?", content: "'디엠징(DMZING)’은 디엠지라는 특수한 지역을 대상으로, 맵과 챗봇을 통해 정보를 얻거나, 미션을 통해 즐거움 얻을 수 있도록 하는 관광 어플리케이션 입니다.")
        let q2 = Question(title: "dp는 어떻게 사용하는 건가요?", content: "지정된 장소에서 편지를 찾으면 DP(DMZING Point)가 제공됩니다. 해당 DP를 이용하여 잠겨있는 맵을 구매할 수 있습니다")
        let q3 = Question(title: "편지 미션참여는 어떻게 할 수 있나요?", content: "기본으로 제공되거나 구매한 맵을 메인화면에서 선택하면 편지 장소에 대한 힌트를 볼 수 있습니다. 해당 장소에서 편지 찾기 버튼을 클릭하면 미션에 참여할 수 있습니다.")
        questions.append(q1)
        questions.append(q2)
        questions.append(q3)

    }
    
    @IBAction func cancelAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FAQTableViewCell") as! FAQTableViewCell
        
        cell.titleLabel.text = questions[indexPath.row].title
        cell.contentLabel.text = questions[indexPath.row].content
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCell = tableView.cellForRow(at: indexPath) as? FAQTableViewCell
        selectedSection = indexPath.section
        selectedCellRow = indexPath.row
        if self.expandedCells.contains(indexPath) {
            self.expandedCells.remove(indexPath)
        }
        else{
            self.expandedCells.add(indexPath)
        }
        
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if selectedCell != nil && selectedSection == indexPath.section && selectedCellRow == indexPath.row {
            if self.expandedCells.contains(indexPath) {
                let tempTextView = selectedCell!.contentLabel
                var frame: CGRect
                
                //                tempTextView?.text = arr[indexPath.section][indexPath.row].t2
                frame = tempTextView!.frame
                frame.size.height = tempTextView!.intrinsicContentSize.height+15
                tempTextView!.frame = frame
                
                return 75 + frame.size.height
            }else{
                return 50
                
            }
        }else{
            return 50
            
        }
    }

    

}
