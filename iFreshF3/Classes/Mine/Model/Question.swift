//
//  Question.swift
//  iFreshF
//
//  Created by Jion on 16/5/30.
//  Copyright © 2016年 Youjuke. All rights reserved.
//

import UIKit

class Question: NSObject {

    var title: String?
    var everyRowHeight: [CGFloat] = []
    var cellHeight: CGFloat = 0
    var texts: [String]? {
        didSet {
            let maxSize = CGSize(width:ZJScreenWidth - 40, height:10000)
            for i in 0..<texts!.count {
                let str = texts![i] as NSString
                let rowHeight: CGFloat = str.boundingRect(with: maxSize, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14)], context: nil).size.height + 15
                cellHeight += rowHeight
                everyRowHeight.append(rowHeight)
            }
        }
    }
    
    class func question(dict: NSDictionary) -> Question {
        let question = Question()
        question.title = dict.object(forKey: "title") as? String
        question.texts = dict.object(forKey: "texts") as? [String]
        
        return question
    }
    
    class func loadQuestions(complete: (([Question]) -> ())) {
        let path = Bundle.main.path(forResource: "HelpPlist", ofType: "plist")
        let array = NSArray(contentsOfFile: path!)
        
        var questions: [Question] = []
        if array != nil {
            for dic in array! {
                questions.append(Question.question(dict: dic as! NSDictionary))
            }
        }
        complete(questions)
    }

}
