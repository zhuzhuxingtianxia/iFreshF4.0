//
//  MyOrderCell.swift
//  iFreshF
//
//  Created by Jion on 16/5/25.
//  Copyright © 2016年 Youjuke. All rights reserved.
//

import UIKit

@objc protocol MyOrderCellDelegate: NSObjectProtocol {
    @objc optional func orderCellButtonDidClick(indexPath: NSIndexPath, buttonType: Int)
}

class MyOrderCell: UITableViewCell {

    private var timeLabel: UILabel?
    private var statusTextLabel: UILabel?
    private var lineView1: UIView?
    private var goodsImageViews: OrderImageViews?
    private var lineView2: UIView?
    private var productNumsLabel: UILabel?
    private var productsPriceLabel: UILabel?
    private var payLabel: UILabel?
    private var lineView3: UIView?
    private var buttons: OrderButtons?
    private var indexPath: NSIndexPath?
    weak var delegate: MyOrderCellDelegate?
    
    var order: Order? {
        didSet {
            timeLabel?.text = order?.create_time
            statusTextLabel?.text = order?.textStatus
            goodsImageViews?.order_goods = order?.order_goods
            productNumsLabel?.text = "共" + "\(order!.buy_num)" + "件商品"
            productsPriceLabel?.text = "$" + (order!.user_pay_amount)!
            buttons?.buttons = order?.buttons
        }
    }
   
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = UITableViewCellSelectionStyle.none
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.white
        
        timeLabel = UILabel()
        timeLabel?.font = UIFont.systemFont(ofSize: 13)
        timeLabel?.textColor = UIColor.black
        contentView.addSubview(timeLabel!)
        
        statusTextLabel = UILabel()
        statusTextLabel?.textAlignment = NSTextAlignment.right
        statusTextLabel?.font = timeLabel?.font
        statusTextLabel?.textColor = UIColor.red
        contentView.addSubview(statusTextLabel!)
        
        lineView1 = UIView()
        lineView1?.backgroundColor = UIColor.lightGray
        lineView1?.alpha = 0.1
        contentView.addSubview(lineView1!)
        
        goodsImageViews = OrderImageViews()
        contentView.addSubview(goodsImageViews!)
        
        lineView2 = UIView()
        lineView2?.backgroundColor = UIColor.lightGray
        lineView2?.alpha = 0.1
        contentView.addSubview(lineView2!)
        
        productNumsLabel = UILabel()
        productNumsLabel?.textColor = UIColor.gray
        productNumsLabel?.textAlignment = NSTextAlignment.right
        productNumsLabel?.font = timeLabel?.font
        contentView.addSubview(productNumsLabel!)
        
        payLabel = UILabel()
        payLabel?.text = "实付:"
        payLabel?.textColor = UIColor.gray
        payLabel?.font = productNumsLabel?.font
        contentView.addSubview(payLabel!)
        
        productsPriceLabel = UILabel()
        productsPriceLabel?.textColor = UIColor.black
        productsPriceLabel?.textAlignment = NSTextAlignment.right
        productsPriceLabel?.font = payLabel?.font
        productsPriceLabel?.textColor = UIColor.gray
        contentView.addSubview(productsPriceLabel!)
        
        lineView3 = UIView()
        lineView3?.backgroundColor = UIColor.lightGray
        lineView3?.alpha = 0.1
        contentView.addSubview(lineView3!)
        
