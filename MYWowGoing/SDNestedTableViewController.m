//
//  SDNestedTableViewController.m
//  SDNestedTablesExample
//
//  Created by Daniele De Matteis on 21/05/2012.
//  Copyright (c) 2012 Daniele De Matteis. All rights reserved.
//

#import "SDNestedTableViewController.h"
#import "Api.h"
#import "Single.h"
@interface SDNestedTableViewController ()

@end

@implementation SDNestedTableViewController

@synthesize mainItemsAmt, subItemsAmt=_subItemsAmt, groupCell=_groupCell;
@synthesize delegate;
@synthesize expandedIndexes=_expandedIndexes,selectableCellsState=_selectableCellsState,selectableSubCellsState=_selectableSubCellsState;

- (id) init
{
    if (self = [self initWithNibName:@"SDNestedTableView" bundle:nil])
    {
    }
    return self;
}

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]))
    {
        self.delegate = self;
    }
    
    return self;
}

#pragma mark - To be implemented in sublclasses

- (NSInteger)mainTable:(UITableView *)mainTable numberOfItemsInSection:(NSInteger)section
{
    
    return 0;
}

- (NSInteger)mainTable:(UITableView *)mainTable numberOfSubItemsforItem:(SDGroupCell *)item atIndexPath:(NSIndexPath *)indexPath
{
    
    return 0; 
}

- (SDGroupCell *)mainTable:(UITableView *)mainTable setItem:(SDGroupCell *)item forRowAtIndexPath:(NSIndexPath *)indexPath 
{
    if (indexPath.row == 0)
    {
        
    }
    return item;
}

- (SDSubCell *)item:(SDGroupCell *)item setSubItem:(SDSubCell *)subItem forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
       
    }
    return subItem;
}

- (void)expandingItem:(SDGroupCell *)item withIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)collapsingItem:(SDGroupCell *)item withIndexPath:(NSIndexPath *)indexPath 
{

}
    
// Optional method to implement. Will be called when creating a new main cell to return the nib name you want to use

- (NSString *) nibNameForMainCell
{
    return @"SDGroupCell";
}

#pragma mark - Delegate methods

- (void) mainTable:(UITableView *)mainTable itemDidChange:(SDGroupCell *)item
{
    }

- (void) item:(SDGroupCell *)item subItemDidChange:(SDSelectableCell *)subItem
{
   
}

- (void) mainItemDidChange: (SDGroupCell *)item forTap:(BOOL)tapped
{
    if(delegate != nil && [delegate respondsToSelector:@selector(mainTable:itemDidChange:)] )
    {
        [delegate performSelector:@selector(mainTable:itemDidChange:) withObject:self.tableView withObject:item];
    }
}

- (void) mainItem:(SDGroupCell *)item subItemDidChange: (SDSelectableCell *)subItem forTap:(BOOL)tapped
{
    if(delegate != nil && [delegate respondsToSelector:@selector(item:subItemDidChange:)] )
    {
        [delegate performSelector:@selector(item:subItemDidChange:) withObject:item withObject:subItem];
    }
}

#pragma mark - Class lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.subItemsAmt = [[[NSMutableDictionary alloc] initWithDictionary:nil] autorelease];
	self.expandedIndexes = [[[NSMutableDictionary alloc] init] autorelease];
	self.selectableCellsState = [[[NSMutableDictionary alloc] init] autorelease];
	self.selectableSubCellsState = [[[NSMutableDictionary alloc] init] autorelease];
    
    
    self.tableView.frame=CGRectMake(0, 0, 320,IPHONE_HEIGHT);
    self.tableView.backgroundColor = [UIColor colorWithRed:62.0/255.0 green:62.0/255.0 blue:62.0/255.0 alpha:1.0];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - TableView delegation

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    mainItemsAmt = [self mainTable:tableView numberOfItemsInSection:section];
    
    return mainItemsAmt;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SDGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GroupCell"];
    
    if (cell == nil)
    {
        [[NSBundle mainBundle] loadNibNamed:@"SDGroupCell" owner:self options:nil];
        cell =self.groupCell;
        self.groupCell = nil;
    }
    
    [cell setParentTable: self];
    
    cell = [self mainTable:tableView setItem:cell forRowAtIndexPath:indexPath];
    
    NSNumber *amt = [NSNumber numberWithInt:[self mainTable:tableView numberOfSubItemsforItem:cell atIndexPath:indexPath]];
    [self.subItemsAmt setObject:amt forKey:indexPath];
    
    [cell setSubCellsAmt: [[self.subItemsAmt objectForKey:indexPath] intValue]];
    
    NSMutableDictionary *subCellsState = [self.selectableSubCellsState objectForKey:indexPath];
    int selectedSubCellsAmt = 0;
    for (NSString *key in subCellsState)
    {
        SelectableCellState cellState = [[subCellsState objectForKey:key] intValue];
        if (cellState == Checked) {
            selectedSubCellsAmt++;
        }
    }
    [cell setSelectedSubCellsAmt: selectedSubCellsAmt];
    [cell setSelectableSubCellsState: [self.selectableSubCellsState objectForKey:indexPath]];
    
    SelectableCellState cellState = [[self.selectableCellsState objectForKey:indexPath] intValue];
    switch (cellState)
    {
        case Checked:       [cell check];       break;
        case Unchecked:     [cell uncheck];     break;
        default:                                break;
    }
    
    BOOL isExpanded = [[self.expandedIndexes objectForKey:indexPath] boolValue];
    cell.isExpanded = isExpanded;
    if(cell.isExpanded)
    {
        [cell rotateExpandBtnToExpanded];
    }
    else
    {
        [cell rotateExpandBtnToCollapsed];
    }
    
    [cell.subTable reloadData];
    
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    int amt = [[self.subItemsAmt objectForKey:indexPath] intValue];
    BOOL isExpanded = [[self.expandedIndexes objectForKey:indexPath] boolValue];
    if(isExpanded)
    {
        if (indexPath.row== mainItemsAmt - 1) {
            return [SDGroupCell getHeight]+155;
        }
        else if (indexPath.row == 1){
            if (![Single shareSingle].isLeiBie) {
                
                return  600;
            }else{
            
                return [SDGroupCell getHeight] + [SDGroupCell getsubCellHeight]*amt + 1;
            }
        }
        else{
            return [SDGroupCell getHeight] + [SDGroupCell getsubCellHeight]*amt + 1;
        }
    }
    return [SDGroupCell getHeight];
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    SDGroupCell *cell = (SDGroupCell *)[tableView cellForRowAtIndexPath:indexPath];
    [cell tapTransition];
    SelectableCellState cellState = [cell toggleCheck];
    NSNumber *cellStateNumber = [NSNumber numberWithInt:cellState];
    [self.selectableCellsState setObject:cellStateNumber forKey:indexPath];
    
    [cell subCellsToggleCheck];
    
    [self mainItemDidChange:cell forTap:YES];
}



