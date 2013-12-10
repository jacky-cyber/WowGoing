//
//  ProductBrandDetailBS.m
//  MYWowGoing
//
//  Created by WangKaifeng on 13-8-26.
//
//

#import "ProductBrandDetailBS.h"

@implementation ProductBrandDetailBS

- (void)dealloc {
    [_brandId release];
    [super dealloc];
}

- (id)onExecute
{
    NSMutableDictionary *common = [NSMutableDictionary dictionary];
    if ([Util isLogin]) {
        [common setValue:[Util getLoginName] forKey:@"loginId"];
        [common setValue:[Util getPassword] forKey:@"password"];
    }else
    {
        [common setValue:@"123@abc.com" forKey:@"loginId"];
        [common setValue:@"888888" forKey:@"password"];
    }
    NSMutableDictionary *jsonreq = [NSMutableDictionary dictionary];
    [jsonreq setValue:common forKey:@"common"];
    [jsonreq setValue:[Util getDeviceId] forKey:@"deviceId"];
    [jsonreq setValue:[Util getBrowerCity]  forKey:@"cityName"];
    [jsonreq setValue:_brandId  forKey:@"brandId"];
    
    NSString *sbreq=nil;
    NSError *error=nil;
    NSData *data=[NSJSONSerialization dataWithJSONObject:jsonreq options:NSJSONWritingPrettyPrinted error:&error];
    sbreq=[[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
    
    NSString *urlString = [NSString stringWithFormat:@"%@/brand/detail",SEVERURL];
    ASIFormDataRequest *requestForm = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlString]];
    //设置需要POST的数据，这里提交两个数据，A=a&B=b
    [requestForm setPostValue:sbreq forKey:@"jsonReq"];
    [requestForm startSynchronous];
    return requestForm;

}

@end
