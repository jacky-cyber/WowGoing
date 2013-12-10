//
//  MySizeVC.h
//  MYWowGoing
//
//  Created by WangKaifeng on 13-1-10.
//
//

#import <UIKit/UIKit.h>
#import "BaseController.h"
@interface MySizeVC :BaseController  <UIPickerViewDataSource,UIPickerViewDelegate>

@property (retain, nonatomic) IBOutlet UIView *pickView;
@property (retain, nonatomic) IBOutlet UIPickerView *pv;
@property (nonatomic, retain) NSArray *pickerData;

@property (retain, nonatomic) IBOutlet UILabel *ageBtn;
@property (retain, nonatomic) IBOutlet UILabel *weightBtn;
@property (retain, nonatomic) IBOutlet UILabel *heightBtn;
@property (retain, nonatomic) IBOutlet UIButton *bmiBtn;
@property (retain, nonatomic) IBOutlet UILabel *shangSizeBtn;
@property (retain, nonatomic) IBOutlet UILabel *kuSizeBtn;
@property (retain, nonatomic) IBOutlet UILabel *shoesBtn;
@property (retain, nonatomic) IBOutlet UILabel *typeLabel;
@property (retain, nonatomic) IBOutlet UILabel *sexBtn;
@property (retain, nonatomic) IBOutlet UIView *BMIView;
- (IBAction)hidenPickView:(id)sender;
- (IBAction)ageBtnAction:(id)sender;
- (IBAction)bmiAction:(id)sender;


@end
