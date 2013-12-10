//
//  SearchRequestBS.m
//  MYWowGoing
//
//  Created by zhangM on 13-4-16.
//
//

#import "SearchRequestBS.h"
#import "ASIHTTPRequest.h"
 
 
#import "JSON.h"

@implementation SearchRequestBS
@synthesize parameterDic=_parameterDic;

-(void)dealloc{
    [_parameterDic release];
    [super dealloc];
}
- (id)onExecute
{
    NSMutableDictionary *common =[NSMutableDictionary dictionary];
    
    if ([Util isLogin]) {
        [common setValue:[Util getLoginName] forKey:@"loginId"];
        [common setValue:[Util getPassword] forKey:@"password"];
    }
    else
    {
        [common setValue:@"123@abc.com" forKey:@"loginId"];
        [common setValue:@"888888" forKey:@"password"];
    }

    NSMutableDictionary *jsonreq = [NSMutableDictionary dictionary];
    [jsonreq setValue:common forKey:@"common"];
    [jsonreq setValue:[self.parameterDic objectForKey:@"pageNumber"] forKey:@"pageNumber"];
    [jsonreq setValue:[Util getDeviceId] forKey:@"deviceId"];
    [jsonreq setValue:[Util getAdViewCity] forKey:@"cityName"];
    [jsonreq setValue:[self.parameterDic objectForKey:@"productType"] forKey:@"productType"];//搜索的产品类型  
    [jsonreq setValue:[self.parameterDic objectForKey:@"colorName"] forKey:@"colorName"];//颜色
    [jsonreq setValue:[self.parameterDic objectForKey:@"styleTypeName"] forKey:@"styleTypeName"];//类别
    [jsonreq setValue:[self.parameterDic objectForKey:@"type"] forKey:@"type"];
    [jsonreq setValue:[self.parameterDic objectForKey:@"searchdiscountKey"] forKey:@"searchdiscountKey"];//折扣
    [jsonreq setValue:[self.parameterDic objectForKey:@"marketID"] forKey:@"marketID"];//商场
    [jsonreq setValue:[self.parameterDic objectForKey:@"brandId"] forKey:@"brandId"];//品牌
    [jsonreq setValue:[self.parameterDic objectForKey:@"searchpriceKey"] forKey:@"searchpriceKey"];//价格
    
    [jsonreq setValue:[self.parameterDic objectForKey:@"orderType"] forKey:@"orderType"];//按价格\折扣排序
    [jsonreq setValue:[self.parameterDic objectForKey:@"gender"] forKey:@"gender"];//性别用户性别（1.男装  2 女装 3. 全部）
    
    if (self.isSearch) {
        [jsonreq setValue:@"1" forKey:@"brandType"];
    }
    
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

    NSString *urlString = [NSString stringWithFormat:@"%@/product/list",SEVERURL];
    ASIFormDataRequest *requestForm = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
    
    requestForm.tag=[[self.parameterDic objectForKey:@"tag"] integerValue];
    [requestForm setPostValue:sbreq forKey:@"jsonReq"];
    [requestForm startSynchronous];
    return [requestForm autorelease];
    
}

@end
