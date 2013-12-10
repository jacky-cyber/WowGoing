//
//  SDGroupCell.h
//  SDNestedTablesExample
//
//  Created by Daniele De Matteis on 21/05/2012.
//  Copyright (c) 2012 Daniele De Matteis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDSubCell.h"
#import "SDSelectableCell.h"

#import "UIFolderTableView.h"


typedef enum {
    AllSubCellsCommandChecked,
    AllSubCellsCommandUnchecked,
    AllSubCellsCommandNone,
} AllSubCellsCommand;

static const int height = 47;
static const int subCellHeight = 48;
static const int  buttonHeight = 35;

@interface SDGroupCell : SDSelectableCell <UITableViewDelegate, UITableViewDataSource,UIFolderTableViewDelegate>
{
    AllSubCellsCommand subCellsCommand;
}

@property (retain, nonatomic) IBOutlet UIButton *expandBtn;

@property (assign,nonatomic) BOOL isExpanded;
@property (retain,nonatomic) IBOutlet UITableView*subTable;
@property (retain,nonatomic) IBOutlet SDSubCell *subCell;
@property (nonatomic,assign) int subCellsAmt;
@property (assign,nonatomic) int selectedSubCellsAmt;
@property (nonatomic, retain) NSMutableDictionary *selectableSubCellsState;

@property (nonatomic,assign) BOOL  opening0;
@property (nonatomic,assign) BOOL  opening1;
@property (nonatomic,assign) BOOL  opening2;
@property (nonatomic,assign) BOOL  opening3;
@property (nonatomic,assign) BOOL  opening4;
@property (nonatomic,assign) BOOL  opening5;
@property (nonatomic,assign) BOOL  opening6;

@property (assign,nonatomic) int count;

- (void) subCellsToggleCheck;
- (void) rotateExpandBtn:(id)sender;
- (void) rotateExpandBtnToExpanded;
- (void) rotateExpandBtnToCollapsed;

+ (int) getHeight;
+ (int) getsubCellHeight;

@end
