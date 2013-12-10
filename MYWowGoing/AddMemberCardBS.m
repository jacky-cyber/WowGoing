//
//  AddMemberCardBS.m
//  MYWowGoing
//
//  Created by WangKaifeng on 13-8-15.
//
//

#import "AddMemberCardBS.h"

@implementation AddMemberCardBS
- (void)dealloc {
    [_username release];
    [_password release];
    [_memberInfoIdString release];
    [_membershipNumberString release];
    [_customeridString release];
    [super dealloc];
}

- (id)onExecute
{
    if (!_username || !_password)
    {
        return nil;
    }
    
    NSMutableDictionary *common = [NSMutableDictionary dictionary];
    [common setValue:_username forKey:@"loginId"];
    [common setValue:_password forKey:@"password"];
    NSMutableDictionary *jsonreq = [NSMutableDictionary dictionary];
    [jsonreq setValue:common forKey:@"common"];
    [jsonreq setValue:[NSString stringWithFormat:@"%@",_customeridString] forKey:@"customerid"];
    [jsonreq setValue:[NSString stringWithFormat:@"%@",_membershipNumberString] forKey:@"membershipNumber"];
    [jsonreq setValue:[NSString stringWithFormat:@"%@",_memberInfoIdString] forKey:@"memberInfoId"];
    
    
    NSString *sbreq=nil;
    //IOS 自带 创建 JSON 数据 使用与IOS5.0以上版本
    NSError *error=nil;
    NSData *data=[NSJSONSerialization dataWithJSONObject:jsonreq options:NSJSONWritingPrettyPrinted error:&error];
    sbreq=[[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
    
    
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",SEVERURL,MEMBERSHIPCARD_ADDMEMBER];
    ASIFormDataRequest *requestForm = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
    [requestForm setPostValue:sbreq forKey:@"jsonReq"];
    [requestForm startSynchronous];
    return [requestForm autorelease];
}
@end
