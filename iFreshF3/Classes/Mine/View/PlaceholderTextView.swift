//
//  PlaceholderTextView.swift
//  iFreshF
//
//  Created by Jion on 16/5/31.
//  Copyright © 2016年 Youjuke. All rights reserved.
//

import UIKit

class PlaceholderTextView: UITextView {

    var placeholder: String? {
        didSet {
            placeholderLabel.text = placeholder
            updatePlaceholderLabelSize()
        }
    }
    
    override var font: UIFont? {
        willSet {
            super.font = font
            
            placeholderLabel.font = newValue
            updatePlaceholderLabelSize()
        }
    }

    var placeholderColor: UIColor? {
        didSet {
            placeholderLabel.textColor = placeholderColor
        }
    }
    override var text: String? {
        willSet {
            super.text = text
            textDidChange()
        }
    }
    
    override var attributedText: NSAttributedString? {
        willSet {
            super.attributedText = attributedText
            textDidChange()
        }
    }

    private lazy var placeholderLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.frame.origin.x = 4
        label.frame.origin.y = 7
        return label
    }()
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        addSubview(placeholderLabel)
        placeholderColor = UIColor.gray
        placeholderLabel.alpha = 0.6
        self.font = placeholderLabel.font
        
        NotificationCenter.default.addObserver(self, selector: #selector(PlaceholderTextView.textDidChange), name: NSNotification.Name.UITextViewTextDidChange, object: nil)
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func textDidChange() {
        self.placeholderLabel.isHidden = hasText
    }

    func updatePlaceholderLabelSize() {
        let maxSize = CGSize(width:bounds.size.width - 2 * placeholderLabel.frame.origin.x, height:100000)
        if placeholder != nil {
            placeholderLabel.frame.size = (placeholder! as NSString).boundingRect(with: maxSize, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font : placeholderLabel.font as AnyObject], context: nil).size
            placeholderLabel.backgroundColor = UIColor.clear
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
