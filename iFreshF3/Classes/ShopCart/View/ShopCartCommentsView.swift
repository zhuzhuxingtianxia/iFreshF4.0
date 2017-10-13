//
//  ShopCartCommentsView.swift
//  iFreshF
//
//  Created by Jion on 16/5/12.
//  Copyright © 2016年 Youjuke. All rights reserved.
//

import UIKit

class ShopCartCommentsView: UIView {

    var textField = UITextField()
    private let signCommentsLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.white
        
        addSubview(lineView(frame: CGRect(x:10, y:0, width:ZJScreenWidth - 10, height:0.5)))
        
        signCommentsLabel.text = "收货备注"
        signCommentsLabel.textColor = UIColor.black
        signCommentsLabel.font = UIFont.systemFont(ofSize: 15)
        signCommentsLabel.sizeToFit()
        signCommentsLabel.frame = CGRect(x:15, y:0, width:signCommentsLabel.width, height:ShopCartRowHeight)
        addSubview(signCommentsLabel)
        
        textField.placeholder = "可输入100字以内特殊要求内容"
        textField.frame = CGRect(x:signCommentsLabel.frame.maxX + 10, y:10, width:ZJScreenWidth - signCommentsLabel.frame.maxX - 10 - 20, height:ShopCartRowHeight - 20)
        textField.font = UIFont.systemFont(ofSize: 15)
        textField.borderStyle = UITextBorderStyle.roundedRect
        textField.autocorrectionType = UITextAutocorrectionType.no
        textField.autocapitalizationType = UITextAutocapitalizationType.none
        textField.returnKeyType = UIReturnKeyType.done
        textField.delegate = self
        addSubview(textField)
        
        addSubview(lineView(frame: CGRect(x:0, y:ShopCartRowHeight - 0.5, width:ZJScreenWidth, height:0.5)))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func lineView(frame: CGRect) -> UIView {
        let lineView = UIView(frame: frame)
        lineView.backgroundColor = UIColor.black
        lineView.alpha = 0.1
        return lineView
    }


}
extension ShopCartCommentsView:UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 override func drawRect(rect: CGRect) {
 // Drawing code
 }
 */
