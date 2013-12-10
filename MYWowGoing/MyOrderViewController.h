//
//  MyOrderViewController.h
//  MYWowGoing
//
//  Created by WangKaifeng on 13-1-10.
//
//

#import <UIKit/UIKit.h>
#import "JSON.h"
#import "EGORefreshTableFooterView.h"
#import "EGORefreshTableHeaderView.h"
#import "BaseController.h"

@interface MyOrderViewController :  BaseController <UITableViewDataSource,UITableViewDelegate, EGORefreshTableHeaderDelegate, UIAlertViewDelegate>

@property (retain, nonatomic) EGORefreshTableHeaderView *refreshHeaderView;
@property (retain, nonatomic) EGORefreshTableFooterView *refreshFooterView;
@property (retain, nonatomic) IBOutlet UIButton *noPayBtn;
@property (retain, nonatomic) IBOutlet UIButton *payBtn;
@property (retain, nonatomic) IBOutlet UIButton *invalidBtn;
@property (retain, nonatomic) IBOutlet UITableView *myTableView;
@property (assign, nonatomic) int nowPageNum;
@property (retain, nonatomic) IBOutlet UIView *baseView;
@property (retain, nonatomic) IBOutlet UIView *alertViewPhone;

- (IBAction)shopGoAction:(id)sender;


- (IBAction)noPayAction:(id)sender;
- (IBAction)payOkAction:(id)sender;
- (IBAction)invalidAction:(id)sender;
- (IBAction)okRefundAction:(id)sender;

@end
