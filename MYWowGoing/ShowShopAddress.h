//
//  ShowShopAddress.h
//  MYWowGoing
//
//  Created by zhangM on 13-1-14.
//
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "MyAnnotation.h"

@interface ShowShopAddress : UIViewController<CLLocationManagerDelegate,MKMapViewDelegate>
@property (retain, nonatomic) IBOutlet MKMapView *shopMap;//地图
@property (retain,nonatomic) CLLocationManager *locationManger;
@property (assign,nonatomic) CLLocationCoordinate2D shopCoordinate;
@property (retain,nonatomic) MyAnnotation *myAnnotation;//标注
@property (copy,nonatomic) NSString *shopName;//店铺名称

@end
