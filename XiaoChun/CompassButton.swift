//
//  CompassButton.swift
//  MapViewDemo-Swift
//
//  Created by XiaoChun on 2018/2/22.
//  Copyright © 2018年 Esri. All rights reserved.
//

import Foundation

class CompassButton: UIButton {
    override init(frame: CGRect) {
        super .init(frame: frame)
        let compassButtonImage = UIImage.init(named:"compass1.png")
        self.setImage(compassButtonImage, for: UIControlState.normal)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
