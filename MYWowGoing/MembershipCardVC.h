//
//  MembershipCardVC.h
//  MYWowGoing
//
//  Created by WangKaifeng on 13-7-29.
//
//

#import <UIKit/UIKit.h>
#import "UIFolderTableView.h"
@class SubCateViewController;
@interface MembershipCardVC : UIViewController <UITableViewDataSource,UITableViewDelegate,UIFolderTableViewDelegate>

@property (retain, nonatomic) IBOutlet UIPageControl *memberPageControl;
@property (retain, nonatomic) IBOutlet UIImageView *memberCartPageControl;
@property (assign, nonatomic) NSArray *cates;
@property (retain, nonatomic) IBOutlet UIScrollView *memberCartScroller;
@property (strong, nonatomic) IBOutlet UIFolderTableView *tableView;
@property (assign, nonatomic) NSMutableArray *dataList;
@property (retain, nonatomic) IBOutlet UILabel *specialoffersLabel;

@property (strong, nonatomic) SubCateViewController *subVc;
@property (assign, nonatomic) NSDictionary *currentCate;
@property (assign) BOOL isOpen;
@property (nonatomic,retain)NSIndexPath *selectIndex;
@end

