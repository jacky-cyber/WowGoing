//
//  Prodect.m
//  MYWowGoing
//
//  Created by WangKaifeng on 13-1-15.
//
//

#import "Prodect.h"

@implementation Prodect

- (id)init
{
    self = [super init];
    if (self) {
        self.productName=@"";
        self.price = @"";
        self.productDescription = @"";
        self.orderId = @"";
        self.brandName=@"";
    }
    return self;
}

- (void)dealloc
{
    [_price release];
    [_productName release];
    [_orderId release];
    [_productDescription release];
    [_brandName release];
    [super dealloc];
}

@end
