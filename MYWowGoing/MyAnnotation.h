//
//  MyAnnotation.h
//  UILlocation
//
//  Created by Ibokan on 12-10-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
@interface MyAnnotation : NSObject<MKAnnotation>//自定义地图注解类
@property (nonatomic) CLLocationCoordinate2D coordinate;//
@property (nonatomic, copy) NSString *title;
//@property (nonatomic, copy) NSString *subtitle;
-(id)initWithCoordinate:(CLLocationCoordinate2D)newCoordinate;
@end
