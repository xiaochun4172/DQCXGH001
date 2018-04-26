//
//  UIView+Extension.h
//  CustomTiledLayerSample
//
//  Created by XiaoChun on 16/7/11.
//
//

#import <UIKit/UIKit.h>

//@interface UIView_Extension : UIView
//
//@end
@interface UIView (Extension)
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGSize size;
@end