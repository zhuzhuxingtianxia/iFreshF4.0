//
//  MineHeadView.swift
//  iFreshF
//
//  Created by Jion on 16/4/20.
//  Copyright © 2016年 Youjuke. All rights reserved.
//

import UIKit

class MineHeadView: UIImageView {

    let setUpBtn:UIButton = UIButton(type: UIButtonType.custom)
    let iconView: IconView = IconView()
    var buttonClick:(() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        image = UIImage(named: "v2_my_avatar_bg")
        setUpBtn.setImage(UIImage(named: "v2_my_settings_icon"), for: UIControlState.normal)
        setUpBtn.addTarget(self, action: #selector(MineHeadView.setUpButtonClick), for: UIControlEvents.touchUpInside)

        addSubview(setUpBtn)
        addSubview(iconView)
        self.isUserInteractionEnabled = true
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        let statusRect = UIApplication.shared.statusBarFrame
        let iconViewWH: CGFloat = 150
        iconView.frame = CGRect(x:(width - iconViewWH) * 0.5, y:statusRect.maxY+20, width:iconViewWH, height:iconViewWH)
        
        setUpBtn.frame = CGRect(x:width - 50, y:statusRect.maxY, width:50, height:40)
    }
    //重载
    convenience init(frame: CGRect, settingButtonClick:@escaping (() -> Void)) {
        self.init(frame: frame)
        buttonClick = settingButtonClick
    }
    @objc func setUpButtonClick()  {
        buttonClick?()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

}

class IconView: UIView {
    
    var iconImageView: UIImageView!
    var phoneNum: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        iconImageView = UIImageView(image: UIImage(named: "v2_my_avatar"))
        addSubview(iconImageView)
        
        phoneNum = UILabel()
        phoneNum.textColor = UIColor.white
        phoneNum.font = UIFont.boldSystemFont(ofSize: 18)
        phoneNum.textAlignment = NSTextAlignment.center
        addSubview(phoneNum)
        UserInfo.sharedUserInfo.isLogin = true
        headerIcon()
        
        NotificationCenter.default.addObserver(self, selector: #selector(IconView.headerIcon), name: NSNotification.Name(rawValue: "headerIcon"), object: nil)
    }
    
    @objc func headerIcon() {
        
        if (UserInfo.sharedUserInfo.isLogin == true) {
            iconImageView.image = UIImage(named: "author")
            iconImageView.layer.cornerRadius = iconImageView.size.width/2
            iconImageView.layer.masksToBounds = true
            phoneNum.text = "18612348765"
        }else{
            iconImageView.image = UIImage(named: "v2_my_avatar")
            phoneNum.text = "未登录"
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        iconImageView.frame = CGRect(x:(width - iconImageView.size.width) * 0.5, y:0, width:iconImageView.size.width, height:iconImageView.size.height)
        
        phoneNum.frame = CGRect(x:0, y:iconImageView.frame.maxY + 5, width:width, height:30)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 override func drawRect(rect: CGRect) {
 // Drawing code
 }
 */
