//
//  ShopCartCell.swift
//  iFreshF
//
//  Created by Jion on 16/5/13.
//  Copyright © 2016年 Youjuke. All rights reserved.
//

import UIKit

class ShopCartCell: UITableViewCell {

    private let titleLabel = UILabel()
    private let priceLabel = UILabel()
    private let buyView    = BuyView()
    
    var goods:Goods? {
        didSet {
            if goods?.is_xf == 1 {
                titleLabel.text = "[精选]" + goods!.name!
            }else{
                titleLabel.text = goods?.name
            }
            
            priceLabel.text = "$" + goods!.price!.cleanDecimalPointZero()
            buyView.goods = goods
        }
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = UITableViewCellSelectionStyle.none
        
        titleLabel.frame = CGRect(x:15, y:0, width:ZJScreenWidth * 0.5, height:ShopCartRowHeight)
        titleLabel.font = UIFont.systemFont(ofSize: 15)
        titleLabel.textColor = UIColor.black
        contentView.addSubview(titleLabel)
        
        buyView.frame = CGRect(x:ZJScreenWidth - 85, y:(ShopCartRowHeight - 25) * 0.55, width:80, height:25)
        contentView.addSubview(buyView)
        
        priceLabel.frame = CGRect(x:buyView.frame.minX - 100 - 5, y:0, width:100, height:ShopCartRowHeight)
        priceLabel.textAlignment = NSTextAlignment.right
        contentView.addSubview(priceLabel)
        
        let lineView = UIView(frame: CGRect(x:10,y:ShopCartRowHeight - 0.5,width:ZJScreenWidth - 10, height:0.5))
        lineView.backgroundColor = UIColor.black
        lineView.alpha = 0.1
        contentView.addSubview(lineView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    static private let identifier = "ShopCarCell"
    
    class func shopCarCell(tableView: UITableView) -> ShopCartCell {
       var cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? ShopCartCell
        if cell == nil {
            cell = ShopCartCell(style: UITableViewCellStyle.default, reuseIdentifier: identifier)
        }
        
        return cell!
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
