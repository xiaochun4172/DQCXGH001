//
//  atlasViewController.swift
//  MapViewDemo-Swift
//
//  Created by XiaoChun on 2018/5/4.
//  Copyright © 2018年 Esri. All rights reserved.
//

import Foundation

class AtlasViewController: UIViewController {
    override func viewDidLoad() {
        super .viewDidLoad()
        
        self.title = String("规划图集2")
        let rightBarButton = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        rightBarButton.setImage(UIImage.init(named: "shutdown.png"), for: .normal)
        rightBarButton.imageEdgeInsets = UIEdgeInsetsMake(2, 20, 2, 20)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightBarButton)
        
        rightBarButton.addTarget(self, action: #selector(shutDown), for: .touchUpInside)

    }

    func shutDown()  {
        print("点击关闭按钮")
    }
}

