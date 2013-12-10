//
//  CoordinateReverseGeocoder.h
//  MYWowGoing
//
//  Created by mac on 12-6-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@protocol CllocationDelegate <NSObject>

- (void)cllocationAlert;

@end
@interface CoordinateReverseGeocoder : NSObject<CLLocationManagerDelegate>{
    CLLocationManager *locationManager;
//    MKReverseGeocoder *geoCoder;
    NSString *city;
    NSString *stateHK;
//    NSString *Country;
    
    BOOL isOver;
}
@property (nonatomic, assign) NSObject <CllocationDelegate> *delegate;
@property (nonatomic ,assign) BOOL isOver;
@property (nonatomic, retain) CLLocationManager *locationManager;
//@property (nonatomic, retain) MKReverseGeocoder *geoCoder;
@property (nonatomic,retain) NSString *stateHK;
@property (nonatomic, retain) NSString *city;
@property (nonatomic, retain) NSString *Country;
@property (nonatomic, retain) NSString *detailAdressName;

+ (void)getCurrentCity;
+(id)getShareCoord;
-(void)startGps;
+ (BOOL)locationServicesEnabled;
@end
