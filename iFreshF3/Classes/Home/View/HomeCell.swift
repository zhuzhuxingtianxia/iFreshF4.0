//
//  HomeCell.swift
//  iFreshF
//
//  Created by Jion on 16/4/21.
//  Copyright © 2016年 Youjuke. All rights reserved.
//

import UIKit

enum HomeCellType: Int {
    case Horizontal = 0
    case Vertical = 1
}

class HomeCell: UICollectionViewCell {
     //MARK: - 初始化子空间
    private lazy var backImageView: UIImageView = {
        let backImageView = UIImageView()
        return backImageView
    }()
    
    private lazy var goodsImageView: UIImageView = {
        let goodsImageView = UIImageView()
        goodsImageView.contentMode = UIViewContentMode.scaleAspectFit
        return goodsImageView
    }()
    
    private lazy var nameLabel: UILabel = {
      let nameLabel = UILabel()
        nameLabel.textAlignment = NSTextAlignment.left
        nameLabel.font = HomeCollectionTextFont
        nameLabel.textColor = UIColor.black
        return nameLabel
    }()
    
    private lazy var fineImageView:UIImageView = {
       let fineImageView = UIImageView()
        fineImageView.image = UIImage(named: "jingxuan.png")
        return fineImageView
    }()
    
    private lazy var giveImageView: UIImageView = {
        let giveImageView = UIImageView()
        giveImageView.image = UIImage(named: "buyOne.png")
        return giveImageView
    }()
    
    private lazy var specificsLabel: UILabel = {
        let specificsLabel = UILabel()
        specificsLabel.textColor = UIColor.colorWithRGB(r: 100, g: 100, b: 100)
        specificsLabel.font = UIFont.systemFont(ofSize: 12)
        specificsLabel.textAlignment = .left
        return specificsLabel
    }()
    private var discountPriceView: DiscountPriceView?
    
    private lazy var buyView: BuyView = {
      let buyView = BuyView()
        return buyView
    }()
    
    private var type: HomeCellType? {
        didSet {
            backImageView.isHidden = !(type == HomeCellType.Horizontal)
            goodsImageView.isHidden = (type == HomeCellType.Horizontal)
            nameLabel.isHidden = (type == HomeCellType.Horizontal)
            fineImageView.isHidden = (type == HomeCellType.Horizontal)
            giveImageView.isHidden = (type == HomeCellType.Horizontal)
            specificsLabel.isHidden = (type == HomeCellType.Horizontal)
            discountPriceView?.isHidden = (type == HomeCellType.Horizontal)
            buyView.isHidden = (type == HomeCellType.Horizontal)
        }
    }
    
    var addButtonClick:((_ imageView: UIImageView) -> ())?
    
     // MARK: - 便利构造方法
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white
        addSubview(backImageView)
        addSubview(goodsImageView)
        addSubview(nameLabel)
        addSubview(fineImageView)
        addSubview(giveImageView)
        addSubview(specificsLabel)
        addSubview(buyView)
        
        weak var tmpSelf = self
        buyView.clickAddShopCar = {
            if tmpSelf?.addButtonClick != nil {
                tmpSelf!.addButtonClick!(tmpSelf!.goodsImageView)
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
     // MARK: - 模型set方法
    var activities: Activities? {
        didSet {
            self.type = HomeCellType.Horizontal
            backImageView.sd_setImage(with: URL(string: activities!.img!), placeholderImage: UIImage(named: "v2_placeholder_full_size"))
            //backImageView.sd_setImageWithURL(NSURL(string: activities!.img!), placeholderImage: UIImage(named: "v2_placeholder_full_size"))
        }
    }
    
    var goods:Goods? {
        didSet {
            self.type = HomeCellType.Vertical
            goodsImageView.sd_setImage(with: URL(string: goods!.img!), placeholderImage: UIImage(named: "v2_placeholder_square"))
            //goodsImageView.sd_setImageWithURL(NSURL(string: goods!.img!), placeholderImage: UIImage(named: "v2_placeholder_square"))
            nameLabel.text = goods?.name
            if goods!.pm_desc == "买一赠一" {
                giveImageView.isHidden = false
            }else{
                giveImageView.isHidden = true
            }
            
            if discountPriceView != nil {
                discountPriceView!.removeFromSuperview()
            }
            discountPriceView = DiscountPriceView(price: goods?.price, marketPrice: goods?.market_price)
            addSubview(discountPriceView!)
            
            specificsLabel.text = goods?.specifics
            buyView.goods = goods
        }
    }
    
    //MARK:--布局
    override func layoutSubviews() {
        super.layoutSubviews()
        backImageView.frame = bounds
        goodsImageView.frame = CGRect(x:0, y:0, width:width, height:width)
        nameLabel.frame = CGRect(x:5, y:width, width:width - 15, height:20)
        fineImageView.frame = CGRect(x:5, y:nameLabel.frame.maxY, width:30, height:15)
        giveImageView.frame = CGRect(x:fineImageView.frame.maxX + 3, y:fineImageView.y, width:35, height:15)
        specificsLabel.frame = CGRect(x:nameLabel.x, y:fineImageView.frame.maxY, width:width, height:20)
        discountPriceView?.frame = CGRect(x:nameLabel.x, y:specificsLabel.frame.maxY, width:60, height:height - specificsLabel.frame.maxY)
        buyView.frame = CGRect(x:width - 85, y:height - 30, width:80, height:25)
    }
}



//end
