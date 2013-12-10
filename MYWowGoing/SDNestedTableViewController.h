//
//  SDNestedTableViewController.h
//  SDNestedTablesExample
//
//  Created by Daniele De Matteis on 21/05/2012.
//  Copyright (c) 2012 Daniele De Matteis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDSelectableCell.h"
#import "SDGroupCell.h"
#import "SDSubCell.h"

@protocol SDNestedTableDelegate<NSObject>

- (void) mainTable:(UITableView *)mainTable itemDidChange:(SDGroupCell *)item;
- (void) item:(SDGroupCell *)item subItemDidChange:(SDSelectableCell *)subItem;

@end

@interface SDNestedTableViewController : UITableViewController<SDNestedTableDelegate>
{
	
}

- (void) mainItemDidChange: (SDGroupCell *)item forTap:(BOOL)tapped;
- (void) mainItem:(SDGroupCell *)item subItemDidChange: (SDSelectableCell *)subItem forTap:(BOOL)tapped;

#pragma mark - To be implemented in subclasses

- (NSInteger) mainTable:(UITableView *)mainTable numberOfItemsInSection:(NSInteger)section;
- (NSInteger) mainTable:(UITableView *)mainTable numberOfSubItemsforItem:(SDGroupCell *)item atIndexPath:(NSIndexPath *)indexPath;

- (SDGroupCell *) mainTable:(UITableView *)mainTable setItem:(SDGroupCell *)item forRowAtIndexPath:(NSIndexPath *)indexPath;
- (SDSubCell *) item:(SDGroupCell *)item setSubItem:(SDSubCell *)subItem forRowAtIndexPath:(NSIndexPath *)indexPath;

- (void) collapsingItem:(SDGroupCell *)item withIndexPath:(NSIndexPath *)indexPath;
- (void) expandingItem:(SDGroupCell *)item withIndexPath:(NSIndexPath *)indexPath;

- (NSString *) nibNameForMainCell;

#pragma mark - Internal

@property (assign,nonatomic) int mainItemsAmt;
@property (retain,nonatomic) NSMutableDictionary *subItemsAmt;
@property (assign,nonatomic) id<SDNestedTableDelegate> delegate;

@property (retain,nonatomic) IBOutlet SDGroupCell *groupCell;

@property(nonatomic,retain) NSMutableDictionary *expandedIndexes;
@property(nonatomic,retain) NSMutableDictionary *selectableCellsState;
@property(nonatomic,retain) NSMutableDictionary *selectableSubCellsState;

- (void) collapsableButtonTapped: (UIControl *)button withEvent: (UIEvent *)event;
- (void) groupCell:(SDGroupCell *)cell didSelectSubCell:(SDSelectableCell *)subCell withIndexPath: (NSIndexPath *)indexPath andWithTap:(BOOL)tapped;

@end
