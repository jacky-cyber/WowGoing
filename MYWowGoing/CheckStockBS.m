//
//  CheckStockBS.m
//  MYWowGoing
//
//  Created by ZhangMeng on 13-8-16.
//
//

#import "CheckStockBS.h"

@implementation CheckStockBS
- (void)dealloc{
    [_activityArray release];
    [_orderIDArray release];
    [super dealloc];
}

-(id)onExecute{
    
    NSMutableDictionary *common = [NSMutableDictionary dictionary];
    [common setValue:[NSString stringWithFormat:@"%@",[Util getLoginName]] forKey:@"loginId"];
    [common setValue:[NSString stringWithFormat:@"%@",[Util getPassword]] forKey:@"password"];
    
    NSMutableDictionary *jsonreq = [NSMutableDictionary dictionary];
    [jsonreq setValue:common forKey:@"common"];
    [jsonreq setValue:self.activityArray forKey:@"activityId"];
    [jsonreq setValue:self.orderIDArray forKey:@"orderId"];
    [jsonreq setValue:[NSString stringWithFormat:@"%d",self.type] forKey:@"payType"];
    
    NSString *sbreq=nil;
    NSError *error=nil;
    NSData *data=[NSJSONSerialization dataWithJSONObject:jsonreq options:NSJSONWritingPrettyPrinted error:&error];
    sbreq=[[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
    
    NSString *urlString = nil;
    
    if (self.isNoPay) {
        
        urlString = [NSString stringWithFormat:@"%@/cart/noPayOrder",SEVERURL];
        
    }else{
        urlString = [NSString stringWithFormat:@"%@/%@",SEVERURL,CART_CHECK_ORDER];
    }
    
    ASIFormDataRequest *requestForm = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
    [requestForm setShouldContinueWhenAppEntersBackground:YES];
    [requestForm setTimeOutSeconds:10];
    [requestForm setPostValue:sbreq forKey:@"jsonReq"];
    [requestForm startSynchronous];
    return [requestForm autorelease];
    
}

@end
