//
//  AboutVC.h
//  MYWowGoing
//
//  Created by WangKaifeng on 13-1-12.
//
//

#import <UIKit/UIKit.h>
#import "UMFeedback.h"

@interface AboutVC : UIViewController<UITableViewDataSource,UITableViewDelegate,UMFeedbackDataDelegate>{
    UMFeedback *_umFeedback;
}
@property(nonatomic, strong) UMFeedback *umFeedback;
@property(nonatomic, retain) UITextField *nameField;
@property(nonatomic, retain) UITextField *emailField;
@property(nonatomic, retain) UITextField *contentField;
@property (retain, nonatomic) IBOutlet UILabel *vLabel; //显示版本

@property (retain, nonatomic) IBOutlet UITableView *myTableview;
@property (retain, nonatomic) IBOutlet UITextView *myTextView;
@property (retain, nonatomic) NSArray *items;
@end
