//
//  HelpDetailViewController.swift
//  iFreshF
//
//  Created by Jion on 16/5/30.
//  Copyright © 2016年 Youjuke. All rights reserved.
//

import UIKit

class HelpDetailViewController: BaseViewController {

     var questionTableView: LFBTableView?
     var questions: [Question]?
     var isOpenCell = [Bool]()
     var lastOpenIndex = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "常见问题"
        view.backgroundColor = UIColor.white
        
        buildQuestionTableView()
        loadHelpData()
    }

    private func buildQuestionTableView(){
        questionTableView = LFBTableView(frame: view.bounds, style: UITableViewStyle.plain)
        questionTableView?.frame.size.height -= Navigation
        questionTableView?.backgroundColor = UIColor.white
        questionTableView?.register(HelpHeadView.self, forHeaderFooterViewReuseIdentifier: "headView")
        questionTableView?.sectionHeaderHeight = 50
        questionTableView?.delegate = self
        questionTableView?.dataSource = self
        view.addSubview(questionTableView!)
    }
    
    private func loadHelpData() {
        weak var tmpSelf = self
        
        Question.loadQuestions { (questions) -> () in
            for _ in questions {
                let newbool = false
              tmpSelf?.isOpenCell.append(newbool)
            }
            
            tmpSelf!.questions = questions
            tmpSelf!.questionTableView?.reloadData()
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}

extension HelpDetailViewController: UITableViewDelegate, UITableViewDataSource,HelpHeadViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return questions?.count ?? 0
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "headView") as? HelpHeadView
        headView!.tag = section
        headView?.delegate = self
        let question = questions![section]
        headView?.question = question
        headView?.isSelected = isOpenCell[section]
        return headView!
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isOpenCell[section] {
           return 1
        }
        return 0
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if isOpenCell[indexPath.section] {
            return questions![indexPath.section].cellHeight + 5
        }
        
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = AnswerCell.answerCell(tableView: tableView)
        cell.question = questions![indexPath.section]
        return cell
    }
    
  //MARK:--HelpHeadViewDelegate
    func headViewDidClck(headView: HelpHeadView) {
        isOpenCell[headView.tag] = !isOpenCell[headView.tag]
        questionTableView?.reloadSections(NSIndexSet(index: headView.tag) as IndexSet, with: UITableViewRowAnimation.automatic)
    }
}

/*
 // MARK: - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
 // Get the new view controller using segue.destinationViewController.
 // Pass the selected object to the new view controller.
 }
 */
