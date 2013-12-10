//
//  GZBS.m
//  MYWowGoing
//
//  Created by WangKaifeng on 13-8-31.
//
//

#import "GZBS.h"
#import "Api.h"
@implementation GZBS


- (void)dealloc {
    [_brandString release];
    [super dealloc];
}

- (id)onExecute
{
    
    NSMutableDictionary *common = [NSMutableDictionary dictionary];
    
    if ([Util isLogin]) {
        [common setValue:[Util getLoginName] forKey:@"loginId"];
        [common setValue:[Util getPassword] forKey:@"password"];
    }
    
    NSString *urlString=nil;
    //构建参数字典
    NSMutableDictionary *jsonreq = [NSMutableDictionary dictionary];
    [jsonreq setValue:_brandString forKey:@"brandIdListStr"];
    [jsonreq setValue:common forKey:@"common"];
    [jsonreq setValue:[Util getCustomerID] forKey: @"customerid"];
    
    
    NSString *sbreq=nil;
    //IOS 自带 创建 JSON 数据 使用与IOS5.0以上版本
    NSError *error=nil;
    NSData *data=[NSJSONSerialization dataWithJSONObject:jsonreq options:NSJSONWritingPrettyPrinted error:&error];
    sbreq=[[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];

    
    urlString = [NSString stringWithFormat:@"%@/favorites/add",SEVERURL];
    ASIFormDataRequest *requestDetail = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlString]];
    [requestDetail setPostValue:sbreq forKey:@"jsonReq"];
    [requestDetail startSynchronous];
    return requestDetail;
}

@end
