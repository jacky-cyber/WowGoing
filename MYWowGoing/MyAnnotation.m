//
//  MyAnnotation.m
//  UILlocation
//
//  Created by Ibokan on 12-10-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MyAnnotation.h"

@implementation MyAnnotation
@synthesize coordinate,title,subtitle;
-(id)initWithCoordinate:(CLLocationCoordinate2D)newCoordinate  
{
    self = [super init];
    if (self) 
    {
        coordinate=newCoordinate;
    }
    
    return  self;
}

-(void)dealloc
{
    self.title=nil;
//  self.subtitle=nil;
    [super  dealloc];
}

@end
