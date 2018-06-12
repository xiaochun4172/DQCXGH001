//
//  AlertController.swift
//  MapViewDemo-Swift
//
//  Created by XiaoChun on 2018/5/8.
//  Copyright © 2018年 Esri. All rights reserved.
//

import Foundation

class AlertController: UIViewController {
    override func viewDidLoad() {
        super .viewDidLoad()

    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let alertController = UIAlertController(title: "网络提示", message: "请连接网络后重试！", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "确定", style: .destructive, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
