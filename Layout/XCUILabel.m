//
//  XCUILabel.m
//  CustomTiledLayerSample
//
//  Created by 吴春平 on 16/9/28.
//
//

#import "XCUILabel.h"
//#import "PrefixHeader.pch"

@implementation XCUILabel

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.textColor = [UIColor redColor];
        self.shadowOffset = CGSizeMake(1, 1);
        self.shadowColor = [UIColor whiteColor];
        self.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}
@end
