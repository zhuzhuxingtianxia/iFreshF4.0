//
//  ShopCarRedDotView.swift
//  iFreshF
//
//  Created by Jion on 16/4/14.
//  Copyright © 2016年 Youjuke. All rights reserved.
//

import UIKit

class ShopCarRedDotView: UIView {

    
    private static let instance = ShopCarRedDotView()
    
    class var sharedRedDotView: ShopCarRedDotView {
        return instance
    }
    
    private var numberLabel: UILabel?
    private var redImageView: UIImageView?
    var buyNumber: Int = 0 {
        didSet {
            if buyNumber == 0 {
                numberLabel?.text = ""
                isHidden = true
            }else {
                if buyNumber > 99 {
                    numberLabel?.font = UIFont.systemFont(ofSize: 8)
                }else {
                    numberLabel?.font = UIFont.systemFont(ofSize: 10)
                }
                
                isHidden = false
                numberLabel?.text = "\(buyNumber)"
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: CGRect(x:frame.origin.x, y:frame.origin.y, width:20, height:20))
        backgroundColor = UIColor.clear
        
        redImageView = UIImageView(image: UIImage(named: "reddot"))
        addSubview(redImageView!)
        
        numberLabel = UILabel()
        numberLabel!.font = UIFont.systemFont(ofSize: 10)
        numberLabel!.textColor = UIColor.white
        numberLabel?.textAlignment = NSTextAlignment.center
        addSubview(numberLabel!)
        
        isHidden = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        redImageView?.frame = bounds
        numberLabel?.frame = CGRect(x:0, y:0, width:width, height:height)
    }
    
    
    func addProductToRedDotView(animation: Bool) {
        buyNumber += 1
        if animation {
            redDotAnimation()
        }
    }
    func reduceProductToRedDotView(animation: Bool) {
        if buyNumber > 0 {
            buyNumber -= 1
        }
        
        if animation {
            redDotAnimation()
        }
    }
    
    private func redDotAnimation() {
        UIView.animate(withDuration: ShopCarRedDotAnimationDuration, animations: { 
            self.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            
            }) { (completion) in
                
                UIView.animate(withDuration: ShopCarRedDotAnimationDuration, animations: { 
                    self.transform = CGAffineTransform.identity
                    }, completion: nil)
        }
    }

}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 override func drawRect(rect: CGRect) {
 // Drawing code
 }
 */
