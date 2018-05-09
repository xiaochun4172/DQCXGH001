//
//  PanoViewController.swift
//  MapViewDemo-Swift
//
//  Created by XiaoChun on 2018/5/7.
//  Copyright © 2018年 Esri. All rights reserved.
//

import Foundation
class PanoViewController: UIViewController {
    
    let length = 768 - 50
    var uiWebView:UIWebView!
    
    override func viewDidLoad() {
        super .viewDidLoad()
        
        self.title = String("全景德清")
        let rightBarButton = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        rightBarButton.setImage(UIImage.init(named: "shutdown.png"), for: .normal)
        rightBarButton.imageEdgeInsets = UIEdgeInsetsMake(2, 20, 2, 20)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightBarButton)
        
        rightBarButton.addTarget(self, action: #selector(shutDown), for: .touchUpInside)
        self.showPano()
}

    public func showPano() -> Void {
        var webStr = "http://weixin.dqplanning.gov.cn/zxdq/web/home/pano"
        var url = NSURL(string: webStr)!
        var request = NSURLRequest.init(url: url as URL)
        uiWebView = UIWebView.init(frame: CGRect.init(x: 0, y: 0, width: length, height: length))
        uiWebView.contentMode = UIViewContentMode.scaleAspectFit
        uiWebView.loadRequest(request as URLRequest)
        uiWebView.scalesPageToFit = true
        self.view.addSubview(uiWebView)
        print("www.baidu.com")
    }
    
    func shutDown()  {
        self.dismiss(animated: true, completion: nil)
        print("点击关闭按钮2222222222222")
    }
}
