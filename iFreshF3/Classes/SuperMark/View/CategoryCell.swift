//
//  CategoryCell.swift
//  iFreshF
//
//  Created by Jion on 16/5/9.
//  Copyright © 2016年 Youjuke. All rights reserved.
//

import UIKit

class CategoryCell: UITableViewCell {

    private static let identifier = "CategoryCell"
     // MARK: Lazy Property
    private lazy var nameLabel: UILabel = {
       let nameLabel = UILabel()
        nameLabel.textColor = LFBTextGreyColol
        nameLabel.highlightedTextColor = UIColor.black
        nameLabel.backgroundColor = UIColor.clear
        nameLabel.textAlignment = NSTextAlignment.center
        nameLabel.font = UIFont.systemFont(ofSize: 14)
        return nameLabel
        
    }()
    
    private lazy var backImageView: UIImageView = {
        let backImageView = UIImageView()
        backImageView.image = UIImage(named: "llll")
        backImageView.highlightedImage = UIImage(named: "kkkkkkk")
        return backImageView
    }()
    
    private lazy var yellowView: UIView = {
       let yellowView = UIView()
        yellowView.backgroundColor = LFBNavigationYellowColor
        return yellowView
        
    }()
    private lazy var lineView: UIView = {
       let lineView = UIView()
        lineView.backgroundColor = UIColor.colorWithRGB(r: 225, g: 225, b: 225)
        return lineView
    }()
    
    // MARK: 模型setter方法
    var categorie: Categorie? {
        didSet {
            nameLabel.text = categorie?.name
        }
    }
    
    class func cellWithTableView(tableView: UITableView) -> CategoryCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? CategoryCell
        if cell == nil {
            cell = CategoryCell(style: .default, reuseIdentifier: identifier)
        }
        cell?.selectionStyle = UITableViewCellSelectionStyle.none
        return cell!
    }

    //MARK: init
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(backImageView)
        addSubview(lineView)
        addSubview(yellowView)
        addSubview(nameLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        nameLabel.frame = bounds
        backImageView.frame = CGRect(x:0, y:0, width:width, height:height)
        yellowView.frame = CGRect(x:0, y:height * 0.1, width:5, height:height * 0.8)
        lineView.frame = CGRect(x:0, y:height - 1, width:width, height:1)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        nameLabel.isHighlighted = selected
        backImageView.isHighlighted = selected
        yellowView.isHidden = !selected
        // Configure the view for the selected state
    }

}
