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

class ViewController: UIViewController {
    @IBOutlet var mapView: AGSMapView!
//    var segmentedController: XCUISegmentedControl!
    var map:AGSMap!
    var geodatabase:AGSGeodatabase!
    var featureLayer:AGSFeatureLayer?
    
    let segmentedController = XCUISegmentedControl(items:["影像","矢量"])
    
    let xcuiviewButton1 = XCUIViewButton()
    let xcuiviewButton2 = XCUIViewButton()
    let xcuiviewButton3 = XCUIViewButton()
    let xcuiviewButton4 = XCUIViewButton()
    let compassButton = CompassButton()
    let developerLabel = XCUILabel()
    let centerPointLabel = XCUILabel()

    let tiledLayerImage = AGSArcGISTiledLayer(name:"影像地图TPK")
    let tiledLayerVector = AGSArcGISTiledLayer(name:"电子地图TPK")
    
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
        let xcuiviewButtonImage1 = UIImage.init(named: "layer.png")
        let xcuiviewButtonTitle1 = "多规"
        xcuiviewButton1.setImage(xcuiviewButtonImage1, for: UIControlState.normal)
        xcuiviewButton1.setTitle(xcuiviewButtonTitle1, for: UIControlState.normal)
        self.mapView.addSubview(xcuiviewButton1)
        
////////添加控件,天地图////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        let xcuiviewButtonImage2 = UIImage.init(named: "WorldMap.png")
        let xcuiviewButtonTitle2 = "天地图"
        xcuiviewButton2.setImage(xcuiviewButtonImage2, for: UIControlState.normal)
        xcuiviewButton2.setTitle(xcuiviewButtonTitle2, for: UIControlState.normal)
        self.mapView.addSubview(xcuiviewButton2)
        
////////添加控件,定位////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        let xcuiviewButtonImage3 = UIImage.init(named: "point.png")
        let xcuiviewButtonTitle3 = "定位"
        xcuiviewButton3.setImage(xcuiviewButtonImage3, for: UIControlState.normal)
        xcuiviewButton3.setTitle(xcuiviewButtonTitle3, for: UIControlState.normal)
        self.mapView.addSubview(xcuiviewButton3)
        
////////添加控件,规划图集////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        let xcuiviewButtonImage4 = UIImage.init(named: "point.png")
        let xcuiviewButtonTitle4 = "规划"
        xcuiviewButton4.setImage(xcuiviewButtonImage4, for: UIControlState.normal)
        xcuiviewButton4.setTitle(xcuiviewButtonTitle4, for: UIControlState.normal)
        self.mapView.addSubview(xcuiviewButton4)
        
////////添加屏幕下方中间"Developer:XiaoChun，15906721241"//////////////////////////////////////////////////////////////////////////////////////////
        developerLabel.text = "Developer:XiaoChun，15906721241"
        developerLabel.adjustsFontSizeToFitWidth = true
        self.mapView.addSubview(developerLabel)
        
////////右下角添加标签，显示当前地图中心点坐标（未实现）/////////////////////////////////////////////////////////////////////////////////////////////////
        centerPointLabel.text = String(format:"x: %.2f, y: %.2f", self.mapView.center.x,self.mapView.center.y)
        centerPointLabel.adjustsFontSizeToFitWidth = true
        self.mapView.addSubview(centerPointLabel)
        
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
        
////////加载GDB数据
//        self.geodatabase = AGSGeodatabase(name:"莫干山")
//        let featureTable = geodatabase.geodatabaseFeatureTable(withName: "BOU_PY")
//        let featureLayer = AGSFeatureLayer(featureTable:featureTable!)
//        self.map.operationalLayers.add(featureLayer)
////////加载shapfile数据，目前仅加载德清县镇街道行政区划////////////////////////////////////////////////////////////////////////////////////////////////////
        let polygonSHPFileTable = AGSShapefileFeatureTable(name: "BOU_PY_P")
        let polygonSHPFileLayer = AGSFeatureLayer(featureTable: polygonSHPFileTable)
        let outlineSymbol = AGSSimpleLineSymbol(style: .solid, color: .red, width: 1)
        let fillSymbol = AGSSimpleFillSymbol(style: .solid, color: UIColor.yellow.withAlphaComponent(0.25), outline: outlineSymbol)
        polygonSHPFileLayer.renderer = AGSSimpleRenderer(symbol: fillSymbol)

        let linSHPFileTable = AGSShapefileFeatureTable(name:"TRA_NET_LN_P")
        let lineSHPFileLayer = AGSFeatureLayer(featureTable: linSHPFileTable)
        let lineSymbol = AGSSimpleLineSymbol(style: .dashDot, color: UIColor.blue, width: 2.0)
        lineSHPFileLayer.renderer = AGSSimpleRenderer(symbol: lineSymbol)
        
//        let pointSHPFileTable = AGSShapefileFeatureTable(name:"POI_P")
//        let pointSHPFileLayer = AGSFeatureLayer(featureTable:pointSHPFileTable)
//        let pointSymbol = AGSSimpleMarkerSymbol(style: .X, color: UIColor.red, size: 3.0)
//        pointSHPFileLayer.renderer = AGSSimpleRenderer(symbol:pointSymbol)
        
////////获取segmented control默认加载项，并根据默认项价值地图//////////////////////////////////////////////////////////////////////////////////////////////
        let defaultSelectedSegmentIndex = segmentedController.selectedSegmentIndex
        if (defaultSelectedSegmentIndex == 0) {
            self.map.operationalLayers.add(tiledLayerImage)
            self.map.operationalLayers.add(polygonSHPFileLayer)
            self.map.operationalLayers.add(lineSHPFileLayer)
//            self.map.operationalLayers.add(pointSymbol)
        }else{
            self.map.operationalLayers.add(tiledLayerVector)
        }
        self.mapView.map = self.map
        
        zoom(mapView: mapView, to: polygonSHPFileLayer)
        
        featureLayer = polygonSHPFileLayer
        
        
        
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
    func receivedRotation(){
//        let deviceOrientationIsPortrait = UIInterfaceOrientationIsPortrait()
        let deviceOrientationIsPortrait = UIDeviceOrientationIsPortrait(UIDevice.current.orientation)
        let XCScreenHeight = 1024
        let XCScreenWidth = 768
        if (deviceOrientationIsPortrait) {
            xcuiviewButton1.frame = CGRect(x: XCScreenWidth-60, y: XCScreenHeight - 120 - 3*80, width: 40, height: 60)
            xcuiviewButton2.frame = CGRect(x: XCScreenWidth-60, y: XCScreenHeight - 120 - 2*80, width: 40, height: 60)
            xcuiviewButton3.frame = CGRect(x: XCScreenWidth-60, y: XCScreenHeight - 120 - 80, width: 40, height: 60)
            xcuiviewButton4.frame = CGRect(x: XCScreenWidth-60, y: XCScreenHeight - 120, width: 40, height: 60)
            segmentedController.frame = CGRect(x: XCScreenWidth - 130, y: 40, width: 100, height: 40)
            compassButton.frame = CGRect(x: 20, y: XCScreenHeight - 120, width: 60, height: 60)
            developerLabel.frame = CGRect(x: XCScreenWidth/2 - 150, y: XCScreenHeight - 80, width: 300, height: 44)
            centerPointLabel.frame = CGRect(x: XCScreenWidth/2 + 100, y: XCScreenHeight - 80, width: 300, height: 44)
        }else{
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

}

