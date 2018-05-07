//
//  ImageViewController.swift
//  MapViewDemo-Swift
//
//  Created by XiaoChun on 2018/5/5.
//  Copyright © 2018年 Esri. All rights reserved.
//

import Foundation

class ImageViewController: UIViewController {
    
    let length = 768 - 50
    
    var iv : UIImageView = UIImageView.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.navigationItem.title = "详情"
        let rightBarButton = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        rightBarButton.setImage(UIImage.init(named: "shutdown.png"), for: .normal)
        rightBarButton.imageEdgeInsets = UIEdgeInsetsMake(2, 20, 2, 20)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightBarButton)
        
        rightBarButton.addTarget(self, action: #selector(shutDown), for: .touchUpInside)
        self.showiv()
    }
    
    func showiv() -> Void {
        iv.frame = CGRect.init(x: 0, y: 0, width: length, height: length)
        iv.contentMode = UIViewContentMode.scaleAspectFit
        self.view.addSubview(iv)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func shutDown()  {
        self.dismiss(animated: true, completion: nil)
        print("点击关闭(详情)按钮")
    }    
}
