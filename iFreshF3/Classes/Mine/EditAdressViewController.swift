//
//  EditAdressViewController.swift
//  iFreshF
//
//  Created by Jion on 16/5/27.
//  Copyright © 2016年 Youjuke. All rights reserved.
//

import UIKit

enum EditAdressViewControllerType: Int {
    case Add
    case Edit
}

class EditAdressViewController: BaseViewController {

    private let deleteView = UIView()
    private let scrollView = UIScrollView()
    private let adressView = UIView()
    private var contactsTextField: UITextField?
    private var phoneNumberTextField: UITextField?
    private var cityTextField: UITextField?
    private var areaTextField: UITextField?
    private var adressTextField: UITextField?
    private var manButton: LeftImageRightTextButton?
    private var womenButton: LeftImageRightTextButton?
    private var selectCityPickView: UIPickerView?
    var currentSelectedCityIndex = 0
    weak var topVC: MyAdressViewController?
    var vcType: EditAdressViewControllerType?
    var currentAdressRow: Int = -1
   
    lazy var cityArray: [String]? = {
        let array = ["北京市", "上海市", "天津市", "广州市", "佛山市", "深圳市", "廊坊市", "武汉市", "苏州市", "无锡市"]
        return array
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()

         buildNavigationItem()
        
        buildScrollView()
        
        buildAdressView()
        
        buildDeleteAdressView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.barTintColor = LFBNavigationBarWhiteBackgroundColor
        
        if currentAdressRow != -1 && vcType == .Edit {
            let adress = topVC!.adresses![currentAdressRow]
            contactsTextField?.text = adress.accept_name
            if adress.telphone?.characters.count == 11 {
                let telphone = adress.telphone! as NSString
                phoneNumberTextField?.text = telphone.substring(with: NSMakeRange(0, 3)) + " " + telphone.substring(with: NSMakeRange(3, 4)) + " " + telphone.substring(with: NSMakeRange(7, 4))
            }else{
                phoneNumberTextField?.text = adress.telphone
            }
                        
            if adress.gender == "1" {
                manButton?.isSelected = true
            } else {
                womenButton?.isSelected = true
            }
            cityTextField?.text = adress.city_name
            let range = (adress.address! as NSString).range(of: " ")
            areaTextField?.text = (adress.address! as NSString).substring(to: range.location)
            adressTextField?.text = (adress.address! as NSString).substring(from: range.location + 1)
            
            deleteView.isHidden = false
        }
        
    }

