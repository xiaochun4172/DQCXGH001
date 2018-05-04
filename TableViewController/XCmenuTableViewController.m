//  XCmenuTableViewController.m
//  CustomTiledLayerSample
//
//  Created by XiaoChun on 16/7/13.
//
#import "XCmenuTableViewController.h"
//#import "CustomLayerViewController.h"

@interface XCmenuTableViewController ()
@property(nonatomic, strong) NSArray *menuTable;
@property(nonatomic, strong) NSArray *urlTable;

@end

@implementation XCmenuTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSURL* url1 = [NSURL URLWithString: @"http://220.191.216.230:6080/arcgis/rest/services/dghy_dzdt/MapServer"];
    AGSArcGISTiledLayer *layer1 = [AGSArcGISTiledLayer ArcGISTiledLayerWithURL:url1];
    NSURL* url2 = [NSURL URLWithString: @"http://services.arcgisonline.com/arcgis/rest/services/World_Terrain_Base/MapServer"];
    AGSArcGISTiledLayer *layer2 = [AGSArcGISTiledLayer ArcGISTiledLayerWithURL:url2];
    NSURL* url3 = [NSURL URLWithString: @"http://services.arcgisonline.com/arcgis/rest/services/ESRI_Imagery_World_2D/MapServer"];
    AGSArcGISTiledLayer *layer3 = [AGSArcGISTiledLayer ArcGISTiledLayerWithURL:url3];
    NSURL* url4 = [NSURL URLWithString: @"http://services.arcgisonline.com/arcgis/rest/services/ESRI_StreetMap_World_2D/MapServer"];
    AGSArcGISTiledLayer *layer4 = [AGSArcGISTiledLayer ArcGISTiledLayerWithURL:url4];

    self.urlTable = @[layer1,layer2,layer3,layer4];
    self.menuTable = @[@"多规合一",@"建设用地总体规划",@"土地利用总体规划",@"项目审查"];
    self.title = @"加载图层";
    UIBarButtonItem *uibarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"清除" style: UIBarButtonItemStylePlain target:self action:@selector(onClickOKbtn:)];
    self.navigationItem.rightBarButtonItem = uibarButtonItem;
    CGFloat w = 250;
    CGFloat h = self.menuTable.count * 44;
    self.preferredContentSize = CGSizeMake(w, h);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.menuTable.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    cell.textLabel.text = self.menuTable[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.delegate respondsToSelector:@selector(menuTableViewController:didSelectUrl:)]) {
        NSInteger *row = indexPath.row;
        NSString *url = [_urlTable objectAtIndex:row];
        [self.delegate menuTableViewController:self didSelectUrl:url];
    }
}

- (void)onClickOKbtn:(id)paramSender{
    [self.delegate menuTableViewController:self didSelectUrl:0];
}

@end
