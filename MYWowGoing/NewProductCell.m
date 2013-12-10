//
//  NewProductCell.m
//  MYWowGoing
//
//  Created by YangJingchao on 13-4-18.
//
//

#import "NewProductCell.h"

@implementation NewProductCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _discountPriceLeft = [[StrikeThroughLabel alloc]init];
        [self addSubview:_discountPriceLeft];
        
        _img_money1 = [[UIImageView alloc]init];
        [self addSubview:_img_money1];
        
        _img_money2 = [[UIImageView alloc]init];
        [self addSubview:_img_money2];

    }
    return self;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)dealloc{
    
    [_productImageLeft release],_productImageLeft=nil;
    [_brandLogoLeft release],_brandLogoLeft=nil;
    [_productPriceLeft release],_productPriceLeft=nil;
    [_discountPriceLeft release],_discountPriceLeft=nil;
    [_discountLeft release],_discountLeft=nil;
    [_btn_Left release],_btn_Left=nil;
    [_productImageRight release],_productImageRight=nil;
    [_brandLogoRight release],_brandLogoRight=nil;
    [_productPriceRight release],_productPriceRight=nil;
    [_discountPriceRight release],_discountPriceRight=nil;
    [_discountRight release],_discountRight=nil;
    [_btn_Right release],_btn_Right=nil;
        
    [super dealloc];
}

@end