    // MARK: - Method
    private func buildNavigationItem() {
        
        navigationItem.title = "修改地址"
        
        let rightItemButton = UIBarButtonItem.barButton(title: "保存", titleColor: UIColor.lightGray, target: self, action: #selector(EditAdressViewController.saveButtonClick))
        navigationItem.rightBarButtonItem = rightItemButton
    }
    
    private func buildScrollView() {
        scrollView.frame = view.bounds
        scrollView.backgroundColor = UIColor.clear
        scrollView.alwaysBounceVertical = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissMode.onDrag
        view.addSubview(scrollView)
    }

    private func buildAdressView() {
        adressView.frame = CGRect(x:0, y:10, width:view.width, height:300)
        adressView.backgroundColor = UIColor.white
        scrollView.addSubview(adressView)
        
        let viewHeight: CGFloat = 50
        let leftMargin: CGFloat = 15
        let labelWidth: CGFloat = 70
        buildUnchangedLabel(frame: CGRect(x:leftMargin, y:0, width:labelWidth, height:viewHeight), text: "联系人")
        buildUnchangedLabel(frame: CGRect(x:leftMargin, y:2 * viewHeight, width:labelWidth, height:viewHeight), text: "手机号码")
        buildUnchangedLabel(frame: CGRect(x:leftMargin, y:3 * viewHeight, width:labelWidth, height:viewHeight), text: "所在城市")
        buildUnchangedLabel(frame: CGRect(x:leftMargin, y:4 * viewHeight, width:labelWidth, height:viewHeight), text: "所在地区")
        buildUnchangedLabel(frame: CGRect(x:leftMargin, y:5 * viewHeight, width:labelWidth, height:viewHeight), text: "详细地址")
        
        let lineView = UIView(frame: CGRect(x:leftMargin, y:49, width:view.width - 10, height:1))
        lineView.alpha = 0.15
        lineView.backgroundColor = UIColor.lightGray
        adressView.addSubview(lineView)
        
        let textFieldWidth = view.width * 0.6
        let x = leftMargin + labelWidth + 10
        contactsTextField = UITextField()
        buildTextField(textField: contactsTextField!, frame: CGRect(x:x, y:0, width:textFieldWidth, height:viewHeight), placeholder: "收货人姓名", tag: 1)
        
        phoneNumberTextField = UITextField()
        buildTextField(textField: phoneNumberTextField!, frame: CGRect(x:x, y:2 * viewHeight, width:textFieldWidth, height:viewHeight), placeholder: "鲜蜂侠联系你的电话", tag: 2)
        
        cityTextField = UITextField()
        buildTextField(textField: cityTextField!, frame: CGRect(x:x, y:3 * viewHeight, width:textFieldWidth, height:viewHeight), placeholder: "请选择城市", tag: 3)
        
        areaTextField = UITextField()
        buildTextField(textField: areaTextField!, frame: CGRect(x:x, y:4 * viewHeight, width:textFieldWidth, height:viewHeight), placeholder: "请选择你的住宅,大厦或学校", tag: 4)
        
        adressTextField = UITextField()
        buildTextField(textField: adressTextField!, frame: CGRect(x:x, y:5 * viewHeight, width:textFieldWidth, height:viewHeight), placeholder: "请输入楼号门牌号等详细信息", tag: 5)
        
        manButton = LeftImageRightTextButton()
        buildGenderButton(button: manButton!, frame: CGRect(x:phoneNumberTextField!.frame.minX, y:50, width:100, height:50), title: "先生", tag: 101)
        
        womenButton = LeftImageRightTextButton()
        buildGenderButton(button: womenButton!, frame: CGRect(x:manButton!.frame.maxX + 10, y:50, width:100, height:50), title: "女士", tag: 102)


    }
    
    private func buildUnchangedLabel(frame: CGRect, text: String) {
        let label = UILabel(frame: frame)
        label.text = text
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = LFBTextBlackColor
        adressView.addSubview(label)
        
        let lineView = UIView(frame: CGRect(x:15, y:frame.origin.y - 1, width:view.width - 10, height:1))
        lineView.alpha = 0.15
        lineView.backgroundColor = UIColor.lightGray
        adressView.addSubview(lineView)
    }

    private func buildTextField(textField: UITextField, frame: CGRect, placeholder: String, tag: Int) {
        textField.frame = frame
        
        if 2 == tag {
//            textField.keyboardType = UIKeyboardType.NumberPad
        }
        
        if 3 == tag {
            selectCityPickView = UIPickerView()
            selectCityPickView!.delegate = self
            selectCityPickView!.dataSource = self
            textField.inputView = selectCityPickView
            textField.inputAccessoryView = buildInputView()
        }
        
        textField.tag = tag
        textField.returnKeyType = UIReturnKeyType.done
        textField.autocorrectionType = UITextAutocorrectionType.no
        textField.autocapitalizationType = UITextAutocapitalizationType.none
        textField.placeholder = placeholder
        textField.font = UIFont.systemFont(ofSize: 15)
        textField.delegate = self
        textField.textColor = LFBTextBlackColor
        adressView.addSubview(textField)
    }

    private func buildGenderButton(button: LeftImageRightTextButton, frame: CGRect, title: String, tag: Int) {
        button.tag = tag
        button.setImage(UIImage(named: "v2_noselected"), for: UIControlState.normal)
        button.setImage(UIImage(named: "v2_selected"), for: UIControlState.selected)
        button.addTarget(self, action: #selector(EditAdressViewController.genderButtonClick(sender:)), for: .touchUpInside)
        button.setTitle(title, for: UIControlState.normal)
        button.frame = frame
        button.setTitleColor(LFBTextBlackColor, for: .normal)
        adressView.addSubview(button)
    }
    
    private func buildInputView() -> UIView {
        let toolBar = UIView(frame: CGRect(x:0, y:0, width:view.width, height:40))
        toolBar.backgroundColor = UIColor.white
        
        let lineView = UIView(frame: CGRect(x:0, y:0, width:view.width, height:1))
        lineView.backgroundColor = UIColor.black
        lineView.alpha = 0.1
        toolBar.addSubview(lineView)
        
        let titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 15)
        titleLabel.textColor = UIColor.lightGray
        titleLabel.alpha = 0.8
        titleLabel.text = "选择城市"
        titleLabel.textAlignment = NSTextAlignment.center
        titleLabel.frame = CGRect(x:0, y:0, width:view.width, height:toolBar.height)
        toolBar.addSubview(titleLabel)
        
        let cancleButton = UIButton(frame: CGRect(x:0, y:0, width:80, height:toolBar.height))
        cancleButton.tag = 10
        cancleButton.addTarget(self, action: #selector(EditAdressViewController.selectedCityTextFieldDidChange(sender:)), for: .touchUpInside)
        cancleButton.setTitle("取消", for: .normal)
        cancleButton.setTitleColor(UIColor.colorWithRGB(r: 82, g: 188, b: 248), for: .normal)
        toolBar.addSubview(cancleButton)
        
        let determineButton = UIButton(frame: CGRect(x:view.width - 80, y:0, width:80, height:toolBar.height))
        determineButton.tag = 11
        determineButton.addTarget(self, action: #selector(EditAdressViewController.selectedCityTextFieldDidChange(sender:)), for: .touchUpInside)
        determineButton.setTitleColor(UIColor.colorWithRGB(r: 82, g: 188, b: 248), for: .normal)
        determineButton.setTitle("确定", for: .normal)
        toolBar.addSubview(determineButton)
        
        return toolBar
    }

    
    private func buildDeleteAdressView() {
        deleteView.frame = CGRect(x:0, y:adressView.frame.maxY + 10, width:view.width, height:50)
        deleteView.backgroundColor = UIColor.white
        scrollView.addSubview(deleteView)
        
        let deleteLabel = UILabel(frame: CGRect(x:0, y:0, width:view.width, height:50))
        deleteLabel.text = "删除当前地址"
        deleteLabel.textAlignment = NSTextAlignment.center
        deleteLabel.font = UIFont.systemFont(ofSize: 15)
        deleteView.addSubview(deleteLabel)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(EditAdressViewController.deleteViewClick))
        deleteView.addGestureRecognizer(tap)
        deleteView.isHidden = true
    }


    // MARK: - Action
    @objc func saveButtonClick() {
        if (contactsTextField?.text?.characters.count)! <= 1 {
            ProgressHUDManager.showImage(image: UIImage(named: "v2_orderSuccess")!, status: "我们需要你的大名~")
            return
        }
        
        if !manButton!.isSelected && !womenButton!.isSelected {
            ProgressHUDManager.showImage(image: UIImage(named: "v2_orderSuccess")!, status: "人妖么,不男不女的~")
            return
        }
        
        if phoneNumberTextField!.text?.cleanSpace().characters.count != 11 {
            ProgressHUDManager.showImage(image: UIImage(named: "v2_orderSuccess")!, status: "没电话,特么怎么联系你~")
            return
        }
        
        if (cityTextField?.text?.characters.count)! <= 0 {
            ProgressHUDManager.showImage(image: UIImage(named: "v2_orderSuccess")!, status: "你在哪个城市啊~空空的~")
            return
        }
        
        if (areaTextField?.text?.characters.count)! <= 2 {
            ProgressHUDManager.showImage(image: UIImage(named: "v2_orderSuccess")!, status: "你的位置啊~")
            return
        }
        
        if (adressTextField?.text?.characters.count)! <= 2 {
            ProgressHUDManager.showImage(image: UIImage(named: "v2_orderSuccess")!, status: "在哪里呢啊~上哪找你去啊~")
            return
        }

        if vcType == .Add {
            let adress = Adress()
            setAdressModel(adress: adress)
            if topVC?.adresses?.count == 0 || topVC?.adresses == nil {
                topVC?.adresses = []
            }
            
            topVC!.adresses!.insert(adress, at: 0)
        }
        
        if vcType == .Edit {
            let adress = topVC!.adresses![currentAdressRow]
            setAdressModel(adress: adress)
        }
        
        _ = navigationController?.popViewController(animated: true)
        topVC?.adressTableView?.reloadData()
    }
    
    private func setAdressModel(adress: Adress) {
        adress.accept_name = contactsTextField!.text
        adress.telphone = phoneNumberTextField!.text
        adress.gender = manButton!.isSelected ? "1" : "2"
        adress.city_name = cityTextField!.text
        adress.address = areaTextField!.text! + " " + adressTextField!.text!
    }

    
    @objc func genderButtonClick(sender: UIButton) {
        
        switch sender.tag {
        case 101:
            manButton?.isSelected = true
            womenButton?.isSelected = false
            break
        case 102:
            manButton?.isSelected = false
            womenButton?.isSelected = true
            break
        default:
            break
        }
    }
    
    @objc func selectedCityTextFieldDidChange(sender: UIButton) {
        
        if sender.tag == 11 {
            if currentSelectedCityIndex != -1 {
                cityTextField?.text = cityArray![currentSelectedCityIndex]
            }
        }
        cityTextField!.endEditing(true)
    }


    @objc func deleteViewClick() {
        topVC!.adresses!.remove(at: currentAdressRow)
       _ = navigationController?.popViewController(animated: true)
        topVC?.adressTableView?.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

extension EditAdressViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let rightItemButton = UIBarButtonItem.barButton(title: "保存", titleColor: UIColor.blue, target: self, action: #selector(EditAdressViewController.saveButtonClick))
        navigationItem.rightBarButtonItem = rightItemButton
        
        if textField.tag == 2 {
            //通过range来判断字符串是增加还是减少
            if textField.text?.characters.count == 13 {
                if range.length == 1 {
                    return true
                }
                return false
                
            } else {
                if range.length == 0 {
                    if textField.text?.characters.count == 3 || textField.text?.characters.count == 8 {
                        textField.text = textField.text! + " "
                    }
                }
                
                return true
            }
        }
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }

}

extension EditAdressViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return cityArray!.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return cityArray![row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        currentSelectedCityIndex = row
    }
    
}


/*
 // MARK: - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
 // Get the new view controller using segue.destinationViewController.
 // Pass the selected object to the new view controller.
 }
 */
