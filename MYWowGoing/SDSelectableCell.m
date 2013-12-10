//
//  SDSelectableCell.m
//  SDNestedTablesExample
//
//  Created by Daniele De Matteis on 23/05/2012.
//  Copyright (c) 2012 Daniele De Matteis. All rights reserved.
//

#import "SDSelectableCell.h"

@implementation SDSelectableCell

@synthesize itemText=_itemText, parentTable, selectableCellState;

- (id) initWithCoder:(NSCoder *)aDecoder
{
    if((self = [super initWithCoder:aDecoder]))
    {
        selectableCellState = Unchecked;
    }
    return self;
}
- (void) layoutSubviews
{
    [super layoutSubviews];
    [self setupInterface];
}

- (void) setupInterface
{
    [self setClipsToBounds: YES];
        
    CGRect frame = self.itemText.frame;
    frame.size.width = checkBox.frame.origin.x - frame.origin.x - (int)(self.frame.size.width/30);
    self.itemText.frame = frame;
}

- (SelectableCellState) toggleCheck
{
    if (selectableCellState == Checked)
    {
        selectableCellState = Unchecked;
        [self styleDisabled];
    }
    else
    {
        selectableCellState = Checked;
        [self styleEnabled];
    }
    return selectableCellState;
}

- (void) check
{
    selectableCellState = Checked;
    [self styleEnabled];
}

- (void) uncheck
{
    selectableCellState = Unchecked;
    [self styleDisabled];
}

- (void) styleEnabled
{

    self.offCheckBox.hidden=NO;
}

- (void) styleDisabled
{

    self.offCheckBox.hidden=YES;
}

- (void) styleHalfEnabled
{
    self.offCheckBox.hidden=YES;
}

- (void) tapTransition
{

}
-(void)dealloc{
    [_onCheckBox release];
    [_offCheckBox release];
    [_itemText release];
    [_selectedItemName release];
    
    [_fengexian release];
    [_flagImage release];
    [super dealloc];
}
@end
