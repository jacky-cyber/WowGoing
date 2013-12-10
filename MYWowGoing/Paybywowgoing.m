//
//  Paybywowgoing.m
//  MYWowGoing
//
//  Created by zhangM on 13-3-27.
//
//

#import "Paybywowgoing.h"

@implementation Paybywowgoing
@synthesize productsArray=_productsArray,orderId=_orderId,orderIdString=_orderIdString;
-(id)onExecute{  //使用wowgoing账户支付并修改订单状态
    NSMutableDictionary *common = [NSMutableDictionary dictionary];
    [common setValue:[Util getLoginName] forKey:@"loginId"];
    [common setValue:[Util getPassword] forKey:@"password"];
    
    NSMutableDictionary *jsonreq = [NSMutableDictionary dictionary] ;
    [jsonreq setValue:common forKey:@"common"];
    [jsonreq setValue:[Util getDeviceId] forKey:@"deviceId"];
    [jsonreq setValue:[Util getCustomerID] forKey:@"customerId"];

    
    if (self.productsArray.count!=0) {
        [jsonreq setValue:self.orderIdString forKey:@"orderId"];
    }else{
        [jsonreq setValue:self.orderId forKey:@"orderId"];
    }
    
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

    NSString *urlString = [NSString stringWithFormat:@"%@/%@",SEVERURL,CART_UPDATE_ORDER];
    ASIFormDataRequest *requestForm = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
    [requestForm setPostValue:sbreq forKey:@"jsonReq"];
    [requestForm startSynchronous];

    return  [requestForm autorelease];
  }

-(void)dealloc{
    [_productsArray release],_productsArray=nil;
    [_orderId release],_orderId=nil;
    [_orderIdString release],_orderIdString=nil;

    [super dealloc];
}
@end
