//
//  UIDataButton.m
//  MYWowGoing
//
//  Created by mac on 12-8-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UIDataButton.h"

@implementation UIDataButton
@synthesize data;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        data = [[NSMutableDictionary alloc] initWithCapacity:0];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)dealloc
{
    [super dealloc];
    [data release];
}

@end
