//
//  OrderStatusCell.swift
//  iFreshF
//
//  Created by Jion on 16/5/26.
//  Copyright © 2016年 Youjuke. All rights reserved.
//

import UIKit

enum OrderStateType: Int {
    case Top = 0
    case Middle = 1
    case Bottom = 2
}

class OrderStatusCell: UITableViewCell {

    private var timeLabel: UILabel?
    private var titleLabel: UILabel?
    private var subTitleLable: UILabel?
    private var circleButton: UIButton?
    private var topLineView: UIView?
    private var bottomLineView: UIView?
    
    private var lineView: UIView?
    
    var orderStatus: OrderStatus? {
        didSet {
            timeLabel?.text = orderStatus?.status_time
            titleLabel?.text = orderStatus?.status_title
            subTitleLable?.text = orderStatus?.status_desc
            if (orderStatus?.status_desc?.characters.count)! > 0 {
                let tmpStr = (orderStatus?.status_desc)! as NSString
                if tmpStr.length > 10 {
                    let str = tmpStr.substring(to: 5) as NSString
                    if str.isEqual(to: "下单成功，") {
                        let mutableStr = NSMutableString(string: tmpStr)
                        mutableStr.insert("\n ", at: 9)
                        subTitleLable?.text = mutableStr as String
                    }
                }
            }

        }
    }
    
    var orderStateType: OrderStateType? {
        didSet {
            switch orderStateType!.hashValue {
            case OrderStateType.Top.hashValue:
                circleButton?.isSelected = true
                titleLabel?.textColor = UIColor.black
                bottomLineView?.isHidden = false
                topLineView?.isHidden = true
                lineView?.isHidden = false
                
                break
            case OrderStateType.Middle.hashValue:
                circleButton?.isSelected = false
                titleLabel?.textColor = UIColor.colorWithRGB(r: 100, g: 100, b: 100)
                bottomLineView?.isHidden = false
                topLineView?.isHidden = false
                lineView?.isHidden = false
                
                break
            case OrderStateType.Bottom.hashValue:
                bottomLineView?.isHidden = true
                topLineView?.isHidden = false
                lineView?.isHidden = true
                titleLabel?.textColor = UIColor.colorWithRGB(r: 100, g: 100, b: 100)
                circleButton?.isSelected = false
                
                break
            default: break
            }

        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = UITableViewCellSelectionStyle.none
        
        let textColor = UIColor.colorWithRGB(r: 100, g: 100, b: 100)
        
        timeLabel = UILabel()
        timeLabel?.textColor = textColor
        timeLabel?.textAlignment = NSTextAlignment.center
        timeLabel?.font = UIFont.systemFont(ofSize: 12)
        contentView.addSubview(timeLabel!)
        
        circleButton = UIButton(type: UIButtonType.custom)
        circleButton?.isUserInteractionEnabled = false
        circleButton?.setBackgroundImage(UIImage(named: "order_grayMark"), for: UIControlState.normal)
        circleButton?.setBackgroundImage(UIImage(named: "order_yellowMark"), for: UIControlState.selected)
        contentView.addSubview(circleButton!)
        
        topLineView = UIView()
        topLineView?.backgroundColor = textColor
        topLineView?.alpha = 0.3
        contentView.addSubview(topLineView!)
        
        bottomLineView = UIView()
        bottomLineView?.backgroundColor = textColor
        bottomLineView?.alpha = 0.3
        contentView.addSubview(bottomLineView!)
        
        titleLabel = UILabel()
        titleLabel?.textColor = textColor
        titleLabel?.font = UIFont.systemFont(ofSize: 15)
        contentView.addSubview(titleLabel!)
        
        subTitleLable = UILabel()
        subTitleLable?.textColor = textColor
        subTitleLable?.font = UIFont.systemFont(ofSize: 12)
        subTitleLable?.numberOfLines = 0
        contentView.addSubview(subTitleLable!)
        
        lineView = UIView()
        lineView?.backgroundColor = textColor
        lineView?.alpha = 0.2
        contentView.addSubview(lineView!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private static let identifier = "orderStatusCell"
    class func orderStatusCell(tableView: UITableView) -> OrderStatusCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? OrderStatusCell
        if cell == nil {
            cell = OrderStatusCell(style: UITableViewCellStyle.default, reuseIdentifier: identifier)
        }
        
        return cell!
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        let margin: CGFloat = 15
        timeLabel?.frame = CGRect(x:margin, y:12, width:35, height:20)
        circleButton?.frame = CGRect(x:timeLabel!.frame.maxX + 10, y:15, width:15, height:15)
        topLineView?.frame = CGRect(x:(circleButton?.center.x)! - 1, y:0, width:2, height:15)
        bottomLineView?.frame = CGRect(x:(circleButton?.center.x)! - 1, y:circleButton!.frame.maxY, width:2, height:height - circleButton!.frame.maxY)
        
        titleLabel?.frame = CGRect(x:circleButton!.frame.maxX + 20, y:12, width:width - circleButton!.frame.maxX - 20, height:20)
        subTitleLable?.frame = CGRect(x:titleLabel!.x, y:titleLabel!.frame.maxY + 10, width:width - titleLabel!.frame.origin.x, height:30)
        lineView?.frame = CGRect(x:titleLabel!.x, y:height - 1, width:width - titleLabel!.x, height:1)
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
