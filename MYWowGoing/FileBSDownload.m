//
//  FileBSDownload
//  HuaShang
//
//  Created by Alur on 12-3-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "FileBSDownload.h"
#import "SDImageCache.h"
#import "ASIHTTPRequest.h"

@implementation FileBSDownload

@synthesize url = _url;

- (id)onExecute
{
    if (!_url)
    {
        return nil;
    }
    
    // request
	//post方式提交数据
	ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:_url]];
    
    // 设置缓存路径
    NSString *destinationPath = [[SDImageCache sharedImageCache] cachePathForKey:_url];
//    NSLog(@"destinationPath:%@", destinationPath);
    // 如果本地存在此图片 则不下载 直接返回路径
    UIImage *image = [UIImage imageWithContentsOfFile:destinationPath];
    if(image)
    {
        return destinationPath;
    }
    // 否则开始下载图片
    // 设置下载的缓存路径
    request.temporaryFileDownloadPath = [NSString stringWithFormat:@"%@_tmp", destinationPath];
    // 下载完成的路径
    request.downloadDestinationPath = destinationPath;
    request.allowResumeForFileDownloads = YES;
    
    if (self.progress)
    {
        [request setDownloadProgressDelegate:self.progress];
    }
    
	[request startSynchronous];
    return destinationPath;
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
}

@end
