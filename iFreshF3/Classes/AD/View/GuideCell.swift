//
//  GuideCell.swift
//  iFreshF
//
//  Created by Jion on 16/4/11.
//  Copyright © 2016年 Youjuke. All rights reserved.
//

import UIKit

class GuideCell: UICollectionViewCell {
    private let newImageView = UIImageView(frame: ZJScreenBounds)
    private let nextButton = UIButton(frame: CGRect(x:(ZJScreenWidth - 100) * 0.5, y:ZJScreenHeight - 110, width:100, height:33))
    
    var newImage:UIImage? {
        didSet {
            newImageView.image = newImage
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //ScaleToFill 和控件一样大。ScaleAspectFit按比例填充最大的一边不超过控件。 ScaleAspectFill按比例填充最小的一边不超过控件
        newImageView.contentMode = UIViewContentMode.scaleAspectFill
        newImageView.layer.masksToBounds = true
        contentView.addSubview(newImageView)
        
        nextButton.setBackgroundImage(UIImage(named: "icon_next"), for: UIControlState.normal)
        nextButton.addTarget(self, action: #selector(GuideCell.nextButtonClick), for: UIControlEvents.touchUpInside)
        nextButton.isHidden = true
        contentView.addSubview(nextButton)
    }
    func setNextButtonHidden(hidden: Bool) {
        nextButton.isHidden = hidden
    }

    @objc func nextButtonClick()  {
       
         NotificationCenter.default.post(name: NSNotification.Name(rawValue: GuideViewControllerDidFinish), object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
