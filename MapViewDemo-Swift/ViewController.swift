//
// Copyright 2015 ESRI
//
// All rights reserved under the copyright laws of the United States
// and applicable international laws, treaties, and conventions.
//
// You may freely redistribute and use this sample code, with or
// without modification, provided you include the original copyright
// notice and use restrictions.
//
// See the use restrictions at http://help.arcgis.com/en/sdk/10.0/usageRestrictions.htm
//

import UIKit
import ArcGIS

class ViewController: UIViewController,XCmenuTableViewControllerDelegate {
    
    
    @IBOutlet var mapView: AGSMapView!
//    var segmentedController: XCUISegmentedControl!
    var map:AGSMap!
    var featureLayer:AGSFeatureLayer?
    
    let segmentedController = XCUISegmentedControl(items:["影像","矢量"])
    
    let xcuiviewButton0 = XCUIViewButton()
    let xcuiviewButton1 = XCUIViewButton()
    let xcuiviewButton2 = XCUIViewButton()
//    var alertController:AlertController!
    let xcuiviewButton3 = XCUIViewButton()
    let xcuiviewButton4 = XCUIViewButton()
    var atlasPopover:UIPopoverController!
    var popover:UIPopoverController!

    let compassButton = CompassButton()
    let developerLabel = XCUILabel()
    let centerPointLabel = XCUILabel()

    let tiledLayerImage = AGSArcGISTiledLayer(name:"影像地图1")
    let tiledLayerVector = AGSArcGISTiledLayer(name:"电子地图1")
////下面是加载在线服务，服务地址里面不能有中文字符（要不然提示没有服务）////////////////////////////////////////////////////////////////////////////////
//    let tiledLayerImage = AGSArcGISTiledLayer(url: URL(string: "http://220.191.216.230:6080/arcgis/rest/services/dghy_dzdt/MapServer")!)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
////////监听屏幕方向，适配控件////////////////////////////////////////////////////////////////////////////////////
        UIDevice.current.beginGeneratingDeviceOrientationNotifications()
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.receivedRotation), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        
////////设置地图背景图案，///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        let backGroundColor = UIColor(patternImage:UIImage(named:"B_1.jpg")!)
        self.mapView.backgroundColor = UIColor.clear
        self.mapView.backgroundGrid?.color = UIColor.clear
        self.mapView.backgroundGrid?.gridLineWidth = 0.0
        self.view.backgroundColor = backGroundColor
        
////////添加系统图标，"德清城乡规划用图系统"/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        let titleLabelString = "城乡规划用图"
        let attrString = NSMutableAttributedString.init(string: titleLabelString)
        let attchImage = NSTextAttachment()
        attchImage.image = UIImage.init(named: "DeQing.png")
        attchImage.bounds = CGRect(x: -8, y: -11, width: 51, height: 48)
        let stringImage = NSAttributedString(attachment: attchImage)
        attrString.insert(stringImage, at: 0)
        let titleLabel = XCUILabel()
        titleLabel.frame = CGRect(x: 40, y: 40, width: 200, height: 40)
        titleLabel.attributedText = attrString
        titleLabel.font = UIFont.systemFont(ofSize: 28)
        titleLabel.adjustsFontSizeToFitWidth = true
        self.mapView.addSubview(titleLabel)
        
