//
//  MySettingViewController.h
//  MYWowGoing
//
//  Created by WangKaifeng on 13-1-9.
//
//

#import <UIKit/UIKit.h>
#import "ZBarSDK.h"
#import "BaseController.h"
#import "MyPhoneNumberViewController.h"
@protocol gpsLoadDelegete;
@protocol gpsLoadDelegete <NSObject>
-(void)loadGPSData;

@end
@interface MySettingViewController : BaseController <UITableViewDelegate,UITableViewDataSource>
@property (retain, nonatomic) IBOutlet UIView *myView;
@property (retain, nonatomic) IBOutlet UITableView *myTableView;
@property(assign,nonatomic) NSObject <gpsLoadDelegete> *delegate;

@end
