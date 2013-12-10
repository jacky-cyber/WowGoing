//
//  NoYetPayCell.m
//  MYWowGoing
//
//  Created by zhangM on 13-7-30.
//
//

#import "NoYetPayCell.h"

@implementation NoYetPayCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
                
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [_addressButton release];
    [_addressLabe release];
    [_productNameLable release];
    [_colorAndSizeLable release];
    [_deleteButton release];
    [_magnifierImage release];
    [_lastTimeLable release];
    [_shanChuBut release];
    [super dealloc];
}
@end
