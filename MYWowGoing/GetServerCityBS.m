//
//  GetServerCityBS.m
//  MYWowGoing
//
//  Created by WangKaifeng on 13-4-9.
//
//

#import "GetServerCityBS.h"
#import "ASIHTTPRequest.h"
 
 
#import "JSON.h"

@implementation GetServerCityBS

- (void)dealloc {
    [super dealloc];
}

- (id)onExecute
{
    NSMutableDictionary *common = [[[NSMutableDictionary alloc] init] autorelease];
    
    [common setValue:@"123@abc.com" forKey:@"loginId"];
    [common setValue:@"111111" forKey:@"password"];
    NSMutableDictionary *jsonreq = [[[NSMutableDictionary alloc] init] autorelease];
    [jsonreq setValue:common forKey:@"common"];
    [jsonreq setValue:[Util getDeviceId] forKey:@"deviceId"];
    //1.1.1只有修改的。之前用cityName  1.2改成cityName
    [jsonreq setValue:[Util getCityName] forKey:@"cityName"];
    NSLog(@"getCityName=== %@",[Util getCityName]);
    
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

    NSString *urlString = [NSString stringWithFormat:@"%@/login/getrelatedCity",SEVERURL];
    ASIFormDataRequest *requestForm = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
    [requestForm setPostValue:sbreq forKey:@"jsonReq"];
    [requestForm startSynchronous];
    return [requestForm autorelease];

}

@end
