//
//  AnswerCell.swift
//  iFreshF
//
//  Created by Jion on 16/5/30.
//  Copyright © 2016年 Youjuke. All rights reserved.
//

import UIKit

class AnswerCell: UITableViewCell {

    static private let identifier: String = "cellID"
    private let lineView = UIView()
    private lazy var labelText: UILabel = {
        let texLabel = UILabel()
        texLabel.numberOfLines = 0
        texLabel.textColor = UIColor.gray
        texLabel.font = UIFont.systemFont(ofSize: 14)
        return texLabel
        
    }()
    
    var question: Question? {
        didSet {
            
            labelText.frame = CGRect(x:20, y:5, width:ZJScreenWidth - 40, height:question!.cellHeight)
            var text: String = ""
            for i in 0..<question!.texts!.count {

                if i == question!.texts!.count - 1 {
                    text += question!.texts![i]
                }else{
                    text += (question!.texts![i] + "\n\n")
                }
            }
             labelText.text = text
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = UITableViewCellSelectionStyle.none
        lineView.alpha = 0.25
        lineView.backgroundColor = UIColor.gray
        contentView.addSubview(lineView)
        contentView.addSubview(labelText)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    class func answerCell(tableView: UITableView) -> AnswerCell {
        
    var cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? AnswerCell
    if cell == nil {
         cell = AnswerCell(style: UITableViewCellStyle.default, reuseIdentifier: identifier)
        }
        
        return cell!
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        lineView.frame = CGRect(x:20, y:0, width:width - 40, height:0.5)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
