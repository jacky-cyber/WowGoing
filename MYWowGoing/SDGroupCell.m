//
//  SDGroupCell.m
//  SDNestedTablesExample
//
//  Created by Daniele De Matteis on 21/05/2012.
//  Copyright (c) 2012 Daniele De Matteis. All rights reserved.
//

#import "SDGroupCell.h"
#import <QuartzCore/QuartzCore.h>
#import "SDNestedTableViewController.h"

@implementation SDGroupCell

@synthesize isExpanded, subTable, subCell, subCellsAmt, selectedSubCellsAmt, selectableSubCellsState;

+ (int) getHeight
{
    return height;
}

+ (int) getsubCellHeight
{
    return subCellHeight;
}

#pragma mark - Lifecycle

- (id) initWithCoder:(NSCoder *)aDecoder
{
    if((self = [super initWithCoder:aDecoder]))
    {
        subCellsCommand = AllSubCellsCommandNone;
    }
    return self;
}

- (void) setupInterface
{
    [super setupInterface];
    
    self.expandBtn.frame = CGRectMake(0,0,253,47);
    self.expandBtn.tag = 1200;
    [self.expandBtn setBackgroundColor:[UIColor clearColor]];
    [self.expandBtn addTarget:self.parentTable action:@selector(collapsableButtonTapped:withEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.expandBtn addTarget:self action:@selector(rotateExpandBtn:) forControlEvents:UIControlEventTouchUpInside];
   self.expandBtn.alpha = 1.0;
    
}

#pragma mark - behavior

-(void) rotateExpandBtn:(id)sender
{
    isExpanded = !isExpanded;
    switch (isExpanded) {
        case 0:
            [self rotateExpandBtnToCollapsed];
            break;
        case 1:
            [self rotateExpandBtnToExpanded];
            break;
        default:
            break;
    }
}

- (void)rotateExpandBtnToExpanded
{
    [self.expandBtn setBackgroundImage:[UIImage imageNamed:@"liebiaojiantou_shang.png"] forState:UIControlStateNormal];
}

- (void)rotateExpandBtnToCollapsed
{
    [self.expandBtn setBackgroundImage:[UIImage imageNamed:@"liebiaojiantou_xia.png"] forState:UIControlStateNormal];
}

- (SelectableCellState) toggleCheck
{
    SelectableCellState cellState = [super toggleCheck];
    if (self.selectableCellState == Checked)
    {
        self.expandBtn.alpha = 1.0;
    }
    else
    {
        self.expandBtn.alpha = 1.0;
    }
    return cellState;
}

- (void)check {
    [super check];
    self.expandBtn.alpha = 1.0;
}

- (void) uncheck {
    [super uncheck];
    self.expandBtn.alpha = 1.0;
}

- (void) subCellsToggleCheck
{
    
    if (self.selectableCellState == Checked)
    {
        subCellsCommand = AllSubCellsCommandChecked;
    }
    else
    {
        
        subCellsCommand = AllSubCellsCommandUnchecked;
    }
    for (int i = 0; i < subCellsAmt; i++)
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        [self tableView:subTable didSelectRowAtIndexPath:indexPath];
    }
    subCellsCommand = AllSubCellsCommandNone;
}

- (void) tapTransition
{
    [super tapTransition];
}

#pragma mark - Table view

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return subCellsAmt;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    SDSubCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SubCell"];
    
    if (cell == nil)
    {
        [[NSBundle mainBundle] loadNibNamed:@"SDSubCell" owner:self options:nil];
        cell = self.subCell;
        self.subCell = nil;
    }
    
    SelectableCellState cellState = [[selectableSubCellsState objectForKey:indexPath] intValue];
    switch (cellState)
    {
        case Checked:       [cell check];       break;
        case Unchecked:     [cell uncheck];     break;
        default:                                break;
    }
    
    cell = [self.parentTable item:self setSubItem:cell forRowAtIndexPath:indexPath];

    return cell;
}



-(CGFloat)tableView:(UIFolderTableView *)tableView xForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    SDSubCell *groupCell=(SDSubCell*)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    
    NSString *string=groupCell.itemText.text;
    
    if ([string isEqualToString:@""]) {
        return 155;
    }
    
    int  count = self.count%3;
    if (count != 0) {
        count = 1;
    }
    
    if ([string isEqualToString:@"上装"]) {
        if (self.opening0) {
            
            return  subCellHeight + (self.count/3 + count)*buttonHeight + 5;
        }
    }
    
    if ([string isEqualToString:@"内衣"]) {
        if (self.opening1) {
            
            return  subCellHeight + (self.count/3 + count)*buttonHeight + 5;
        }
    }
    if ([string isEqualToString:@"包"]) {
        if (self.opening2) {
            
         return  subCellHeight + (self.count/3 + count)*buttonHeight + 5;
        }
    }
    if ([string isEqualToString:@"裙装"]) {
        if (self.opening3) {
            
            return  subCellHeight + (self.count/3 + count)*buttonHeight + 5;
        }    }
    if ([string isEqualToString:@"配饰"]) {
        if (self.opening5) {
            
            return  subCellHeight + (self.count/3 + count)*buttonHeight + 5;
        }
    }
    if ([string isEqualToString:@"鞋"]) {
        if (self.opening6) {
            
            return  subCellHeight + (self.count/3 + count)*buttonHeight + 5;
        }
    }
    if ([string isEqualToString:@"裤装"]) {
        if (self.opening4) {
            
            return  subCellHeight + (self.count/3 + count)*buttonHeight + 5;
        }
    }
   
    return subCellHeight;
   
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SDSubCell *cell = (SDSubCell *)[tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil)
    {
        cell = (SDSubCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    }
    [cell tapTransition];
    
    BOOL cellTapped;
    switch (subCellsCommand)
    {
        // case parent cell is tapped
        case AllSubCellsCommandChecked:
            cellTapped = NO;
            if (cell.selectableCellState == Unchecked)
            {
                [cell check];
                selectedSubCellsAmt++;
            }
            break;
        case AllSubCellsCommandUnchecked:
            cellTapped = NO;
            if (cell.selectableCellState == Checked)
            {
                [cell uncheck];
                selectedSubCellsAmt--;
            }
            break;
        
        // case specific cell is tapped
        default:
            cellTapped = YES;
            if ([cell toggleCheck])
            {
                selectedSubCellsAmt++;
                if (selectedSubCellsAmt == subCellsAmt && self.selectableCellState != Checked)
                {
                    [self check];
                    [self.parentTable mainItemDidChange:self forTap:cellTapped];
                }
            }
            else
            {
                selectedSubCellsAmt--;
                if (selectedSubCellsAmt == 0 && self.selectableCellState != Unchecked)
                {
                    [self uncheck];
                    [self.parentTable mainItemDidChange:self forTap:cellTapped];
                }
            }
            break;
    }
    [self.parentTable groupCell:self didSelectSubCell:cell withIndexPath:indexPath andWithTap:cellTapped];
}
-(void)dealloc{
    [_expandBtn release],_expandBtn=nil;
    [subTable release],subTable=nil;
    [subCell release],subCell=nil;
    [selectableSubCellsState release],selectableSubCellsState=nil;
    [super dealloc];
}
@end
