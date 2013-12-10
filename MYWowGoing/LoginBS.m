//
//  LoginBS.m
//  MYWowGoing
//
//  Created by WangKaifeng on 13-3-7.
//
//

#import "LoginBS.h"
#import "SDImageCache.h"
#import "ASIHTTPRequest.h"
 
 
#import "JSON.h"

@implementation LoginBS
@synthesize userName,password;

- (void)dealloc {
    [userName release];
    [password release];
    [super dealloc];
}

- (id)onExecute
{
    if (!userName || !password)
    {
        return nil;
    }
    
    NSMutableDictionary *common = [NSMutableDictionary dictionary];
    [common setValue:userName forKey:@"loginId"];
    [common setValue:password forKey:@"password"];
    NSMutableDictionary *jsonreq = [NSMutableDictionary dictionary];
    [jsonreq setValue:common forKey:@"common"];
    [jsonreq setValue:[Util getDeviceId] forKey:@"deviceId"];
    [jsonreq setValue:[Util getCityName] forKey:@"city"];
    [jsonreq setValue:[Util getDeviceToken] forKey:@"deviceNum"];
    [jsonreq setValue:@"" forKey:@"province"];
    [jsonreq setValue:@"2" forKey:@"mobileType"]; //1 android 2iphone
    
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


    NSString *urlString = [NSString stringWithFormat:@"%@/%@",SEVERURL,ACCOUNT_LOGIN];
    ASIFormDataRequest *requestForm = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
    [requestForm setPostValue:sbreq forKey:@"jsonReq"];
    [requestForm startSynchronous];
    return [requestForm autorelease];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
}

- (void)requestFinished:(ASIHTTPRequest *)request
{

}

@end
