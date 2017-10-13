//
//  ProductDetailViewController.swift
//  iFreshF
//
//  Created by Jion on 16/5/6.
//  Copyright © 2016年 Youjuke. All rights reserved.
//

import UIKit

class ProductDetailViewController: AnimationViewController {

    private let grayBGColor = UIColor.colorWithRGB(r: 248, g: 248, b: 248)
    private var goods:Goods?
    private var scrollView: UIScrollView?
    private var productImageView: UIImageView?
    private let nameView = UIView()
    private var titleNameLabel: UILabel?
    private var priceView: DiscountPriceView?
    private var presentView: UIView?
    private var detailView: UIView?
    private var brandTitleLabel: UILabel?
    private var detailTitleLabel: UILabel?
    private var promptView: UIView?
    private var detailImageView: UIImageView?
    private var bottomView: UIView?
    private var buyView: BuyView?
    private var yellowShopCar: YellowShopCarView?
    
    init() {
        super.init(nibName: nil, bundle: nil)
        scrollView = UIScrollView(frame: view.bounds)
        scrollView!.delegate = self
        scrollView!.backgroundColor = UIColor.white
        scrollView?.alwaysBounceVertical = true
        view.addSubview(scrollView!)
        
        productImageView = UIImageView(frame: CGRect(x:0, y:0, width:ZJScreenWidth, height:400))
        productImageView?.contentMode = UIViewContentMode.scaleAspectFit
        scrollView!.addSubview(productImageView!)
        
        buildLineView(frame: CGRect(x:0, y:productImageView!.frame.maxY - 1, width:ZJScreenWidth, height:1), addView: productImageView!)
        
        nameView.frame = CGRect(x:0, y:productImageView!.frame.maxY, width:ZJScreenWidth, height:80)
        nameView.backgroundColor = UIColor.white
        scrollView!.addSubview(nameView)
        
         let leftMargin: CGFloat = 15
        
        titleNameLabel = UILabel(frame: CGRect(x:leftMargin,y:0,width:ZJScreenWidth,height:60))
        titleNameLabel?.textColor = UIColor.black
        titleNameLabel?.font = UIFont.systemFont(ofSize: 16)
        nameView.addSubview(titleNameLabel!)
        
        buildLineView(frame: CGRect(x:0, y:80 - 1, width:ZJScreenWidth, height:1), addView: nameView)
        
        presentView = UIView(frame: CGRect(x:0, y:nameView.frame.maxY, width:ZJScreenWidth, height:50))
        presentView?.backgroundColor = grayBGColor
        scrollView?.addSubview(presentView!)
        let presentButton = UIButton(frame: CGRect(x:leftMargin, y:13, width:55, height:24))
        presentButton.setTitle("促销", for: .normal)
        presentButton.backgroundColor = UIColor.colorWithRGB(r: 252, g: 85, b: 88)
        presentButton.layer.cornerRadius = 8
        presentButton.setTitleColor(UIColor.white, for: .normal)
        presentView?.addSubview(presentButton)
        
        let presentLabel = UILabel(frame: CGRect(x:100, y:0, width:ZJScreenWidth * 0.7, height:50))
        presentLabel.textColor = UIColor.black
        presentLabel.font = UIFont.systemFont(ofSize: 14)
        presentLabel.text = "买一赠一 (赠品有限,赠完为止)"
        presentView?.addSubview(presentLabel)
        
        buildLineView(frame: CGRect(x:0, y:49, width:ZJScreenWidth, height:1), addView: presentView!)
        
        detailView = UIView(frame: CGRect(x:0, y:presentView!.frame.maxY, width:ZJScreenWidth, height:150))
        detailView?.backgroundColor = grayBGColor
        scrollView?.addSubview(detailView!)
        let brandLabel = UILabel(frame: CGRect(x:leftMargin, y:0, width:80, height:50))
        brandLabel.textColor = UIColor.colorWithRGB(r: 150, g: 150, b: 150)
        brandLabel.text = "品       牌"
        brandLabel.font = UIFont.systemFont(ofSize: 14)
        detailView?.addSubview(brandLabel)
        
        brandTitleLabel = UILabel(frame: CGRect(x:100, y:0, width:ZJScreenWidth * 0.6, height:50))
        brandTitleLabel?.textColor = UIColor.black
        brandTitleLabel?.font = UIFont.systemFont(ofSize: 14)
        detailView?.addSubview(brandTitleLabel!)
        
        buildLineView(frame: CGRect(x:0, y:50 - 1, width:ZJScreenWidth, height:1), addView: detailView!)
        
        let detailLabel = UILabel(frame: CGRect(x:leftMargin, y:50, width:80, height:50))
        detailLabel.text = "产品规格"
        detailLabel.textColor = brandLabel.textColor
        detailLabel.font = brandTitleLabel!.font
        detailView?.addSubview(detailLabel)
        
        detailTitleLabel = UILabel(frame: CGRect(x:100, y:50, width:ZJScreenWidth * 0.6, height:50))
        detailTitleLabel?.textColor = brandTitleLabel!.textColor
        detailTitleLabel?.font = brandTitleLabel!.font
        detailView?.addSubview(detailTitleLabel!)
        
        buildLineView(frame: CGRect(x:0, y:100 - 1, width:ZJScreenWidth, height:1), addView: detailView!)
        
        let textImageLabel = UILabel(frame: CGRect(x:leftMargin, y:100, width:80, height:50))
        textImageLabel.textColor = brandLabel.textColor
        textImageLabel.font = brandLabel.font
        textImageLabel.text = "图文详情"
        detailView?.addSubview(textImageLabel)
        
        promptView = UIView(frame: CGRect(x:0, y:detailView!.frame.maxY, width:ZJScreenWidth, height:80))
        promptView?.backgroundColor = UIColor.white
        scrollView?.addSubview(promptView!)
        
        let promptLabel = UILabel(frame: CGRect(x:15, y:5, width:ZJScreenWidth, height:20))
        promptLabel.text = "温馨提示:"
        promptLabel.textColor = UIColor.black
        promptView?.addSubview(promptLabel)
        
        let promptDetailLabel = UILabel(frame: CGRect(x:15, y:20, width:ZJScreenWidth - 30, height:60))
        promptDetailLabel.textColor = presentButton.backgroundColor
        promptDetailLabel.numberOfLines = 2
        promptDetailLabel.text = "商品签收后, 如有问题请您在24小时内联系4008484842,并将商品及包装保留好,拍照发给客服"
        promptDetailLabel.font = UIFont.systemFont(ofSize: 14)
        promptView?.addSubview(promptDetailLabel)
        
        buildLineView(frame: CGRect(x:0, y:ZJScreenHeight - 51 - Navigation, width:ZJScreenWidth, height:1), addView: view)
        bottomView = UIView(frame: CGRect(x:0, y:ZJScreenHeight - 50 - Navigation, width:ZJScreenWidth, height:50))
        bottomView?.backgroundColor = grayBGColor
        view.addSubview(bottomView!)
        
        let addProductLabel = UILabel(frame: CGRect(x:15, y:0, width:70, height:50))
        addProductLabel.text = "添加商品:"
        addProductLabel.textColor = UIColor.black
        addProductLabel.font = UIFont.systemFont(ofSize: 15)
        bottomView?.addSubview(addProductLabel)

    }
    
