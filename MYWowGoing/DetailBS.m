//
//  DetailBS.m
//  MYWowGoing
//
//  Created by WangKaifeng on 13-8-26.
//
//

#import "DetailBS.h"

@implementation DetailBS


- (void)dealloc {
    [_userName release];
    [_password release];
    [super dealloc];
}

- (id)onExecute
{

    NSMutableDictionary *common = [NSMutableDictionary dictionary];
    if ([Util isLogin]) {
        [common setValue:[Util getLoginName] forKey:@"loginId"];
        [common setValue:[Util getPassword] forKey:@"password"];
    }else{
        [common setValue:@"123@abc.com" forKey:@"loginId"];
        [common setValue:@"888888" forKey:@"password"];
    }
    NSMutableDictionary *jsonreq = [NSMutableDictionary dictionary];
    [jsonreq setValue:common forKey:@"common"];
    [jsonreq setValue:[NSString stringWithFormat:@"%d",_productIdNum] forKey:@"productId"];
    [jsonreq setValue:[NSString stringWithFormat:@"%d",_activityIdNum] forKey:@"activityId"];
    [jsonreq setValue:[Util getDeviceId] forKey:@"deviceId"];
    [jsonreq setValue:[Util getBrowerCity] forKey:@"cityNane"];
    
    NSString *sbreq=nil;
    //IOS 自带 创建 JSON 数据 使用与IOS5.0以上版本
    NSError *error=nil;
    NSData *data=[NSJSONSerialization dataWithJSONObject:jsonreq options:NSJSONWritingPrettyPrinted error:&error];
    sbreq=[[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
    
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",SEVERURL,PRODUCT_DETAIL];
   ASIFormDataRequest *requestDetail = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlString]];
    [requestDetail setPostValue:sbreq forKey:@"jsonReq"];
    [requestDetail startSynchronous];
    return requestDetail;
}

@end
