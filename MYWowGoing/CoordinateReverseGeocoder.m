//
//  CoordinateReverseGeocoder.m
//  MYWowGoing
//
//  Created by mac on 12-6-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CoordinateReverseGeocoder.h"
#import "MobClick.h"
#import "CustomAlertView.h"
@interface CoordinateReverseGeocoder ()
@property (nonatomic,retain) NSString *detailAddressString;
- (void)startedReverseGeoderWithLatitude:(double)latitude longitude:(double)longitude;
- (void)start;
@end


static CoordinateReverseGeocoder *shareCoord;
@implementation CoordinateReverseGeocoder
@synthesize locationManager;
@synthesize city;
@synthesize stateHK;
@synthesize isOver;
//@synthesize Country;@property (nonatomic, retain)
//@synthesize geoCoder;

+ (void)getCurrentCity {
//    CoordinateReverseGeocoder *crg = [CoordinateReverseGeocoder getShareCoord];
//    shareCoord = crg;
//    [crg start];
    
    [[CoordinateReverseGeocoder getShareCoord] startGps];
}


+(id)getShareCoord
{
    if (shareCoord == NULL) {
        shareCoord = [[CoordinateReverseGeocoder alloc] init];
    }
    return shareCoord;
}

- (id)init {
    if ((self = [super init]) != nil) {
        self.locationManager = [[[CLLocationManager alloc] init] autorelease];
        self.locationManager.delegate = self;
//        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
        self.locationManager.distanceFilter = 100;
       
        isOver = NO;
    }
    return self;
}
- (void)startGps {
    
    
    if (self.locationManager != nil) {
        [self.locationManager startUpdatingLocation]; 
        [self.locationManager performSelector:@selector(stopUpdatingLocation) withObject:nil afterDelay:15];
    }

}

- (void)startedReverseGeoderWithLatitude:(double)latitude longitude:(double)longitude {
    
    CLLocationCoordinate2D coordinate2D;
    
    coordinate2D.longitude = longitude;
    
    coordinate2D.latitude = latitude;
    
}


- (void)dealloc {
   
    [locationManager release];
    [_detailAddressString release],_detailAddressString = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark locationManager delegate

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    
    //得到当前的地理坐标    
    CLLocationDistance l = newLocation.coordinate.latitude;//得到纬度
    CLLocationDistance v = newLocation.coordinate.longitude;//得到经度
    //统计用户的地理位置信息
    [MobClick setLatitude:v longitude:l];
    if ((int)l == 0 && (int)v == 0 ) {
        return;
    }
    
    //存储当前经纬度信息
    NSMutableDictionary *pointDic = [NSMutableDictionary dictionary];
    [pointDic setValue:[NSNumber numberWithFloat:v] forKey:@"longitude"];
    [pointDic setValue:[NSNumber numberWithFloat:l] forKey:@"latitude"];
    [Util saveCurrentLocationPoint:pointDic];
    
    NSLog(@"当前的地理坐标 :%f, %f", l, v);
    [self.locationManager stopUpdatingLocation];
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        
        for (CLPlacemark *place in placemarks) {
        
            city = [place.addressDictionary valueForKey:@"City"];
        
            self.Country = [place.addressDictionary valueForKey:@"Country"];
            
            self.detailAdressName = [place.addressDictionary valueForKey:@"Name"];
  
            stateHK = [place.addressDictionary valueForKey:@"State"];

            NSArray *FormattedAddressLines = [place.addressDictionary valueForKey:@"FormattedAddressLines"];
            NSString *addressLinesString = [NSString stringWithFormat:@"%@",[FormattedAddressLines objectAtIndex:0]];
            _detailAddressString = addressLinesString;
        }
        
        
        if (error) {
            isOver = NO;
            return;
        }
        
        isOver = YES;
        
    }];
    
    [geocoder release];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
   
    NSLog(@"定位错误 Error 选中了不允许定位: %@", error);
    int errorCode = [error code];
    if (errorCode == kCLErrorGeocodeCanceled) {
        NSLog(@"取消了定位1");
    }
    else if (errorCode == kCLErrorRegionMonitoringDenied) {
        NSLog(@"取消了定位2");
    }
    else if (errorCode == kCLErrorDenied){
        
//        if (_delegate && [_delegate respondsToSelector:@selector(cllocationAlert)]) {
//            [_delegate cllocationAlert];
//        }
        CustomAlertView *alert = [[[CustomAlertView alloc] initWithTitle:nil
                                                                 message:@"购引需要您打开定位服务才可以使用请在“设置-隐私”中打开定位服务"
                                                                delegate:self
                                                       cancelButtonTitle:nil
                                                       otherButtonTitles:@"好", nil]
                                  autorelease];
        [alert show];
        return;
        NSLog(@"取消了定位3");
    }
     return;
}


#pragma mark -
#pragma mark MKReverseGeocoderDelegate delegate

//
//- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFindPlacemark:(MKPlacemark *)placemark{
//    
//    
//    NSLog(@"addressDictionary :%@", placemark.addressDictionary);
//    NSLog(@"thoroughfare :%@", placemark.thoroughfare);
//    NSLog(@"subThoroughfare :%@", placemark.subThoroughfare);
//    NSLog(@"locality :%@", placemark.locality);
//    NSLog(@"subLocality :%@", placemark.subLocality);
//    NSLog(@"administrativeArea :%@", placemark.administrativeArea);
//    NSLog(@"subAdministrativeArea :%@", placemark.subAdministrativeArea);
//    NSLog(@"postalCode :%@", placemark.postalCode);
//    NSLog(@"country :%@", placemark.country);
//    NSLog(@"countryCode :%@", placemark.countryCode);
//    
//    [self release];
//}
//
//- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFailWithError:(NSError *)error {
//    
//    NSLog(@"城市解析错误 Error: %@", error);
//    [self release];
//}

- (void)start {
    
}



+ (BOOL)locationServicesEnabled {
    if (([CLLocationManager locationServicesEnabled]) && ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied)) {
        
        NSLog(@"手机gps定位已经开启");
        return YES;
    } else {
        
        NSLog(@"手机gps定位未开启");
        return NO;
    } 
}

@end
