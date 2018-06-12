//
//  PanoViewController.swift
//  MapViewDemo-Swift
//
//  Created by XiaoChun on 2018/5/7.
//  Copyright © 2018年 Esri. All rights reserved.
//

import Foundation
class PanoViewController: UIViewController,UIPopoverPresentationControllerDelegate {
    
    let length = 768 - 50
    var uiWebView:UIWebView!
    
    override func viewDidLoad() {
        super .viewDidLoad()      
        
        self.preferredContentSize = self.view.bounds.size
        self.title = String("全景德清")
        let rightBarButton = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        rightBarButton.setImage(UIImage.init(named: "shutdown.png"), for: .normal)
        rightBarButton.imageEdgeInsets = UIEdgeInsetsMake(2, 20, 2, 20)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightBarButton)
        
        let leftBarButton = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        leftBarButton.setImage(UIImage.init(named: "shutdown.png"), for: .normal)
        leftBarButton.imageEdgeInsets = UIEdgeInsetsMake(2, 20, 2, 20)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftBarButton)
        
        leftBarButton.addTarget(self, action: #selector(shutDown), for: .touchUpInside)
        self.showPano()
}

    public func showPano() -> Void {
        let url = NSURL(string: "http://weixin.dqplanning.gov.cn/zxdq/web/home/pano")!
        let request = NSURLRequest.init(url: url as URL)
        //全景德清宽度和高度需要调整，需要根据popover的宽度和高度来适配
//        uiWebView = UIWebView.init(frame: CGRect.init(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height))
        uiWebView = UIWebView.init(frame: CGRect.init(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height))
        uiWebView.contentMode = UIViewContentMode.scaleAspectFit
        uiWebView.loadRequest(request as URLRequest)
        uiWebView.scalesPageToFit = true
        self.view.addSubview(uiWebView)
        print("全景点加载完成")
    }
    
    func shutDown()  {
        self.dismiss(animated: true, completion: nil)
        print("点击关闭按钮2222222222222")
    }
}
