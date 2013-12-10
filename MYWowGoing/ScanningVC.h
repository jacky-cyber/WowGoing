//
//  ScanningVC.h
//  MYWowGoing
//
//  Created by zhangM on 13-1-11.
//
//

#import <UIKit/UIKit.h>
#import "ZBarSDK.h"
#import "BaseController.h"
@interface ScanningVC :BaseController <ZBarReaderViewDelegate>
@property (nonatomic,assign) int type;  // 1.扫会员卡     2. 扫推荐人  
@end
