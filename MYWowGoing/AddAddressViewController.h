//
//  AddAddressViewController.h
//  MYWowGoing
//
//  Created by ZhangMeng on 13-8-9.
//
//

#import <UIKit/UIKit.h>
#import "BaseController.h"

@protocol postProtocol <NSObject>

- (void) postProtocolMethod;

@end

@interface AddAddressViewController : BaseController

@property(assign,nonatomic) id<postProtocol> delegate;

@end
