//
//  ShopInfoDetailViewController.h
//  MYWowGoing
//
//  Created by zhangM on 13-7-25.
//
//
//此viewController用于显示详细店铺信息
#import <UIKit/UIKit.h>
#import "BaseController.h"
#import "EScrollerView.h"
@interface ShopInfoDetailViewController : BaseController<UIAlertViewDelegate,EScrollerViewDelegate>
@property (retain,nonatomic) NSString *brandId;  //品牌ID
@property (retain,nonatomic) NSString *shopId;    //店铺ID
@property (retain, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (retain, nonatomic) IBOutlet UIView *descriptionView;
@property (retain, nonatomic) IBOutlet UIButton *brandBtn;
@property (strong, nonatomic)  ASIFormDataRequest *requestForm;
@end
