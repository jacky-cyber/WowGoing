//
//  ADVBS.m
//  MYWowGoing
//
//  Created by WangKaifeng on 13-4-18.
//
//

#import "ADVBS.h"
#import "ASIHTTPRequest.h"
 
 
#import "JSON.h"

@implementation ADVBS

- (void)dealloc {
    [super dealloc];
}

- (id)onExecute
{
    NSMutableDictionary *common = [NSMutableDictionary dictionary];
    [common setValue:[NSString stringWithFormat:@"%@",USERNAME] forKey:@"loginId"];
    [common setValue:[NSString stringWithFormat:@"%@",PASSWORD] forKey:@"password"];
    NSMutableDictionary *jsonreq = [NSMutableDictionary dictionary];
    [jsonreq setValue:common forKey:@"common"];
    [jsonreq setValue:[Util getDeviceId] forKey:@"deviceId"];
    [jsonreq setValue:[Util getAdViewCity] forKey:@"cityName"];
    [jsonreq setValue:@"1" forKey:@"pageNumber"];
    
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
    
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",SEVERURL,ADVERTISEMENT_LIST];
    ASIFormDataRequest *requestForm = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
    [requestForm setPostValue:sbreq forKey:@"jsonReq"];
    [requestForm setShouldContinueWhenAppEntersBackground:YES];
    [requestForm setTimeOutSeconds:10];
    [requestForm startSynchronous];
    
    return [requestForm autorelease];
}

@end
