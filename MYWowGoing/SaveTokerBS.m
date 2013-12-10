//
//  SaveTokerBS.m
//  MYWowGoing
//
//  Created by WangKaifeng on 13-4-2.
//
//

#import "SaveTokerBS.h"
#import "ASIHTTPRequest.h"
 
 
#import "JSON.h"


@implementation SaveTokerBS

- (void)dealloc {
    [_deviceTokenLocal release];
    [super dealloc];
}

- (id)onExecute
{
    NSMutableDictionary *common = [NSMutableDictionary dictionary];
    [common setValue:@"123@abc.com" forKey:@"loginId"];
    [common setValue:@"111111" forKey:@"password"];
    NSMutableDictionary *jsonreq = [NSMutableDictionary dictionary];
    [jsonreq setValue:common forKey:@"common"];
    [jsonreq setValue:_deviceTokenLocal forKey:@"deviceNum"];
    
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
    
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",SEVERURL, PUSH_SERVER];
    NSLog(@"向服务器发送的apns的参数%@\n%@",urlString, sbreq);
    ASIFormDataRequest *requestForm = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
    //设置需要POST的数据，这里提交两个数据，A=a&B=b
    [requestForm setPostValue:sbreq forKey:@"jsonReq"];
    [requestForm startSynchronous];
    return [requestForm autorelease];
}


@end
