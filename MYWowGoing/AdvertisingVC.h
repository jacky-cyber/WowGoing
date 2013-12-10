//
//  AdvertisingVC.h
//  MYWowGoing
//
//  Created by WangKaifeng on 13-4-9.
//
//

#import <UIKit/UIKit.h>
#import "BrandViewController.h"
#import "ScanningVC.h"
#import "AdView.h"
#import "GuidanceVC.h"
#import "CoordinateReverseGeocoder.h"

@interface AdvertisingVC : BaseController <UIGestureRecognizerDelegate,UIScrollViewDelegate,ADDelegate,UITextFieldDelegate>
{
    GuidanceVC *appStartController;
    UIImageView *selectImageView;
}

@property (nonatomic,retain) NSTimer  *checkGPSTimer;
@property (assign) BOOL      isXiangGang;
@property (assign) BOOL      isGPSFailed;
@property (assign) BOOL      isGPSOk;
@property (assign) int        gpsTimer;
@property (retain, nonatomic) IBOutlet UIButton *cityNameButton;
@property (nonatomic,retain) NSString  *cityName;
@property (nonatomic,retain) MBProgressHUD *HUD;
@property (retain, nonatomic) IBOutlet UIView *gpsView;
@property (retain, nonatomic) IBOutlet UITextField *codeTextField;
@property (retain, nonatomic) IBOutlet UIImageView *adImageView;
@property (retain, nonatomic) IBOutlet UIButton *doneInKeyboardButton;
@property (strong, nonatomic) AdView *view_Ad;
@property (retain, nonatomic) IBOutlet UIView *adView;
@property (retain, nonatomic) IBOutlet UIImageView *gpsImageView;
- (IBAction)skipAction:(id)sender;
//广告视图
@property (nonatomic, retain) UIView *ADView;
//删除广告界面定时期
@property (nonatomic, retain) NSTimer *removeADTimer;
@property (retain, nonatomic) IBOutlet UIImageView *xsImageView;
@property (retain, nonatomic) IBOutlet UIImageView *xpImageView;
@property (retain, nonatomic) IBOutlet UIButton *gpsButton;


//点击立刻定位
- (IBAction)gpsStartAction:(id)sender;

- (IBAction)xsClick:(id)sender;
- (IBAction)evaluateAction:(id)sender;
- (IBAction)newDIscountAction:(id)sender;
- (IBAction)resetGPSAction:(id)sender;
+ (AdvertisingVC *)sharedManager;
- (void)addAdViewLoading;
@end
