//
//  picCollectionViewCell.swift
//  MapViewDemo-Swift
//
//  Created by XiaoChun on 2018/5/5.
//  Copyright © 2018年 Esri. All rights reserved.
//

import Foundation

class picCollectionViewCell: UICollectionViewCell {
    
    var iv:UIImageView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.createIv()
        
    }
    
    public func createIv() -> Void {
        iv = UIImageView.init(frame:CGRect.init(x: 20, y: 20, width: self.bounds.size.width, height: self.bounds.size.height))
        self.addSubview(iv!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