        weak var tmpSelf = self
        buttons = OrderButtons(frame: CGRect.zero, buttonClickCallBack: { (type) in
            if tmpSelf?.delegate != nil {
                if tmpSelf!.delegate!.responds(to: #selector(MyOrderCellDelegate.orderCellButtonDidClick(indexPath:buttonType:))) {
                    
                    tmpSelf!.delegate!.orderCellButtonDidClick!(indexPath: tmpSelf!.indexPath!, buttonType: type)
                }
            }

        })
        buttons?.backgroundColor = UIColor.white
        contentView.addSubview(buttons!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static private let identifier = "OrderCell"
    class func myOrderCell(tableView: UITableView, indexPath: NSIndexPath) -> MyOrderCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? MyOrderCell
        
        if cell == nil {
            cell = MyOrderCell(style: .default, reuseIdentifier: identifier)
        }
        cell?.indexPath = indexPath
        return cell!
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let margin: CGFloat = 10
        let topViewHeight: CGFloat = 30
        contentView.frame = CGRect(x:0, y:0, width:width, height:height - 20)
        timeLabel?.frame = CGRect(x:margin, y:0, width:ZJScreenWidth, height:topViewHeight)
        statusTextLabel?.frame = CGRect(x:ZJScreenWidth - 150, y:0, width:140, height:topViewHeight)
        lineView1?.frame = CGRect(x:margin, y:topViewHeight, width:ZJScreenWidth - margin, height:1)
        goodsImageViews?.frame = CGRect(x:0, y:topViewHeight, width:width, height:65)
        lineView2?.frame = CGRect(x:margin, y:goodsImageViews!.frame.maxY, width:width - margin, height:1)
        productsPriceLabel?.frame = CGRect(x:width - margin - 60, y:goodsImageViews!.frame.maxY, width:60, height:topViewHeight)
        payLabel?.frame = CGRect(x:width - 70 - 20, y:productsPriceLabel!.y, width:40, height:topViewHeight)
        productNumsLabel?.frame = CGRect(x:width - 220, y:productsPriceLabel!.y, width:100, height:topViewHeight)
        lineView3?.frame = CGRect(x:margin, y:payLabel!.frame.maxY, width:width - margin, height:1)
        buttons?.frame = CGRect(x:0, y:productNumsLabel!.frame.maxY, width:width, height:40)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

/////////////////////////////////////////
class OrderImageViews: UIView {
    
    var imageViews: UIView?
    var arrowImageView: UIImageView?
    var order_goods: [[OrderGoods]]? {
        didSet {
            let imageViewsSubViews = imageViews?.subviews
            for subView in imageViewsSubViews! {
                subView.isHidden = true
            }
            for i in 0..<order_goods!.count {
                if i < 4 {
                    let subImageView = imageViewsSubViews![i] as! UIImageView
                    subImageView.isHidden = false
                    subImageView.sd_setImage(with: URL(string: order_goods![i][0].img!), placeholderImage: UIImage(named: "author"))
                    //subImageView.sd_setImageWithURL(NSURL(string: order_goods![i][0].img!), placeholderImage: UIImage(named: "author"))
                }else{
                    let subImageView = imageViewsSubViews![4]
                    subImageView.isHidden = false

                }
                
            }
            
            
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        imageViews = UIView(frame: CGRect(x:0,y:5,width:ZJScreenWidth - 15,height:55))
        for i in 0...4 {
            let imageView = UIImageView(frame: CGRect(x:CGFloat(i) * 60 + 10, y:0, width:55, height:55))
            if 4 == i {
                imageView.image = UIImage(named: "v2_goodmore")
            }
            
            imageView.contentMode = UIViewContentMode.scaleAspectFit
            imageView.isHidden = true
            imageViews?.addSubview(imageView)
        }
        addSubview(imageViews!)
        arrowImageView = UIImageView(image: UIImage(named: "icon_go"))
        arrowImageView?.frame = CGRect(x:ZJScreenWidth - 15, y:(65 - arrowImageView!.bounds.size.height) * 0.5, width:arrowImageView!.bounds.size.width, height:arrowImageView!.bounds.size.height)
        addSubview(arrowImageView!)
        
    }
    convenience init(frame: CGRect ,order_goods: [[OrderGoods]]) {
        self.init(frame: frame)
        self.order_goods = order_goods
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

/////////////////////////////////////////
class OrderButtons: UIView {
    
    var buttonClickCallBack: ((_ type: Int) -> ())?
    var buttons: [OrderButton]? {
        didSet {
            for subView in subviews {
                subView.removeFromSuperview()
            }
            
            let btnW: CGFloat = 60
            let btnH: CGFloat = 26
            
            for j in 0..<buttons!.count {
                
                let btn = UIButton(frame: CGRect(x:0 ,y:0 , width:btnW, height:btnH))
                btn.tag = j
                btn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
                btn.setTitleColor(UIColor.black, for: .normal)
                btn.layer.masksToBounds = true
                btn.layer.cornerRadius = 5
                btn.backgroundColor = LFBNavigationYellowColor
                btn.setTitle(buttons![j].text, for: UIControlState.normal)
                btn.addTarget(self, action: #selector(OrderButtons.orderButtonClick(sender:)), for: UIControlEvents.touchUpInside)
                addSubview(btn)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)

    }
    
    convenience init(frame: CGRect, buttonClickCallBack:@escaping ((_ type: Int) -> ())) {
        self.init(frame:frame)
        self.buttonClickCallBack = buttonClickCallBack
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        for i in 0..<subviews.count {
            let subBtnView = subviews[i]
            subBtnView.frame.origin.x = ZJScreenWidth - CGFloat(i + 1) * (subBtnView.width + 10) - 5
            subBtnView.frame.origin.y = (self.height - subBtnView.height) * 0.5
        }
    }
    
    @objc func orderButtonClick(sender: UIButton) {
        if buttonClickCallBack != nil {
            buttonClickCallBack!(buttons![sender.tag].type)
        }
    }
}



