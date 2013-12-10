//
//  HotCategoryCell.m
//  MYWowGoing
//
//  Created by ZhangMeng on 13-8-3.
//
//

#import "HotCategoryCell.h"

@implementation HotCategoryCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [_itemLable release];
    [_subItemLable release];
    [super dealloc];
}
@end
