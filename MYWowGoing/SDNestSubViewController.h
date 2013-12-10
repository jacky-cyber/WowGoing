//
//  SDNestSubViewController.h
//  MYWowGoing
//
//  Created by ZhangMeng on 13-8-13.
//
//

#import <UIKit/UIKit.h>
#import "SDNestTableVC.h"
@interface SDNestSubViewController : UIViewController
@property (strong, nonatomic) NSArray *subCates;
@property (strong, nonatomic) SDNestTableVC *hotCateVC;
@end
