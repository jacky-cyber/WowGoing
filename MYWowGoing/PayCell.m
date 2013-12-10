//
//  NoPayCell.m
//  MYWowGoing
//
//  Created by WangKaifeng on 13-1-10.
//
//

#import "PayCell.h"

@implementation PayCell
@synthesize shareBtn;

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
    [_productLogo release];
    [_productName release];
    [_sizeLabel release];
    [_priceLabel release];
    [_takeLab release];
    [_slipBtn release];
    [shareBtn release];
    [_commentBut release];
    [super dealloc];
}
@end
