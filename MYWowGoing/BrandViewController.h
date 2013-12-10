//
//  BrandViewController.h
//  MYWowGoing
//
//  Created by mayizhao on 13-1-10.
//
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "BaseController.h"

/*
  功能描述: 品牌关注
 */
@interface BrandViewController : BaseController<UITableViewDataSource,UITableViewDelegate,MBProgressHUDDelegate>

@property (retain, nonatomic) IBOutlet UIImageView *allSelectImageView;
@property (retain, nonatomic) IBOutlet UIButton *allBtn;

@property(nonatomic,retain) NSMutableDictionary *brandDic;
@property(nonatomic,retain) NSMutableArray *allKeys;

@end
