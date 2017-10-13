//
//  QRCodeViewController.swift
//  iFreshF
//
//  Created by Jion on 16/4/15.
//  Copyright © 2016年 Youjuke. All rights reserved.
//

import UIKit
import AVFoundation

class QRCodeViewController: BaseViewController {

     var captureSession: AVCaptureSession?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
     var animationLineView = UIImageView()
     var titleLabel = UILabel()
     var zbrImage = UIImageView()
     var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        buildNavigationItem()
        
        buildInputAVCaptureDevice()
        
        buildFrameImageView()
        
         buildTitleLabel()
        
        buildAnimationLineView()
    }

    // MARK: - Build UI
    private func buildNavigationItem() {
        navigationItem.title = "店铺二维码"
        
        navigationController?.navigationBar.barTintColor = LFBNavigationBarWhiteBackgroundColor
    }
    private func buildTitleLabel() {
        
        titleLabel.textColor = UIColor.white
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        titleLabel.frame = CGRect(x:0, y:340, width:ZJScreenWidth, height:40)
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = NSTextAlignment.center
        view.addSubview(titleLabel)
    }

    private func buildInputAVCaptureDevice() {
        guard let captureDevice = AVCaptureDevice.default(for: AVMediaType.video) else {
            titleLabel.text = "不支持模拟器"
            return
        }
        
        titleLabel.text = "请将二维码/条形码对准方框"
        let input = try? AVCaptureDeviceInput(device: captureDevice)
        if input == nil {
            titleLabel.text = "你的设备不支持摄像头"
            return
        }
        
        let captureMetadataOutput = AVCaptureMetadataOutput()
        captureSession = AVCaptureSession()
        captureSession?.addInput(input!)
        
        captureSession?.addOutput(captureMetadataOutput)
        
        let dispatchQueue = DispatchQueue.main
        captureMetadataOutput.setMetadataObjectsDelegate(self, queue: dispatchQueue)
        captureMetadataOutput.metadataObjectTypes =  [
            AVMetadataObject.ObjectType.qr,
            AVMetadataObject.ObjectType.ean13,
            AVMetadataObject.ObjectType.ean8,
            AVMetadataObject.ObjectType.code39,
            AVMetadataObject.ObjectType.code39Mod43,
            AVMetadataObject.ObjectType.code93,
            AVMetadataObject.ObjectType.pdf417,
            AVMetadataObject.ObjectType.upce,
            AVMetadataObject.ObjectType.code128
        ]
        
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        videoPreviewLayer?.frame = view.layer.frame
        view.layer.addSublayer(videoPreviewLayer!)
        
        //有效扫描区域,AVCapture输出的图片大小都是横着的.坐标系发生改变。把原来的坐标系顺时针旋转90度（(0,0)右上，(0,0.5)左上，(0.5,0)右下，(0.5,0.5)左下）
        captureMetadataOutput.rectOfInterest = CGRect(x:100.0/(ZJScreenHeight - 64),y:0.2 , width:0.6 * ZJScreenWidth/ZJScreenHeight, height:0.6)
        //中心扫描区域
//        captureMetadataOutput.rectOfInterest = CGRectMake(0.25, 0.25, 0.5 * ZJScreenWidth/ZJScreenHeight, 0.5)
        captureSession?.startRunning()
    }
    private func buildFrameImageView() {
        //设置周围背景
        let lineT = [CGRect(x:0, y:0, width:ZJScreenWidth, height:100),CGRect(x:0, y:100, width:ZJScreenWidth * 0.2, height:ZJScreenWidth * 0.6),CGRect(x:0, y:100 + ZJScreenWidth * 0.6, width:ZJScreenWidth, height:ZJScreenHeight - 100 - ZJScreenWidth * 0.6),CGRect(x:ZJScreenWidth * 0.8, y:100, width:ZJScreenWidth * 0.2, height:ZJScreenWidth * 0.6)]
        for lineTFrame in lineT {
            buildTransparentView(frame: lineTFrame)
        }
        //添加框
        let lineR = [CGRect(x:ZJScreenWidth * 0.2, y:100, width:ZJScreenWidth * 0.6, height:2),CGRect(x:ZJScreenWidth * 0.2, y:100, width:2, height:ZJScreenWidth * 0.6),CGRect(x:ZJScreenWidth * 0.8 - 2, y:100, width:2, height:ZJScreenWidth * 0.6),CGRect(x:ZJScreenWidth * 0.2, y:100 + ZJScreenWidth * 0.6, width:ZJScreenWidth * 0.6, height:2)]
        for linFrame in lineR {
            buildLineView(frame: linFrame)
        }
        //设置四个角
        let yellowHeight: CGFloat = 4
        let yellowWidth: CGFloat = 30
        let yellowX: CGFloat = ZJScreenWidth * 0.2
        let bottomY: CGFloat = 100 + ZJScreenWidth * 0.6
        
        let lineY = [CGRect(x:yellowX, y:100, width:yellowWidth, height:yellowHeight),
                     CGRect(x:yellowX, y:100, width:yellowHeight, height:yellowWidth),
                     CGRect(x:ZJScreenWidth * 0.8 - yellowHeight, y:100, width:yellowHeight, height:yellowWidth),
                     CGRect(x:ZJScreenWidth * 0.8 - yellowWidth, y:100, width:yellowWidth, height:yellowHeight),
                     CGRect(x:yellowX, y:bottomY - yellowHeight + 2, width:yellowWidth, height:yellowHeight),
                     CGRect(x:ZJScreenWidth * 0.8 - yellowWidth, y:bottomY - yellowHeight + 2, width:yellowWidth, height:yellowHeight),
                     CGRect(x:yellowX, y:bottomY - yellowWidth, width:yellowHeight, height:yellowWidth),
                     CGRect(x:ZJScreenWidth * 0.8 - yellowHeight, y:bottomY - yellowWidth, width:yellowHeight, height:yellowWidth)]
        
        for yellowRect in lineY {
            buildYellowLineView(frame: yellowRect)
        }
    }
    
    private func buildYellowLineView(frame: CGRect) {
        let yellowView = UIView(frame: frame)
        yellowView.backgroundColor = LFBNavigationYellowColor
        view.addSubview(yellowView)
    }
    private func buildLineView(frame: CGRect) {
        let view1 = UIView(frame: frame)
        view1.backgroundColor = UIColor.colorWithRGB(r: 230, g: 230, b: 230)
        view.addSubview(view1)
    }
    private func buildTransparentView(frame: CGRect) {
        let tView = UIView(frame: frame)
        tView.backgroundColor = UIColor.black
        tView.alpha = 0.5
        view.addSubview(tView)
    }
    
    private func buildAnimationLineView() {
        animationLineView.image = UIImage(named: "yellowlight")
        view.addSubview(animationLineView)
       timer = Timer(timeInterval: 2.0, target: self, selector: #selector(QRCodeViewController.startYellowViewAnimation), userInfo: nil, repeats: true)
        let runloop = RunLoop.current
        runloop.add(timer!, forMode: RunLoopMode.commonModes)
        timer!.fire()
        
    }
    @objc func startYellowViewAnimation() {
        animationLineView.frame = CGRect(x:ZJScreenWidth * 0.2 + ZJScreenWidth * 0.1 * 0.5, y:100, width:ZJScreenWidth * 0.5, height:20)
        weak var weakSelf = self
        UIView.animate(withDuration: 2.0, animations: {
            weakSelf!.animationLineView.frame = CGRect(x:ZJScreenWidth * 0.2 + ZJScreenWidth * 0.1 * 0.5, y:90 + ZJScreenWidth * 0.6, width:ZJScreenWidth * 0.5, height:20)
            }) { (finish) in
             
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if timer != nil {
            timer!.invalidate()
            timer = nil
        }
    }
    
     func alertViewTitle(title: String, message: String) {
        let alert = UIAlertView(title: title, message: message, delegate: self, cancelButtonTitle: "确定", otherButtonTitles: "重新扫描")
        alert.show()
        
    }
    
     func showZbarImageView(hidden: Bool) {
    
        zbrImage.frame = CGRect(x:0.3 * ZJScreenWidth, y:ZJScreenHeight - 64 - 0.5 * ZJScreenWidth, width:0.4 * ZJScreenWidth, height:0.4 * ZJScreenWidth)
        zbrImage.backgroundColor = UIColor.white
        zbrImage.isHidden = hidden
        view.addSubview(zbrImage)
        
        let icon = UIImageView()
        let w = zbrImage.frame.size.width
        let h = zbrImage.frame.size.height
        icon.bounds = CGRect(x:0, y:0, width:w * 0.2, height:h * 0.2)
        icon.center = CGPoint(x:w/2, y:h/2)
//        icon.sd_setImageWithURL(NSURL(string: ""), placeholderImage: UIImage(named: "author.png"))
        icon.image = UIImage(named: "author.png")
        zbrImage.addSubview(icon)
    }
    
    //MARK:- 处理二维码
     func QRCodeGeneratorImageWithString(string: String) -> UIImage {
        
        let filter = CIFilter(name: "CIQRCodeGenerator")
        filter?.setDefaults()
        let data = string.data(using: String.Encoding.utf8)
        filter?.setValue(data!, forKey: "inputMessage")
        let ciImage = filter?.outputImage
        let image = transformUIImageFromCIImage(ciImage: ciImage!)
        return image
    }
    
     func transformUIImageFromCIImage(ciImage: CIImage) -> UIImage {
        
        let size = view.width * 0.5
        let extentRect = ciImage.extent.integral
        let scale = min(size/extentRect.width, size/extentRect.height)
        
        let width = extentRect.width * scale
        let height = extentRect.height * scale
        
        let colorSpace = CGColorSpaceCreateDeviceGray()
        
        let bitmapRef = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: CGImageAlphaInfo.none.rawValue)
        /*
        if bitmapRef != nil {
            return UIImage(ciImage:ciImage)
        }
 */
        //这里有个bug问题CIContext(options:nil)会crash
        //kCIContextUseSoftwareRenderer 使用cpu还是GPU处理
        let context = CIContext(options:[kCIContextUseSoftwareRenderer : NSNumber(value: false)])

        let bitmapImage = context.createCGImage(ciImage, from: extentRect)
        
        bitmapRef!.interpolationQuality = CGInterpolationQuality.none
        bitmapRef!.scaleBy(x: scale, y: scale)

        bitmapRef!.draw(bitmapImage!, in: extentRect)
        
        let scaledImage = bitmapRef!.makeImage()
        
         bitmapRef!.flush()
       _ = scaledImage!.isMask
        
        return UIImage(cgImage: scaledImage!)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

extension QRCodeViewController:AVCaptureMetadataOutputObjectsDelegate,UIAlertViewDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if metadataObjects.count > 0 {
            var QRValue: String?
            for metadataObject in metadataObjects {
                QRValue = (metadataObject as! AVMetadataMachineReadableCodeObject).stringValue
                let type = (metadataObject as! AVMetadataMachineReadableCodeObject).type
                if type == AVMetadataObject.ObjectType.qr {
                    alertViewTitle(title: "二维码", message: QRValue!)
                }else if type == AVMetadataObject.ObjectType.ean13{
                    alertViewTitle(title: "条形码", message: QRValue!)
                }else{
                    alertViewTitle(title: type.rawValue, message: QRValue!)
                }
                
                /*
                 switch type {
                 case AVMetadataObjectTypeQRCode:
                 alertViewTitle(title: "二维码", message: QRValue!)
                 case AVMetadataObjectTypeEAN13Code:
                 alertViewTitle(title: "条形码", message: QRValue!)
                 default:
                 alertViewTitle(title: type!, message: QRValue!)
                 }
                 */
                
            }
            captureSession?.stopRunning()
            timer?.invalidate()
        }
    }
    
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
        if buttonIndex != 0 {
            captureSession?.startRunning()
            timer?.fire()
            showZbarImageView(hidden: true)
        }else{
            showZbarImageView(hidden: false)
            titleLabel.text = "结果:" + alertView.message!
            zbrImage.image = QRCodeGeneratorImageWithString(string: alertView.message!)
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
