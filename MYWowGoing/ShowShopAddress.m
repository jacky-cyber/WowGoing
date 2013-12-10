//
//  ShowShopAddress.m
//  MYWowGoing
//
//  Created by zhangM on 13-1-14.
//
//

#import "ShowShopAddress.h"

@interface ShowShopAddress ()

@end

@implementation ShowShopAddress
@synthesize shopMap=_shopMap;
@synthesize locationManger=_locationManger;
@synthesize shopCoordinate;
@synthesize myAnnotation=_myAnnotation;
@synthesize shopName=_shopName;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [backBtn setFrame:CGRectMake(10, 6, 52, 32)];
		[backBtn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
        [backBtn setBackgroundImage:[UIImage imageNamed:@"返回按钮_正常.png"] forState:UIControlStateNormal];
		UIBarButtonItem *litem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
		self.navigationItem.leftBarButtonItem = litem;
		[litem release];
        
        self.title = @"定位";
    }
    return self;
}

- (void)backAction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:NO];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    
    //地图定位
    self.locationManger=[[[CLLocationManager alloc]init] autorelease];//创建定位控制器
    if ([CLLocationManager locationServicesEnabled]) {//判断定位是否可用
        self.locationManger.delegate=self;//设置代理
        self.locationManger.desiredAccuracy=kCLLocationAccuracyBest;//设置精度
        self.locationManger.distanceFilter=100;//设置距离过滤器
        [self.locationManger startUpdatingLocation];//开始定位
    }
   
//    self.shopMap.showsUserLocation=YES;//开启地图定位
    self.view.autoresizesSubviews=YES;//子视图大小自适应
    self.shopMap.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;//地图宽高自适应
    //self.mview.mapType=MKMapTypeSatellite;//三维卫星图
    self.shopMap.delegate=self;//地图的代理
}

//当注解添加成功后执行的代理
#pragma mark  ---MKMapViewDelegate---
-(void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views{
    for (id obj in views)
    {
        if ([obj isKindOfClass:[MKAnnotationView class]])
        {
            MKPinAnnotationView * pinAnnotationView = (MKPinAnnotationView *)obj;
            //自动显示气泡
            [mapView selectAnnotation:pinAnnotationView.annotation animated:YES];
        }
    }
}
//为地图添加注解后执行此代理
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    if ([annotation.title isEqualToString:@"Current Location"]==YES)
    {
        return nil;
    }
    static NSString * identifie = @"test";//定义重用标记
    MKPinAnnotationView *pinAnnotationView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:identifie];//通过重用标记获取注解视图
    if (pinAnnotationView == nil)//若没有可重用的注解视图则新建
    {
        pinAnnotationView = [[[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:identifie] autorelease];//新建注解视图
    }
    pinAnnotationView.pinColor = MKPinAnnotationColorRed;//设置注解视图的颜色(大头针的颜色)
    pinAnnotationView.animatesDrop = YES;//设置垂直下落的动画效果
    
    pinAnnotationView.userInteractionEnabled = YES;//开启用于交互
    pinAnnotationView.canShowCallout=YES;//显示气泡效果
    
    return pinAnnotationView;
}

//定位成功后启动的代理
-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    
    CLLocationCoordinate2D coor = self.shopCoordinate;//获取新位置的经纬度
    MKCoordinateRegion region;
    CLLocationCoordinate2D center = self.shopCoordinate;
    region.center = center;//设置地图显示的中心
    
    MKCoordinateSpan span;
    
    //这个表面现象比较像地图的分辨率
    span.latitudeDelta = 0.015f;
    span.longitudeDelta = 0.015f;
    region.span = span;
    _shopMap.region = region;//设置地图显示的范围
    
    _myAnnotation=[[MyAnnotation alloc]initWithCoordinate:coor];//创建自定义注解视图
    
    _myAnnotation.title=self.shopName;//设置注解视图的标题

    [self.shopMap addAnnotation:_myAnnotation];//添加注解视图
        
    [manager stopUpdatingLocation];//关闭定位
}

- (void)viewDidUnload
{
    [self setShopMap:nil];
    [super viewDidUnload];
   
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [_shopMap release];
    [_myAnnotation release];
    [_locationManger release];
    [_shopName release];
    [super dealloc];
}
@end
