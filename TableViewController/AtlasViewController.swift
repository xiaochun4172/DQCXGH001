//
//  atlasViewController.swift
//  MapViewDemo-Swift
//
//  Created by XiaoChun on 2018/5/4.
//  Copyright © 2018年 Esri. All rights reserved.
//

import Foundation

    class AtlasViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {
        
        let length = 768 - 50
        
        var collectionView:UICollectionView!
        var layout:UICollectionViewFlowLayout!
        var dataArr:NSMutableArray = NSMutableArray.init()
        
    override func viewDidLoad() {
        super .viewDidLoad()
        
        self.title = String("规划图集")
        let rightBarButton = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        rightBarButton.setImage(UIImage.init(named: "shutdown.png"), for: .normal)
        rightBarButton.imageEdgeInsets = UIEdgeInsetsMake(2, 20, 2, 20)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightBarButton)
        
        rightBarButton.addTarget(self, action: #selector(shutDown), for: .touchUpInside)
        

        self.initData()
        self.createCollectionView()
    }

//MARK: 初始化
func initData() -> Void {
    for i in 0...19 {
        let str = NSString.init(string: "\(i+1).jpg")
        dataArr.add(str)
    }
}

//MARK:创建collectionView
func createCollectionView() -> Void {
    
    layout = UICollectionViewFlowLayout.init()//初始化UICollectionViewFlowLayout
    layout.minimumLineSpacing = 10//垂直最小距离
    layout.minimumInteritemSpacing = 10//水平最小距离
    layout.itemSize = CGSize.init(width: 100, height:130)//item的大小
    
    collectionView = UICollectionView.init(frame: CGRect.init(x: 20, y: 20, width: length, height: length), collectionViewLayout: layout)//初始化UICollectionView
    collectionView.backgroundColor = UIColor.white//背景色
    collectionView.showsVerticalScrollIndicator = false//去除垂直滚动条
    collectionView.showsHorizontalScrollIndicator = false//去除水平滚动条
    collectionView.dataSource = self//代理方法
    collectionView.delegate = self
    self.view.addSubview(collectionView)//添加主视图
    collectionView.register(picCollectionViewCell.classForCoder() ,forCellWithReuseIdentifier: "cellID")//注册cell
    
    }

//组数
func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
    }

//行数
func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
    return dataArr.count
    }

func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellID", for: indexPath) as! picCollectionViewCell
    cell.iv?.image = UIImage.init(named:dataArr[indexPath.row] as! String)
    return cell
    }

func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
    let nextVC:ImageViewController = ImageViewController.init()
    nextVC.iv.image = UIImage.init(named: dataArr[indexPath.row] as! String)
    self.navigationController?.pushViewController(nextVC, animated: true)
    }
      
    func shutDown()  {
        self.dismiss(animated: true, completion: nil)
        print("点击关闭（规划图集）按钮")
    }
}
