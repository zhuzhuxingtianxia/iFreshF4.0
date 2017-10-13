//
//  ShopCartViewController.swift
//  iFreshF
//
//  Created by Jion on 16/4/13.
//  Copyright © 2016年 Youjuke. All rights reserved.
//

import UIKit

class ShopCartViewController: BaseViewController {

    let userShopCar = UserShopCarTool.sharedUserShopCar
    
    private let shopImageView         = UIImageView()
    private let emptyLabel            = UILabel()
    private let emptyButton           = UIButton(type: .custom)
    private let supermarketTableView  = LFBTableView(frame: CGRect(x:0, y:0,width: ZJScreenWidth, height:ZJScreenHeight - 64 - 50), style: .plain)
    private var tableHeadView         = UIView()
    private var receiptAdressView: ReceiptAddressView?
    private let signTimeField         = UITextField()
    private let reserveLabel          = UILabel()
    private let signTimePickerView    = UIPickerView()
    private let commentsView          = ShopCartCommentsView()
    private let tableFooterView       = ShopCartFooterView()
    private var isFristLoadData       = false
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
         addNSNotification()
         buildNavigationItem()
         buildEmptyUI()
    
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       
        if userShopCar.isEmpty() {
            showshopCarEmptyUI()
        }else{
            if !ProgressHUDManager.isVisible() {
                ProgressHUDManager.setBackgroundColor(color: UIColor.colorWithRGB(r: 230, g: 230, b: 230))
                ProgressHUDManager.showWithStatus(status: "正在加载...")
            }
            //GCD延时
            weak var weakSelf = self
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                ProgressHUDManager.dismiss()
                weakSelf?.showProductView()
            })
            //swift3.0写法
            /*
             //swift2.2写法
            let time = dispatch_time(DISPATCH_TIME_NOW, Int64(0.5 * Double(NSEC_PER_SEC)))
            dispatch_after(time, dispatch_get_main_queue(), { 
                ProgressHUDManager.dismiss()
                weakSelf?.showProductView()
            })
 */
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        view.endEditing(true)
    }
    deinit {
        //deinit是界面消失后才做的操作
         NotificationCenter.default.removeObserver(self)
    }
    // MARK - Add Notification KVO Action
    private func addNSNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(ShopCartViewController.shopCarBuyPriceDidChange), name: NSNotification.Name(rawValue: LFBShopCarBuyPriceDidChangeNotification), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ShopCartViewController.shopCarProductsDidRemove), name: NSNotification.Name(rawValue: LFBShopCarDidRemoveProductNSNotification), object: nil)
    }
    
    @objc func shopCarBuyPriceDidChange() {
        tableFooterView.priceLabel.text = UserShopCarTool.sharedUserShopCar.getAllProductsPrice()
    }
    @objc func shopCarProductsDidRemove() {
        
        if UserShopCarTool.sharedUserShopCar.isEmpty() {
            showshopCarEmptyUI()
        }
        
        self.supermarketTableView.reloadData()
    }
    
    // MARK: - Build UI
    private func buildNavigationItem() {
        navigationItem.title = "购物车"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem.barButton(image: UIImage(named: "v2_goback")!, target: self, action: #selector(ShopCartViewController.leftNavigitonItemClick))
    }
    //显示购物车
    private func showProductView() {
        
        if !isFristLoadData {
            
            isFristLoadData = true
            buildSupermarketTableView()
            
        }
    }
    private func buildSupermarketTableView() {
        
        supermarketTableView.delegate = self
        supermarketTableView.dataSource = self
        supermarketTableView.contentInset = UIEdgeInsetsMake(0, 0, 15, 0)
        supermarketTableView.rowHeight = ShopCartRowHeight
        supermarketTableView.backgroundColor = view.backgroundColor
        view.addSubview(supermarketTableView)
        
        buildTableHeadView()
        tableFooterView.frame = CGRect(x:0, y:ZJScreenHeight - 64 - 50, width:ZJScreenWidth, height:50)
        tableFooterView.delegate = self
        view.addSubview(tableFooterView)
    }
    
    private func buildTableHeadView() {
        tableHeadView.backgroundColor = view.backgroundColor
        tableHeadView.frame = CGRect(x:0, y:0, width:view.width, height:250)
        
        supermarketTableView.tableHeaderView = tableHeadView
        
        buildReceiptAddress()
        buildMarketView()
        buildSignTimeView()
        buildSignComments()
    }
    //发货地址
    private func buildReceiptAddress() {
        
         weak var tmpSelf = self
        receiptAdressView = ReceiptAddressView(frame: CGRect(x:0, y:10, width:view.width, height:70), modifyButtonClickCallBack: {
            //跳转到地址列表界面
            let adressVC = MyAdressViewController { (adress) in
                tmpSelf?.receiptAdressView?.adress = adress
            }
            adressVC.isSelectVC = true
           tmpSelf!.navigationController!.pushViewController(adressVC, animated: true)
        })
        tableHeadView.addSubview(receiptAdressView!)
        
        if UserInfo.sharedUserInfo.hasDefaultAdress() {
            receiptAdressView?.adress = UserInfo.sharedUserInfo.defaultAdress()
        }else{
            weak var tmpSelf = self
            AdressData.loadMyAdressData(completion: { (data, error) in
                if data != nil {
                    if (data!.data?.count)! > 0 {
                        UserInfo.sharedUserInfo.setAllAdress(adresses: data!.data!)
                        tmpSelf?.receiptAdressView?.adress = UserInfo.sharedUserInfo.defaultAdress()
                    }
                }
            })
        }
    }
    
    private func buildMarketView() {
        let markerView = ShopCartMarkerView(frame: CGRect(x:0, y:90, width:ZJScreenWidth, height:60))
        
        tableHeadView.addSubview(markerView)
    }
    //签署时间
    private func buildSignTimeView() {
        let signTimeView = UIView(frame: CGRect(x:0, y:150, width:view.width, height:ShopCartRowHeight))
        signTimeView.backgroundColor = UIColor.white
        tableHeadView.addSubview(signTimeView)
        
        let signTimeTitleLabel = UILabel()
        signTimeTitleLabel.text = "收货时间"
        signTimeTitleLabel.textColor = UIColor.black
        signTimeTitleLabel.font = UIFont.systemFont(ofSize: 15)
        signTimeTitleLabel.sizeToFit()
        signTimeTitleLabel.frame = CGRect(x:15, y:0, width:signTimeTitleLabel.width, height:ShopCartRowHeight)
        signTimeView.addSubview(signTimeTitleLabel)
        signTimeField.frame = CGRect(x:signTimeTitleLabel.frame.maxX + 10, y:0, width:view.width - 20 - signTimeTitleLabel.frame.maxX, height:ShopCartRowHeight)
        signTimeField.textColor = UIColor.red
        signTimeField.font = UIFont.systemFont(ofSize: 15)
        signTimeField.text = "闪电送,及时达"
        signTimeView.addSubview(signTimeField)
        
        let datePicker = UIDatePicker()
        datePicker.setDate(NSDate.distantPast, animated: true)
        signTimeField.inputView = datePicker
        signTimeField.inputAccessoryView = buildInputView()
//        let tap = UITapGestureRecognizer(target: self, action: #selector(ShopCartViewController.modifySignTimeViewClick))
//        signTimeLabel.userInteractionEnabled = true
//        signTimeLabel.addGestureRecognizer(tap)
        
        reserveLabel.text = "可预定"
        reserveLabel.backgroundColor = UIColor.white
        reserveLabel.textColor = UIColor.red
        reserveLabel.font = UIFont.systemFont(ofSize: 15)
        reserveLabel.frame = CGRect(x:view.width - 72, y:0, width:60, height:ShopCartRowHeight)
        signTimeView.addSubview(reserveLabel)
        
        let arrowImageView = UIImageView(image: UIImage(named: "icon_go"))
        arrowImageView.frame = CGRect(x:view.width - 15, y:(ShopCartRowHeight - arrowImageView.height) * 0.5, width:arrowImageView.width, height:arrowImageView.height)
        signTimeView.addSubview(arrowImageView)

    }
    private func buildInputView() -> UIView {
        let toolBar = UIToolbar(frame: CGRect(x:0, y:0, width:view.width, height:40))
        toolBar.backgroundColor = UIColor.white
        
        let lineView = UIView(frame: CGRect(x:0, y:0, width:view.width, height:1))
        lineView.backgroundColor = UIColor.black
        lineView.alpha = 0.1
        toolBar.addSubview(lineView)
        
        let titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 15)
        titleLabel.textColor = UIColor.lightGray
        titleLabel.alpha = 0.8
        titleLabel.text = "选择发货时间"
        titleLabel.textAlignment = NSTextAlignment.center
        titleLabel.frame = CGRect(x:0, y:0, width:view.width, height:toolBar.height)
        toolBar.addSubview(titleLabel)
        
        let cancleButton = UIButton(frame: CGRect(x:0, y:0, width:80, height:toolBar.height))
        cancleButton.tag = 10
        cancleButton.addTarget(self, action: #selector(ShopCartViewController.modifySignTimeViewClick(sender:)), for: .touchUpInside)
        cancleButton.setTitle("取消", for: .normal)
        cancleButton.setTitleColor(UIColor.colorWithRGB(r: 82, g: 188, b: 248), for: .normal)
        toolBar.addSubview(cancleButton)
        
        let determineButton = UIButton(frame: CGRect(x:view.width - 80, y:0, width:80, height:toolBar.height))
        determineButton.tag = 11
        determineButton.addTarget(self, action: #selector(ShopCartViewController.modifySignTimeViewClick(sender:)), for: .touchUpInside)
        determineButton.setTitleColor(UIColor.colorWithRGB(r: 82, g: 188, b: 248), for: .normal)
        determineButton.setTitle("确定", for: .normal)
        toolBar.addSubview(determineButton)
        
        return toolBar
    }

    //签署意见
    private func buildSignComments() {
        commentsView.frame = CGRect(x:0, y:200, width:view.width, height:ShopCartRowHeight)
        tableHeadView.addSubview(commentsView)
    }
    
    private func buildEmptyUI() {
        shopImageView.image = UIImage(named: "v2_shop_empty")
        shopImageView.contentMode = UIViewContentMode.center
        shopImageView.frame = CGRect(x:(view.width - shopImageView.width) * 0.5, y:view.height * 0.25, width:shopImageView.width, height:shopImageView.height)
        shopImageView.isHidden = true
        view.addSubview(shopImageView)
        
        emptyLabel.text = "购物车空空的耶~赶紧挑好吃的吧"
        emptyLabel.textColor = UIColor.colorWithRGB(r: 100, g: 100, b: 100)
        emptyLabel.textAlignment = NSTextAlignment.center
        emptyLabel.frame = CGRect(x:0, y:shopImageView.frame.maxY + 55, width:view.width, height:50)
        emptyLabel.font = UIFont.systemFont(ofSize: 16)
        emptyLabel.isHidden = true
        view.addSubview(emptyLabel)
        emptyButton.frame = CGRect(x:(view.width - 150) * 0.5, y:emptyLabel.frame.maxY + 15, width:150, height:30)
        emptyButton.setBackgroundImage(UIImage(named: "btn.png"), for: UIControlState.normal)
        emptyButton.setTitle("去逛逛", for: UIControlState.normal)
        emptyButton.setTitleColor(UIColor.colorWithRGB(r: 100, g: 100, b: 100), for: UIControlState.normal)
        emptyButton.addTarget(self, action: #selector(ShopCartViewController.leftNavigitonItemClick), for: UIControlEvents.touchUpInside)
        emptyButton.isHidden = true
        view.addSubview(emptyButton)
    }
    
    // MARK: - Private Method
    private func showshopCarEmptyUI() {
        shopImageView.isHidden = false
        emptyButton.isHidden = false
        emptyLabel.isHidden = false
        supermarketTableView.isHidden = true
        tableFooterView.isHidden = true
    }

    
    // MARK: -  Action
    @objc func leftNavigitonItemClick() {
        //swift3.0通知写法
        NotificationCenter.default.post(name: NSNotification.Name(rawValue:LFBShopCarBuyProductNumberDidChangeNotification), object: nil, userInfo: nil)
        /*
        
         //swift2.2通知写法
   NSNotificationCenter.defaultCenter().postNotificationName(LFBShopCarBuyProductNumberDidChangeNotification, object: nil, userInfo: nil)
        */
        dismiss(animated: true, completion: nil)
    }
    
    @objc func modifySignTimeViewClick(sender: UIButton) {
        print("修改收货时间")
        if sender.tag == 11 {
            let datePicker = signTimeField.inputView as! UIDatePicker
            let calendar = datePicker.calendar
            
            /*
             //2.2写法
            let unitFlags: NSCalendarUnit = [NSCalendarUnit.Weekday, NSCalendarUnit.Year, NSCalendarUnit.Month, NSCalendarUnit.Day]
            
            let components = calendar.components(unitFlags, fromDate: datePicker.date)
         */
            
            let unitFlags:Set = [Calendar.Component.weekday,Calendar.Component.day, Calendar.Component.month, Calendar.Component.year]
            
            let components:DateComponents = (calendar?.dateComponents(unitFlags, from: Date(timeIntervalSinceNow: 0)))!
            
            var week:String = ""
            switch (components.weekday)! {
            case 1:
                week = "日"
            case 2:
                week = "一"
            case 3:
                week = "二"
            case 4:
                week = "三"
            case 5:
                week = "四"
            case 6:
                week = "五"
            case 7:
                week = "六"
            default:
                 week = "\(components.weekday)"
                break
            }
            signTimeField.text = "\(components.year!)" + "年" + "\(components.month!)" + "月" + "\(components.day!)" + "日" + "  周" + "\(week)"
            
            /*
            let formattor = NSDateFormatter()
            formattor.dateFormat = "YY年MM月dd日 aa"
            signTimeField.text = formattor.stringFromDate(datePicker.date)
 */
        }
        signTimeField.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
 
}

// MARK: - ShopCartSupermarketTableFooterViewDelegate
extension ShopCartViewController:ShopCartSupermarketTableFooterViewDelegate {
    func supermarketTableFooterDetermineButtonClick() {
        let orderPayVC = OrderPayWayViewController()
        
        navigationController?.pushViewController(orderPayVC, animated: true)
    }
}

// MARK: - UITableViewDeletate UITableViewDataSource
extension ShopCartViewController: UITableViewDelegate, UITableViewDataSource {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UserShopCarTool.sharedUserShopCar.getShopCarProductsClassifNumber()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = ShopCartCell.shopCarCell(tableView: tableView)
        
        cell.goods = UserShopCarTool.sharedUserShopCar.getShopCarProducts()[indexPath.row]
        return cell
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

