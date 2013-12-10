//
//  ShopListCell.m
//  MYWowGoing
//
//  Created by mayizhao on 13-1-19.
//
//

#import "ShopListCell.h"

@implementation ShopListCell
@synthesize shopListBgView;
@synthesize shopnameLabel;

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
    [shopListBgView release];
    [shopnameLabel release];
    [super dealloc];
}
@end
