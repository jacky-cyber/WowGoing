//
//  CouponBS.m
//  MYWowGoing
//
//  Created by WangKaifeng on 13-4-24.
//
//

#import "CouponBS.h"
#import "ASIHTTPRequest.h"
 
 
#import "JSON.h"
#import "Api.h"

@implementation CouponBS

- (void)dealloc {
    [_orderTypeString release];
    [super dealloc];
}

- (id)onExecute
{
    
    NSMutableDictionary *common = [NSMutableDictionary dictionary];
    [common setValue:[Util getLoginName] forKey:@"loginId"];
    [common setValue:[Util getPassword] forKey:@"password"];
    NSMutableDictionary *jsonreq =[NSMutableDictionary dictionary];
    [jsonreq setValue:common forKey:@"common"];
    [jsonreq setValue:[Util getDeviceId] forKey:@"deviceId"];
    [jsonreq setValue:[Util getCustomerID] forKey:@"customerId"];
    [jsonreq setValue:self.orderTypeString forKey:@"orderType"];
    [jsonreq setValue:[NSNumber numberWithInt:self.pageNumber] forKey:@"pageNumber"];
    
    NSString *sbreq=nil;
    if ([[UIDevice currentDevice].systemVersion floatValue]>=5.0) {//IOS 自带 创建 JSON 数据 使用与IOS5.0以上版本
        NSError *error=nil;
        NSData *data=[NSJSONSerialization dataWithJSONObject:jsonreq options:NSJSONWritingPrettyPrinted error:&error];
        sbreq=[[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
    }else{
        SBJsonWriter *sbJsonWriter=[SBJsonWriter alloc];
        sbreq = [sbJsonWriter stringWithObject:jsonreq];
        [sbJsonWriter release];
    }

    NSString *urlString = [NSString stringWithFormat:@"%@/%@",SEVERURL,COUPON_LIST];
    ASIFormDataRequest *requestForm = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
    requestForm.tag = (self.pageNumber == 1) ? REQUEST_PAGE_ONE : REQUEST_PAGE_NEXT;
    [requestForm setPostValue:sbreq forKey:@"jsonReq"];
    [requestForm setShouldContinueWhenAppEntersBackground:YES];
    [requestForm startSynchronous];
    return [requestForm autorelease];
}

@end
