//
//  BuyItNowBS.m
//  MYWowGoing
//
//  Created by ZhangMeng on 13-8-19.
//
//

#import "BuyItNowBS.h"

@implementation BuyItNowBS
- (void)dealloc{
    [_productDic release];
    [super dealloc];
}

-(id)onExecute{
    
    NSMutableDictionary *common = [NSMutableDictionary dictionary];
    [common setValue:[NSString stringWithFormat:@"%@",[Util getLoginName]] forKey:@"loginId"];
    [common setValue:[NSString stringWithFormat:@"%@",[Util getPassword]] forKey:@"password"];
    
    NSMutableDictionary *jsonreq = [NSMutableDictionary dictionary];
    [jsonreq setValue:common forKey:@"common"];
    [jsonreq setValue:[self.productDic objectForKey:@"activityId"] forKey:@"activityId"];
    [jsonreq setValue:[self.productDic objectForKey:@"skuId"] forKey:@"skuId"];
    [jsonreq setValue:[self.productDic objectForKey:@"shopId"] forKey:@"shopId"];
    [jsonreq setValue:@"0" forKey:@"operateType"];
    [jsonreq setValue:[Util getDeviceId] forKey:@"deviceId"];
    
    NSString *sbreq=nil;
    NSError *error=nil;
    NSData *data=[NSJSONSerialization dataWithJSONObject:jsonreq options:NSJSONWritingPrettyPrinted error:&error];
    sbreq=[[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
    
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",SEVERURL,PRODUCT_BUYNOW];
    ASIFormDataRequest *requestForm = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
    [requestForm setShouldContinueWhenAppEntersBackground:YES];
    [requestForm setTimeOutSeconds:10];
    [requestForm setPostValue:sbreq forKey:@"jsonReq"];
    [requestForm startSynchronous];
    return [requestForm autorelease];
    
}

@end
