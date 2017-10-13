//
//  IconImageTextView.swift
//  iFreshF
//
//  Created by Jion on 16/5/5.
//  Copyright © 2016年 Youjuke. All rights reserved.
//

import UIKit
import SDWebImage
class IconImageTextView: UIView {

    private var imageView: UIImageView?
    private var textLabel: UILabel?
    private var placeholderImage: UIImage?
    
    var activitie: Activities? {
        didSet {
            textLabel?.text = activitie?.name
            imageView?.sd_setImage(with: URL(string:activitie!.img!), placeholderImage: placeholderImage)
            //imageView?.sd_setImageWithURL(NSURL(string: activitie!.img!), placeholderImage: placeholderImage)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView = UIImageView()
        imageView?.isUserInteractionEnabled = false
        imageView?.contentMode = UIViewContentMode.scaleAspectFit
        addSubview(imageView!)
        
        textLabel = UILabel()
        textLabel?.textAlignment = NSTextAlignment.center
        textLabel?.font = UIFont.systemFont(ofSize: 12)
        textLabel?.textColor = UIColor.black
        textLabel?.isUserInteractionEnabled = false
        addSubview(textLabel!)
    }
    
    convenience init(frame: CGRect, placeholderImage: UIImage) {
        self.init(frame:frame)
        self.placeholderImage = placeholderImage
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageView?.frame = CGRect(x:5, y:5, width:width - 15, height:height - 30)
        textLabel?.frame = CGRect(x:5, y:height - 25, width:imageView!.width, height:20)
    }

}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 override func drawRect(rect: CGRect) {
 // Drawing code
 }
 */
