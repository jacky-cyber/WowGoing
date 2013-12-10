//
//  EditingMemberCardViewController.h
//  MYWowGoing
//
//  Created by zhangM on 13-7-29.
//
//

#import <UIKit/UIKit.h>
#import "BaseController.h"
@interface EditingMemberCardViewController : BaseController <UITextFieldDelegate>
@property (assign,nonatomic) int flagCardType;
@property (retain, nonatomic) IBOutlet UITextField *card;

@property (retain, nonatomic) NSString *memberInfoIdString;
@property (retain, nonatomic) NSString *memberNumberString;
@property (retain, nonatomic) NSString *memberTypeString;

- (IBAction)textFieldDoneEditing:(id)sender;
@end
