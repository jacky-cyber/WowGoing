//
//  FileBSDownload
//  HuaShang
//
//  Created by Alur on 12-3-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Service.h"

@interface FileBSDownload : BizService

@property (nonatomic, retain) NSString *url;
@property (nonatomic, retain) UIProgressView *progress;

@end
