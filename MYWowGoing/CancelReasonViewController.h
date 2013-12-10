//
//  CancelReasonViewController.h
//  MYWowGoing
//
//  Created by ZhangMeng on 13-8-5.
//
//

#import <UIKit/UIKit.h>
#import "BaseController.h"

@protocol CancleReasonProtocol <NSObject>

- (void) cancleReasonProtocolMethed;

@end



@interface CancelReasonViewController : BaseController
@property (retain, nonatomic) NSMutableDictionary *productDic;
@property (assign,nonatomic) id<CancleReasonProtocol> delegate;
@end
