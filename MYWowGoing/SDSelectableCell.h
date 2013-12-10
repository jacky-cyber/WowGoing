//
//  SDSelectableCell.h
//  SDNestedTablesExample
//
//  Created by Daniele De Matteis on 23/05/2012.
//  Copyright (c) 2012 Daniele De Matteis. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SDNestedTableViewController;

typedef enum
{
    Unchecked = 0,
    Checked,
//    Halfchecked,
}
SelectableCellState;

@interface SDSelectableCell : UITableViewCell
{
    IBOutlet UIView *checkBox;
    
    IBOutlet UIView *tapTransitionsOverlay;
}
@property(nonatomic,retain)  UIImageView *onCheckBox;
@property(nonatomic,retain)  IBOutlet UIImageView *offCheckBox;
@property (nonatomic,retain) IBOutlet UILabel *itemText;
@property (retain, nonatomic) IBOutlet UIImageView *fengexian;
@property (retain, nonatomic) IBOutlet UIImageView *flagImage;

@property (retain, nonatomic) IBOutlet UILabel *selectedItemName;
@property (nonatomic, retain) SDNestedTableViewController *parentTable;
@property (nonatomic,assign) SelectableCellState selectableCellState;

- (SelectableCellState) toggleCheck;
- (void) check;
- (void) uncheck;

- (void) styleEnabled;
- (void) styleDisabled;
- (void) styleHalfEnabled;
- (void) tapTransition;

- (void) setupInterface;

@end
