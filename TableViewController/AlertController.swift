//
//  AlertController.swift
//  MapViewDemo-Swift
//
//  Created by XiaoChun on 2018/5/8.
//  Copyright © 2018年 Esri. All rights reserved.
//

import Foundation

class AlertController: UIAlertController {
    override func viewDidLoad() {
        super .viewDidLoad()

        self.title = "网络提示"
        self.message = "请连接网络后重试!"
        let okAction = UIAlertAction(title: "确定", style: .default, handler: nil)
        self.addAction(okAction)
    }
}
