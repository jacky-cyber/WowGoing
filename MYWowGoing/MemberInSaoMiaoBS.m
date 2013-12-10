//
//  MemberInSaoMiaoBS.m
//  MYWowGoing
//
//  Created by ZhangMeng on 13-8-22.
//
//

#import "MemberInSaoMiaoBS.h"

@implementation MemberInSaoMiaoBS
- (void) dealloc{
    [_huiYuanKaID release];
    [_tuiJianRenID release];
    [_quDaoID release];
    [super dealloc];
}

-(id)onExecute{
    
    NSMutableDictionary *common = [NSMutableDictionary dictionary];
    [common setValue:[NSString stringWithFormat:@"%@",[Util getLoginName]] forKey:@"loginId"];
    [common setValue:[NSString stringWithFormat:@"%@",[Util getPassword]] forKey:@"password"];
    
    NSMutableDictionary *jsonreq = [NSMutableDictionary dictionary];
    [jsonreq setValue:common forKey:@"common"];
    [jsonreq setValue:self.quDaoID forKey:@"channelid"];
    [jsonreq setValue:self.huiYuanKaID forKey:@"memberInfoId"];
    [jsonreq setValue:self.tuiJianRenID forKey:@"userid"];
    [jsonreq setValue:[Util getCustomerID] forKey:@"customerid"];
    [jsonreq setValue:[Util getDeviceId] forKey:@"deviceId"];
    [jsonreq setValue:[Util getDeviceId] forKey:@"devicecode"];
    
    NSString *sbreq=nil;
    NSError *error=nil;
    NSData *data=[NSJSONSerialization dataWithJSONObject:jsonreq options:NSJSONWritingPrettyPrinted error:&error];
    sbreq=[[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
    
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",SEVERURL,MEMBERSHIPCARD_ADDMEMBER];
    ASIFormDataRequest *requestForm = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
    [requestForm setShouldContinueWhenAppEntersBackground:YES];
    [requestForm setTimeOutSeconds:10];
    [requestForm setPostValue:sbreq forKey:@"jsonReq"];
    [requestForm startSynchronous];
    return [requestForm autorelease];
    
}

@end