///////添加控件，指南针////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        compassButton.transform = CGAffineTransform(rotationAngle: CGFloat(-self.mapView.rotation * Double.pi / 180))
        compassButton.addTarget(self, action: #selector(compassAction), for:.touchUpInside)
        self.mapView.addSubview(compassButton)
        
////////添加控件,多规////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        let xcuiviewButtonImage0 = UIImage.init(named: "layer.png")
        let xcuiviewButtonTitle0 = "多规"
//        segmentedController.addTarget(self, action: #selector(ViewController.segmentedController(segmentedControlSender:)), for: .valueChanged)

        xcuiviewButton0.addTarget(self, action: #selector(xcuiviewButton0Action), for:.touchUpInside)
        xcuiviewButton0.setImage(xcuiviewButtonImage0, for: UIControlState.normal)
        xcuiviewButton0.setTitle(xcuiviewButtonTitle0, for: UIControlState.normal)
        self.mapView.addSubview(xcuiviewButton0)
        
////////添加控件,SHP////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        let xcuiviewButtonImage1 = UIImage.init(named: "shp.jpg")
        let xcuiviewButtonTitle1 = "全景"
        xcuiviewButton1.addTarget(self, action: #selector(xcuiviewButton1Action), for: .touchUpInside)
        xcuiviewButton1.setImage(xcuiviewButtonImage1, for: UIControlState.normal)
        xcuiviewButton1.setTitle(xcuiviewButtonTitle1, for: UIControlState.normal)
        self.mapView.addSubview(xcuiviewButton1)
        
////////添加控件,天地图////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        let xcuiviewButtonImage2 = UIImage.init(named: "WorldMap.png")
        let xcuiviewButtonTitle2 = "一周一图"
        xcuiviewButton2.addTarget(self, action: #selector(xcuiviewButton2Action), for:.touchUpInside)
        xcuiviewButton2.setImage(xcuiviewButtonImage2, for: UIControlState.normal)
        xcuiviewButton2.setTitle(xcuiviewButtonTitle2, for: UIControlState.normal)
        self.mapView.addSubview(xcuiviewButton2)
        
////////添加控件,定位////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        let xcuiviewButtonImage3 = UIImage.init(named: "point.png")
        let xcuiviewButtonTitle3 = "定位"
        xcuiviewButton3.addTarget(self, action: #selector(xcuiviewButton3Action), for:.touchUpInside)
        xcuiviewButton3.setImage(xcuiviewButtonImage3, for: UIControlState.normal)
        xcuiviewButton3.setTitle(xcuiviewButtonTitle3, for: UIControlState.normal)
        self.mapView.addSubview(xcuiviewButton3)
        
////////添加控件,规划图集////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        let xcuiviewButtonImage4 = UIImage.init(named: "planning.png")
        let xcuiviewButtonTitle4 = "规划"
        xcuiviewButton4.addTarget(self, action: #selector(xcuiviewButton4Action), for:.touchUpInside)
        xcuiviewButton4.setImage(xcuiviewButtonImage4, for: UIControlState.normal)
        xcuiviewButton4.setTitle(xcuiviewButtonTitle4, for: UIControlState.normal)
        self.mapView.addSubview(xcuiviewButton4)
        
////////添加屏幕下方中间"Developer:XiaoChun，15906721241"//////////////////////////////////////////////////////////////////////////////////////////
        developerLabel.text = "Developer:XiaoChun，15906721241"
        developerLabel.adjustsFontSizeToFitWidth = true
        self.mapView.addSubview(developerLabel)

////////添加segmented control，影像和矢量切换/////////////////////////////////////////////////////////////////////////////////////////////////////////
        segmentedController.selectedSegmentIndex = 0
        segmentedController.isMomentary = false
        segmentedController.layer.cornerRadius = 5.0
        segmentedController.backgroundColor = UIColor.white
        segmentedController.tintColor = UIColor.blue
////////设置segment control字体颜色和字体大小
        
        let segmengtedControlDic:NSDictionary = [NSForegroundColorAttributeName:UIColor.blue,NSFontAttributeName:UIFont.boldSystemFont(ofSize: 15)]
        segmentedController.setTitleTextAttributes(segmengtedControlDic as? [AnyHashable : Any], for: UIControlState.normal)
////////添加segmente control值，改变监听，设置改变selectedSegmentIndex的值来添加不同的地图
        segmentedController.addTarget(self, action: #selector(ViewController.segmentedController(segmentedControlSender:)), for: .valueChanged)
        self.mapView.addSubview(segmentedController)                       //将segment control添加到视图中去。
        
////////初始化地图，设置显示范围（以行政中心往南500米为中点，2000米范围）///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        self.map = AGSMap()
        let agsPoint = AGSPoint(x: 497365, y: 3380040, spatialReference: AGSSpatialReference(wkid: 4549))
        let envelopeWK = AGSEnvelope(center: agsPoint, width: 2000, height: 2000)
        self.map.initialViewpoint = AGSViewpoint(targetExtent: envelopeWK)
        
////////右下角添加标签，显示当前地图中心点坐标（未实现）/////////////////////////////////////////////////////////////////////////////////////////////////
        centerPointLabel.text = String(format:"x: %.2f, y: %.2f", self.mapView.center.x,self.mapView.center.y)
        centerPointLabel.adjustsFontSizeToFitWidth = true
        self.mapView.addSubview(centerPointLabel)
        
////////加载shapfile数据，目前仅加载德清县镇街道行政区划,部分道路数据////////////////////////////////////////////////////////////////////////////////////////////////////
//        let polygonSHPFileTable = AGSShapefileFeatureTable(name: "BOU_PY_P")
//        let polygonSHPFileLayer = AGSFeatureLayer(featureTable: polygonSHPFileTable)
//        let outlineSymbol = AGSSimpleLineSymbol(style: .solid, color: .red, width: 1)
//        let fillSymbol = AGSSimpleFillSymbol(style: .solid, color: UIColor.yellow.withAlphaComponent(0.25), outline: outlineSymbol)
//        polygonSHPFileLayer.renderer = AGSSimpleRenderer(symbol: fillSymbol)
//
//        let linSHPFileTable = AGSShapefileFeatureTable(name:"TRA_NET_LN_P")
//        let lineSHPFileLayer = AGSFeatureLayer(featureTable: linSHPFileTable)
//        let lineSymbol = AGSSimpleLineSymbol(style: .dashDot, color: UIColor.blue, width: 2.0)
//        lineSHPFileLayer.renderer = AGSSimpleRenderer(symbol: lineSymbol)
        
//        let pointSHPFileTable = AGSShapefileFeatureTable(name:"POI_P")
//        let pointSHPFileLayer = AGSFeatureLayer(featureTable:pointSHPFileTable)
//        let pointSymbol = AGSSimpleMarkerSymbol(style: .X, color: UIColor.red, size: 3.0)
//        pointSHPFileLayer.renderer = AGSSimpleRenderer(symbol:pointSymbol)
        
////////获取segmented control默认加载项，并根据默认项价值地图//////////////////////////////////////////////////////////////////////////////////////////////
        let defaultSelectedSegmentIndex = segmentedController.selectedSegmentIndex
        if (defaultSelectedSegmentIndex == 0) {
            self.map.operationalLayers.add(tiledLayerImage)
//            self.map.operationalLayers.add(polygonSHPFileLayer)
//            self.map.operationalLayers.add(lineSHPFileLayer)
//            self.map.operationalLayers.add(pointSymbol)
        }else{
            self.map.operationalLayers.add(tiledLayerVector)
        }
        self.mapView.map = self.map
        
//        zoom(mapView: mapView, to: polygonSHPFileLayer)
//        featureLayer = polygonSHPFileLayer
}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
/////////响应segment control点击事件//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    func segmentedController(segmentedControlSender:XCUISegmentedControl) {
        switch (segmentedControlSender .selectedSegmentIndex) {
        case 0:
            self.map.operationalLayers.remove(tiledLayerVector)
            self.map.operationalLayers.add(tiledLayerImage)
        case 1:
            self.map.operationalLayers.remove(tiledLayerImage)
            self.map.operationalLayers.add(tiledLayerVector)
        default:
            break
        }
    }
    
    func compassAction() {
//        self.compassButton.transform = CGAffineTransform.identity
        self.mapView.setViewpointRotation(0, completion: nil)
        print("self.map.rotation %d", mapView.rotation)
        print("click the compassButton")
    }
    func xcuiviewButton0Action() {
        print("点击了多规按钮，将加载多规合一相关图层。")
        let menu = XCmenuTableViewController()
        let vc = UINavigationController(rootViewController: menu)
        let popover = UIPopoverController(contentViewController: vc)
        let cgrect = CGRect(x: 0, y: 30, width: 0, height: 0)
        popover.present(from: cgrect, in: xcuiviewButton0, permittedArrowDirections: UIPopoverArrowDirection.right, animated: true)
        
        menu.delegate = self
        self.popover = popover
    }

    func xcuiviewButton1Action() {
        print("点击了SHP按钮，将加载shape file数据。")
        let panoviewController = PanoViewController()
        let panoView = UINavigationController(rootViewController:panoviewController)
        let panoPopover = UIPopoverController(contentViewController: panoView)
        panoPopover.contentSize = CGSize(width:768 - 50, height:768 - 50)
        let cgrect = CGRect(x: 0, y: 30, width: 0, height: 0)
        panoPopover.present(from: cgrect, in: xcuiviewButton1, permittedArrowDirections: UIPopoverArrowDirection.right, animated: true)
    }
    
    func xcuiviewButton2Action() {
        let tdtDQ = AGSArcGISTiledLayer(url: URL(string:"http://220.191.216.230:6080/arcgis/rest/services/dghy_dzdt/MapServer")!)
        let loadStatusString = self.mapDidLoadStatus(self.map.loadStatus)
        if (loadStatusString == "Loaded") {
            self.map.operationalLayers.add(tdtDQ)

        }
        
    }
    
    func xcuiviewButton3Action() {
        print("点击了定位按钮，将定位到当前位置。")
    }
    
    func xcuiviewButton4Action() {
        print("点击了规划图集按钮。")
        let viewController = AtlasViewController()
        let atlasView = UINavigationController(rootViewController:viewController)
        let atlasPopover = UIPopoverController(contentViewController: atlasView)
        atlasPopover.contentSize = CGSize(width:768 - 50, height:768 - 50)
        let cgrect = CGRect(x: 0, y: 0, width: 0, height: 0)
        atlasPopover.present(from: cgrect, in: xcuiviewButton4, permittedArrowDirections: UIPopoverArrowDirection.right, animated: true)
        
        let width = atlasPopover.contentSize.width
        let height = atlasPopover.contentSize.height
        print("width,height",width,height)
    }
  
    func receivedRotation(){
//        let deviceOrientationIsPortrait = UIInterfaceOrientationIsPortrait()
        let deviceOrientationIsPortrait = UIDeviceOrientationIsPortrait(UIDevice.current.orientation)
        let XCScreenHeight = 1024
        let XCScreenWidth = 768
        if (deviceOrientationIsPortrait) {
            xcuiviewButton0.frame = CGRect(x: XCScreenWidth-60, y: XCScreenHeight - 120 - 4*80, width: 40, height: 60)
            xcuiviewButton1.frame = CGRect(x: XCScreenWidth-60, y: XCScreenHeight - 120 - 3*80, width: 40, height: 60)
            xcuiviewButton2.frame = CGRect(x: XCScreenWidth-60, y: XCScreenHeight - 120 - 2*80, width: 40, height: 60)
            xcuiviewButton3.frame = CGRect(x: XCScreenWidth-60, y: XCScreenHeight - 120 - 80, width: 40, height: 60)
            xcuiviewButton4.frame = CGRect(x: XCScreenWidth-60, y: XCScreenHeight - 120, width: 40, height: 60)
            segmentedController.frame = CGRect(x: XCScreenWidth - 130, y: 40, width: 100, height: 40)
            compassButton.frame = CGRect(x: 20, y: XCScreenHeight - 120, width: 60, height: 60)
            developerLabel.frame = CGRect(x: XCScreenWidth/2 - 150, y: XCScreenHeight - 80, width: 300, height: 44)
            centerPointLabel.frame = CGRect(x: XCScreenWidth/2 + 100, y: XCScreenHeight - 80, width: 300, height: 44)
        }else{
            xcuiviewButton0.frame = CGRect(x: XCScreenHeight-60, y: XCScreenWidth - 100 - 4*60, width: 40, height: 40)
            xcuiviewButton0.titleLabel?.isHidden = true
            xcuiviewButton1.frame = CGRect(x: XCScreenHeight-60, y: XCScreenWidth - 100 - 3*60, width: 40, height: 40)
            xcuiviewButton1.titleLabel?.isHidden = true
            xcuiviewButton2.frame = CGRect(x: XCScreenHeight-60, y: XCScreenWidth - 100 - 2*60, width: 40, height: 40)
            xcuiviewButton2.titleLabel?.isHidden = true
            xcuiviewButton3.frame = CGRect(x: XCScreenHeight-60, y: XCScreenWidth - 100 - 60, width: 40, height: 40)
            xcuiviewButton3.titleLabel?.isHidden = true
            xcuiviewButton4.frame = CGRect(x: XCScreenHeight-60, y: XCScreenWidth - 100, width: 40, height: 40)
            xcuiviewButton4.titleLabel?.isHidden = true
            segmentedController.frame = CGRect(x: XCScreenHeight - 130, y: 40, width: 100, height: 40)
            compassButton.frame = CGRect(x: 20, y: XCScreenWidth - 120, width: 60, height: 60)
            developerLabel.frame = CGRect(x: XCScreenHeight/2 - 150, y: XCScreenWidth - 80, width: 300, height: 44)
            centerPointLabel.frame = CGRect(x: XCScreenHeight/2 + 100, y: XCScreenWidth - 80, width: 300, height: 44)
        }
    }
    
    func zoom(mapView:AGSMapView, to featureLayer:AGSFeatureLayer) {
        // Ensure the feature layer's metadata is loaded.
        featureLayer.load { error in
            guard error == nil else {
                print("Couldn't load the shapefile \(error!.localizedDescription)")
                return
            }
            // Once the layer's metadata has loaded, we can read its full extent.
//            if let initialExtent = featureLayer.fullExtent {
//                mapView.setViewpointGeometry(initialExtent)
//            }
        }
    }
    func menuTableViewController(_ vc: XCmenuTableViewController!, didSelectUrl url: AGSArcGISTiledLayer!) {
        if (url != nil) {
            self.map.operationalLayers.remove(url)
            self.map.operationalLayers.add(url)
            self.popover.dismiss(animated: true)
            print("加载")
        }else{
            self.map.operationalLayers.remove(url)
            self.popover.dismiss(animated: true)
            print("移除")
        }
    }
    func mapDidLoadStatus(_ status: AGSLoadStatus) -> String {
        let alertController = UIAlertController(title: "网络提示", message: "请连接网络后重试！", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "确定", style: .default, handler: nil)
        alertController.addAction(okAction)

        switch status {
        case .failedToLoad:
            print("Failed_To_Load")
            self.present(alertController, animated: true, completion: nil)
            return "Failed_To_Load"
        case .loaded:
            print("Loaded")
            self.present(alertController, animated: true, completion: nil)
            return "Loaded"
        case .loading:
            print("Loading")
            return "Loading"
        case .notLoaded:
            print("Not_Loaded")
            self.present(alertController, animated: true, completion: nil)
            return "Not_Loaded"
        default:
            print("Unknown")
            self.present(alertController, animated: true, completion: nil)
            return "Unknown"
        }
    }
}

