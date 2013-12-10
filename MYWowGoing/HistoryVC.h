//
//  HistoryVC.h
//  MYWowGoing
//
//  Created by WangKaifeng on 13-2-22.
//
//

#import <UIKit/UIKit.h>
#import "BaseController.h"
#import "ProductDetailViewController_Detail2.h"
@interface HistoryVC :BaseController <UITableViewDataSource,UITableViewDelegate>{
    MBProgressHUD *mbhud;
}

@property (nonatomic, retain)NSMutableArray *historyArray;
@property (retain, nonatomic) IBOutlet UITableView *myTableView;
@property (nonatomic, strong) ProductDetailViewController_Detail2  *proDetailView;

@end
