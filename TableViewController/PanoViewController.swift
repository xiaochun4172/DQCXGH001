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
    
    var collectionView:UICollectionView!
    var layout:UICollectionViewFlowLayout!
    var dataArr:NSMutableArray = NSMutableArray.init()
    
    override func viewDidLoad() {
        super .viewDidLoad()
        
        self.title = String("全景德清")
        let rightBarButton = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        rightBarButton.setImage(UIImage.init(named: "shutdown.png"), for: .normal)
        rightBarButton.imageEdgeInsets = UIEdgeInsetsMake(2, 20, 2, 20)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightBarButton)
        
        rightBarButton.addTarget(self, action: #selector(shutDown), for: .touchUpInside)
}
    func shutDown()  {
        self.dismiss(animated: true, completion: nil)
        print("点击关闭按钮2222222222222")
    }
}
