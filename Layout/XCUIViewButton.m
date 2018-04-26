//
//  XCUIViewButton.m
//  CustomTiledLayerSample
//
//  Created by XiaoChun on 16/7/11.
//
//

#import "XCUIViewButton.h"
#import "UIView+Extension.h"
//#import "PrefixHeader.pch"

@implementation XCUIViewButton

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        //设置按钮的阴影效果，颜色默认，shadowOffset设置阴影偏移右下，shadowOpacity设置阴影透明度
        self.layer.shadowOffset = CGSizeMake(4.0, 4.0);
        self.layer.shadowColor = [UIColor colorWithRed:20/255.0 green:10/255.0 blue:20/255.0 alpha:1.0].CGColor;
        self.layer.shadowOpacity = 0.8;
        self.imageView.layer.cornerRadius = 10;                             //设置圆角
        self.titleLabel.adjustsFontSizeToFitWidth = YES;                    //自动调整文字大小以适应宽度
        self.titleLabel.textAlignment = NSTextAlignmentCenter;              //文字居中
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    int deviceOrientationIsPortrait = UIDeviceOrientationPortrait;
    if (deviceOrientationIsPortrait) {
        self.titleLabel.hidden = NO;                                        //No隐藏标题
        self.imageView.width = self.bounds.size.width;                      //图像的width
        self.imageView.height = self.bounds.size.width;                     //图像的height
        self.titleLabel.width = self.bounds.size.width;
        self.titleLabel.height = self.bounds.size.height - self.imageView.height;
        self.titleLabel.x = self.imageView.x;
        self.titleLabel.y = self.imageView.y + self.imageView.height;
        self.titleLabel.textColor = [UIColor colorWithRed:250/255.0 green:250/255.0 blue:20/255.0 alpha:1.0];
    }else {
        self.titleLabel.hidden = YES;
    }
}

@end
