//
//  Request.m
//  MYWowGoing
//
//  Created by zhangM on 13-3-27.
//
//

#import "Request.h"

@implementation Request
@synthesize requestUrl=_requestUrl,requestTag,pageNumber,requestTpye=_requestTpye,orderType=_orderType;
-(id)onExecute{
    
    NSMutableDictionary *common = [NSMutableDictionary dictionary];
    
    [common setValue:[Util getLoginName] forKey:@"loginId"];
    [common setValue:[Util getPassword] forKey:@"password"];
    
    NSMutableDictionary *jsonreq = [NSMutableDictionary dictionary];
    [jsonreq setValue:common forKey:@"common"];
    [jsonreq setValue:[Util getDeviceId] forKey:@"deviceId"];
    
    NSString *urlString=nil;
    switch (self.requestTpye) {
        case 1:
        {
            urlString = [NSString stringWithFormat:@"%@/%@",SEVERURL,CART_LIST];
            [jsonreq setValue:[NSNumber numberWithInt:self.pageNumber] forKey:@"pageNumber"];

        }
            break;
        case 2:
        {
             urlString = [NSString stringWithFormat:@"%@/%@",SEVERURL,CART_DETAIL];
            [jsonreq setValue:self.orderID forKey:@"orderId"];
        }
            break;
        case 3:
        {
            urlString = [NSString stringWithFormat:@"%@/%@",SEVERURL,QH_LIST];
            [jsonreq setValue:[NSNumber numberWithInt:self.pageNumber] forKey:@"pageNumber"];
            [jsonreq setValue:self.orderType forKey:@"orderType"];
        }
            break;
        case 4:
        {
            urlString =  [NSString stringWithFormat:@"%@/shoppePickup/cancel",SEVERURL];
            [jsonreq setValue:self.orderID forKey:@"orderId"];
            [jsonreq setValue:self.orderType forKey:@"orderType"];
        }
            break;
            
        case 5:
        {
             urlString = [NSString stringWithFormat:@"%@/shoppePickup/cancelnotPay",SEVERURL];
            [jsonreq setValue:self.orderID forKey:@"orderId"];
        }
            break;
        default:
            break;
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

    
    ASIFormDataRequest *requestForm =[[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
    
    requestForm.tag =self.requestTag;
    //设置需要POST的数据，这里提交两个数据，A=a&B=b
    [requestForm setPostValue:sbreq forKey:@"jsonReq"];
    
    [requestForm startSynchronous];
    
    return  [requestForm autorelease];
}
-(void)dealloc{
    [_orderID release],_orderID=nil;
    [_orderType release],_orderType=nil;
    [_requestUrl release],_requestUrl=nil;
    [super dealloc];
}

@end