    convenience init(goods:Goods) {
        self.init()
        
        self.goods = goods
        buildNavigationItem(titleText: (goods.name)!)
        productImageView?.sd_setImage(with: NSURL(string: goods.img!)! as URL, placeholderImage: UIImage(named: "v2_placeholder_square"))
        titleNameLabel?.text = goods.name
        priceView = DiscountPriceView(price: goods.price, marketPrice: goods.market_price)
        priceView?.frame = CGRect(x:15, y:40, width:ZJScreenWidth * 0.6, height:40)
        nameView.addSubview(priceView!)
        
        if goods.pm_desc == "买一赠一" {
            presentView?.frame.size.height = 50
            presentView?.isHidden = false
        } else {
            presentView?.frame.size.height = 0
            presentView?.isHidden = true
            detailView?.frame.origin.y -= 50
            promptView?.frame.origin.y -= 50
        }
        
        brandTitleLabel?.text = goods.brand_name
        detailTitleLabel?.text = goods.specifics
        
        detailImageView = UIImageView(image: UIImage(named: "aaaa"))
        let scale: CGFloat = 320.0 / ZJScreenWidth
        detailImageView?.frame = CGRect(x:0, y:promptView!.frame.maxY, width:ZJScreenWidth, height:detailImageView!.height / scale)
        scrollView?.addSubview(detailImageView!)
        scrollView?.contentSize = CGSize(width:ZJScreenWidth, height:detailImageView!.frame.maxY + 50 + Navigation)
        
        buyView = BuyView(frame: CGRect(x:85, y:12, width:80, height:25))
        buyView!.zeroIsShow = true
        buyView!.goods = goods
        weak var weakSelf = self
        buyView?.clickAddShopCar = ({
            
           weakSelf?.addProductsToBigShopCarAnimation(imageView: weakSelf!.productImageView!)
        })
        bottomView?.addSubview(buyView!)
        
        yellowShopCar = YellowShopCarView(frame: CGRect(x:ZJScreenWidth - 70, y:50 - 61 - 10, width:61, height:61), shopViewClick: {
            let shopCarVC = ShopCartViewController()
            let nav = BaseNavigationController(rootViewController: shopCarVC)
            weakSelf!.present(nav, animated: true, completion: nil)
        })
        bottomView!.addSubview(yellowShopCar!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
  
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       UIApplication.shared.setStatusBarStyle(UIStatusBarStyle.default, animated: false)
        navigationController?.navigationBar.barTintColor = LFBNavigationBarWhiteBackgroundColor
        //每次都重新赋值防止数量改变不能及时更新
        if goods != nil {
            buyView?.goods = goods
        }
    }
    
     // MARK: - Build UI
    private func buildLineView(frame: CGRect, addView: UIView) {
        let lineView = UIView(frame: frame)
        lineView.backgroundColor = UIColor.black
        lineView.alpha = 0.1
        addView.addSubview(lineView)
    }

    private func buildNavigationItem(titleText: String) {
        self.navigationItem.title = titleText
        navigationItem.rightBarButtonItem = UIBarButtonItem.barButton(title: "分享", titleColor: UIColor.colorWithRGB(r: 100, g: 100, b: 100), target: self, action: #selector(ProductDetailViewController.rightItemClick))
    }
    // MARK: - Action
    //分享操作
    @objc func rightItemClick(){
        let shareActionSheet: LFBActionSheet = LFBActionSheet()
        shareActionSheet.showActionSheetViewShowInView(inView: view) { (ShareType) in
            ShareManager.shareToShareType(shareType: ShareType, shareModel: self.goods!, vc: self)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

// MARK: - ScrollViewDelegate
extension ProductDetailViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (animationBigLayers != nil) && (animationBigLayers?.count)! > 0 {
            let transitionLayer = animationBigLayers![0]
            transitionLayer.isHidden = true
        }
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
