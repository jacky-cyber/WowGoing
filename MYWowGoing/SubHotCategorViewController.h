//
//  SubHotCategorViewController.h
//  MYWowGoing
//
//  Created by ZhangMeng on 13-8-3.
//
//

#import <UIKit/UIKit.h>
#import "HotCategoryViewController.h"

@interface SubHotCategorViewController : UIViewController
@property (strong, nonatomic) NSArray *subCates;
@property (strong, nonatomic) HotCategoryViewController*hotCateVC;

@end