#pragma mark - Nested Tables events

- (void) groupCell:(SDGroupCell *)cell didSelectSubCell:(SDSelectableCell *)subCell withIndexPath:(NSIndexPath *)indexPath andWithTap:(BOOL)tapped
{
    NSIndexPath *groupCellIndexPath = [self.tableView indexPathForCell:cell];
    NSNumber *cellStateNumber = [NSNumber numberWithInt:cell.selectableCellState];
    [self.selectableCellsState setObject:cellStateNumber forKey:groupCellIndexPath];
    
    NSNumber *subCellStateNumber = [NSNumber numberWithInt:subCell.selectableCellState];
    
    if (![self.selectableSubCellsState objectForKey:groupCellIndexPath])
    {
        NSMutableDictionary *subCellState = [[[NSMutableDictionary alloc] initWithObjectsAndKeys: subCellStateNumber, indexPath, nil] autorelease];
        [self.selectableSubCellsState setObject:subCellState forKey:groupCellIndexPath];
    }
    else
    {
        
        NSArray *subCellState=[cell.selectableSubCellsState allKeys];
        for (int i=0; i<subCellState.count; i++) {
            NSIndexPath  *subIndex=[subCellState objectAtIndex:i];
             [[self.selectableSubCellsState objectForKey:groupCellIndexPath] setObject:[NSNumber numberWithInt:0] forKey:subIndex];
        }

        [[self.selectableSubCellsState objectForKey:groupCellIndexPath] setObject:subCellStateNumber forKey:indexPath];
    }
    
    [cell setSelectableSubCellsState: [self.selectableSubCellsState objectForKey:groupCellIndexPath]];

    [self mainItem:cell subItemDidChange:subCell forTap:tapped];
}

- (void) collapsableButtonTapped: (UIControl *) button withEvent: (UIEvent *) event
{
    UITableView *tableView = self.tableView;
    NSIndexPath * indexPath = [tableView indexPathForRowAtPoint: [[[event touchesForView: button] anyObject] locationInView: tableView]];
    if ( indexPath == nil )
        return;
    
    if ([[self.expandedIndexes objectForKey:indexPath] boolValue]) {
        [self collapsingItem:(SDGroupCell *)[tableView cellForRowAtIndexPath:indexPath] withIndexPath:indexPath];
    } else {
        [self expandingItem:(SDGroupCell *)[tableView cellForRowAtIndexPath:indexPath] withIndexPath:indexPath];
    }

	BOOL isExpanded = ![[self.expandedIndexes objectForKey:indexPath] boolValue];
	NSNumber *expandedIndex = [NSNumber numberWithBool:isExpanded];
	[self.expandedIndexes setObject:expandedIndex forKey:indexPath];

    [self.tableView reloadData];
    
}
-(void)dealloc{
    [_subItemsAmt release],_subItemsAmt=nil;
    [_groupCell release],_groupCell=nil;
    [_selectableSubCellsState release],_selectableSubCellsState=nil;
    [_selectableCellsState release],_selectableCellsState=nil;
    [_expandedIndexes release],_expandedIndexes=nil;
    [super dealloc];
}
@end
