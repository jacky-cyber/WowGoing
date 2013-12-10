//
//  LoadingPageBS.m
//  MYWowGoing
//
//  Created by WangKaifeng on 13-8-12.
//
//

#import "LoadingPageBS.h"

@implementation LoadingPageBS


- (void)dealloc {
    [_phoneTypeString release];
    [super dealloc];
}

- (id)onExecute
{
    NSMutableDictionary *common = [NSMutableDictionary dictionary];
    [common setValue:USERNAME forKey:@"loginId"];
    [common setValue:PASSWORD forKey:@"password"];
    NSMutableDictionary *jsonreq = [NSMutableDictionary dictionary];
    [jsonreq setValue:common forKey:@"common"];
    [jsonreq setValue:_phoneTypeString forKey:@"phoneType"];
    NSString *sbreq=nil;
    
    NSError *error=nil;
    NSData *data=[NSJSONSerialization dataWithJSONObject:jsonreq options:NSJSONWritingPrettyPrinted error:&error];
    sbreq=[[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
    
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",SEVERURL,LOAD_PAGE];
    ASIFormDataRequest *requestForm = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
    [requestForm setPostValue:sbreq forKey:@"jsonReq"];
    [requestForm startSynchronous];
    return [requestForm autorelease];
}
@end
