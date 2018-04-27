//
//  XCmenuTableViewController.h
//  CustomTiledLayerSample
//
//  Created by XiaoChun on 16/7/13.
//
//

#import <UIKit/UIKit.h>
#import <ArcGIS/ArcGIS.h>

@class XCmenuTableViewController;

@protocol XCmenuTableViewControllerDelegate <NSObject>

@optional

- (void)menuTableViewController:(XCmenuTableViewController *)vc didSelectUrl:(AGSArcGISTiledLayer *)url;
- (void)onClickOKbtn:(id)paramSender;

@end

@interface XCmenuTableViewController : UITableViewController

@property(nonatomic, weak) id<XCmenuTableViewControllerDelegate> delegate;

@end
