//
//  InvitationCodeBS.m
//  MYWowGoing
//
//  Created by WangKaifeng on 13-6-9.
//
//

#import "InvitationCodeBS.h"
 

@implementation InvitationCodeBS
-(void)dealloc {
    [_invitetionCodeString release], _invitetionCodeString = nil;
    [super dealloc];
}

-(id)onExecute{
    NSMutableDictionary *common = [NSMutableDictionary dictionary];
    [common setValue:USERNAME forKey:@"loginId"];
    [common setValue:PASSWORD forKey:@"password"];
    
    NSMutableDictionary *jsonreq = [NSMutableDictionary dictionary];
    [jsonreq setValue:common forKey:@"common"];
    [jsonreq setValue:[Util getDeviceId] forKey:@"deviceId"];
    [jsonreq setValue:_invitetionCodeString forKey:@"invitationCode"]; //邀请码
    
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
    
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",SEVERURL, INVITATION_CODE];
    ASIFormDataRequest *requestForm = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlString]];
    //设置需要POST的数据，这里提交两个数据，A=a&B=b
    [requestForm setPostValue:sbreq forKey:@"jsonReq"];
    [requestForm startSynchronous];
    [requestForm setDelegate:self];
    
    return requestForm;
}

@end
