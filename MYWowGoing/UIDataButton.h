//
//  UIDataButton.h
//  MYWowGoing
//
//  Created by mac on 12-8-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIDataButton : UIButton
{
    NSMutableDictionary  *data;
   

}
@property (nonatomic ,retain) NSMutableDictionary  *data;

@end
