//
//  ProductCell.m
//  MYWowGoing
//
//  Created by YangJingchao on 13-4-18.
//
//

#import "ProductCell.h"

@implementation ProductCell
@synthesize uidbtn_Left=_uidbtn_Left,uidbtn_Right=_uidbtn_Right;
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

-(void)dealloc{

    [_img_CloseLeft release];
    [_img_CloseRight release];
    [_uidbtn_Left release];
    [_uidbtn_Right release];
    [_img1 release];
    [_img2 release];
    [super dealloc];
}
@end
