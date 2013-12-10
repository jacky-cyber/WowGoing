//
//  MemberList.m
//  MYWowGoing
//
//  Created by WangKaifeng on 13-8-16.
//
//

#import "MemberList.h"
#import "Api.h"
@implementation MemberList
- (void)dealloc {
    [_username release];
    [_password release];
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
    [jsonreq setValue:[Util getCityName] forKey:@"cityName"];
    [jsonreq setValue:[Util getCustomerID] forKey:@"customerid"];

    NSString *sbreq=nil;
    NSError *error=nil;
    NSData *data=[NSJSONSerialization dataWithJSONObject:jsonreq options:NSJSONWritingPrettyPrinted error:&error];
    sbreq=[[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
    
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",SEVERURL,MEMBERSHIPCARD_CUSTOM];
    ASIFormDataRequest *requestForm = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
    [requestForm setPostValue:sbreq forKey:@"jsonReq"];
    [requestForm startSynchronous];
    return [requestForm autorelease];
}
@end
