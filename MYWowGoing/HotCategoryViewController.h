//
//  HotCategoryViewController.h
//  MYWowGoing
//
//  Created by ZhangMeng on 13-8-3.
//
//

#import <UIKit/UIKit.h>
#import "UIFolderTableView.h"
#import "BaseController.h"
@interface HotCategoryViewController : BaseController<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) NSArray *cates;
@property (retain, nonatomic) IBOutlet UIFolderTableView *folderTbaleView;
@end
