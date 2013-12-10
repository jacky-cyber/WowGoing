//
//  InvalidPayCell.m
//  MYWowGoing
//
//  Created by WangKaifeng on 13-1-21.
//
//

#import "InvalidPayCell.h"

@implementation InvalidPayCell

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

- (void)dealloc
{
    [_productLogo release];
    [_orderNumLab release];
    [_productNameLab release];
    [_roleLab release];
    [_countPrice release];
    [_payTypeLab release];
    [_buyDate release];
    [_refundTypeLab release];
    [_refundTypeBtn release];
    [super dealloc];
}

@end
