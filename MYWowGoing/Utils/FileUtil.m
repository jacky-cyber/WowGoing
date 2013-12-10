//
//  FileUtil.m
//  HuaShang
//
//  Created by Alur on 11-8-30.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "FileUtil.h"
#import <AVFoundation/AVFoundation.h>

@implementation FileUtil


+ (NSString *)dataFilePath:(NSString *)name
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	return [documentsDirectory stringByAppendingPathComponent:name];
}

+ (BOOL) writeToFile:(NSString *)path withData:(NSData *)data {
	NSFileManager *fileManager = [NSFileManager defaultManager];
	
	// Create parent directory path
	NSArray *paths = [path pathComponents];
	
	NSMutableArray * mulPaths = [[NSMutableArray alloc] initWithArray:paths];
	[mulPaths removeLastObject];
	NSString *parentPath = [NSString pathWithComponents:mulPaths];
	[mulPaths release];
	
	[fileManager createDirectoryAtPath:parentPath withIntermediateDirectories:YES attributes:nil error:nil];
	
	// Create file
	BOOL result = [fileManager createFileAtPath:path contents:data attributes:nil];
	
	return result;
}
+ (BOOL)filePathIsKindOfImageFilePath:(NSString *)filePath{
    
    BOOL result;
    
    NSString *lastComponent = [filePath lastPathComponent];
    
    NSString *pathExtension = [lastComponent pathExtension];
    if (pathExtension.length>0) {
        
        pathExtension = [pathExtension lowercaseString];
        //bmp,jpg,tiff,gif
        if ([pathExtension isEqualToString:@"bmp"] ||[pathExtension isEqualToString:@"jpg"]||[pathExtension isEqualToString:@"tiff"]||[pathExtension isEqualToString:@"png"] ||[pathExtension isEqualToString:@"jpeg"]) {
            
            result = YES;
            
        }else{
            
            result = NO;   
            
        }
        
    }else{
        
        result = NO;
        
    }
    return result;
}

+ (BOOL) fileIsExist:(NSString *)path {
	NSFileManager *fileManager = [NSFileManager defaultManager];
	BOOL isExist = [fileManager fileExistsAtPath:path];
	return isExist;
}

+ (BOOL)writeImage:(UIImage*)image toPath:(NSString*)path {
	
	if ((image == nil) || (path == nil) || ([path isEqualToString:@""])) {
    
		return NO;
	
    }
	
	@try {
		
		NSData *imageData = nil;
		
		NSString *ext = [path pathExtension];
		
		if ([ext isEqualToString:@"png"]) {
			
			imageData = UIImagePNGRepresentation(image);
		} else {
			
			// the rest, we write to jpeg
			
			// 0. best, 1. lost. about compress.
			
			imageData = UIImageJPEGRepresentation(image, 0);
			
		}
		
		if ((imageData == nil) || ([imageData length] <= 0))
			
			return NO;
		
		[imageData writeToFile:path atomically:YES];
		
		return YES;
		
	} @catch (NSException *e) {
		
		NSLog(@"create thumbnail exception.");
		
	}
	
	return NO;
	
}
+(void)createDirectoryWithString:(NSString *)directory{
	NSFileManager *fileManager = [[NSFileManager alloc] init];
	NSError *error;
	//if (![fileManager fileExistsAtPath:directory isDirectory:YES]) {
    [fileManager createDirectoryAtPath:directory withIntermediateDirectories:YES attributes:nil error:&error];
	//}
	[fileManager release];
}
+ (UIImage *) createImageFromPdfAtPath:(NSString *)path width:(float)width height:(float)height scale:(float)scale {
	
	// Generate the image
	NSURL *pdfURL = [NSURL fileURLWithPath:path];
	
	CGPDFDocumentRef pdf = CGPDFDocumentCreateWithURL((CFURLRef)pdfURL);
    
	// Get the PDF Page that we will be drawing
	CGPDFPageRef page = CGPDFDocumentGetPage(pdf, 1);
	
	// determine the size of the PDF page
	// CGRect pageRect = CGPDFPageGetBoxRect(page, kCGPDFMediaBox);
	// float pdfScale = scrollView.frame.size.width/pageRect.size.width;
	// pageRect.size = CGSizeMake(pageRect.size.width*pdfScale, pageRect.size.height*pdfScale);
	CGRect pageRect = CGRectMake(0, 0, width, height);
	
	// Create a low res image representation of the PDF page to display before the TiledPDFView
	// renders its content.
	UIGraphicsBeginImageContext(pageRect.size);
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	// First fill the background with white.
	CGContextSetRGBFillColor(context, 1.0,1.0,1.0,1.0);
	CGContextFillRect(context,pageRect);
	
	CGContextSaveGState(context);
	// Flip the context so that the PDF page is rendered
	// right side up.
	CGContextTranslateCTM(context, 0.0, pageRect.size.height);
	CGContextScaleCTM(context, 1.0, -1.0);
	
	// Scale the context so that the PDF page is rendered 
	// at the correct size for the zoom level.
	CGContextScaleCTM(context, scale, scale);
	
	CGContextDrawPDFPage(context, page);
	CGContextRestoreGState(context);
    
	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	
	CGPDFDocumentRelease(pdf);
    
//	CGContextRelease(context);
	
	return image;
}

+(UIImage *)createImageWithData:(NSData *)data width:(float)width height:(float)height scale:(float)scale {
    
	
	CGDataProviderRef myData = CGDataProviderCreateWithCFData((CFDataRef)data);
	CGPDFDocumentRef pdf;
    
	pdf = CGPDFDocumentCreateWithProvider(myData);//CGPDFDocumentCreateWithURL((CFURLRef)pdfURL);
	
	// Get the PDF Page that we will be drawing
	CGPDFPageRef page = CGPDFDocumentGetPage(pdf, 1);
	
	// determine the size of the PDF page
	// CGRect pageRect = CGPDFPageGetBoxRect(page, kCGPDFMediaBox);
	// float pdfScale = scrollView.frame.size.width/pageRect.size.width;
	// pageRect.size = CGSizeMake(pageRect.size.width*pdfScale, pageRect.size.height*pdfScale);
	CGRect pageRect = CGRectMake(0, 0, width, height);
	
	// Create a low res image representation of the PDF page to display before the TiledPDFView
	// renders its content.
	UIGraphicsBeginImageContext(pageRect.size);
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	// First fill the background with white.
	CGContextSetRGBFillColor(context, 1.0,1.0,1.0,1.0);
	CGContextFillRect(context,pageRect);
	
	CGContextSaveGState(context);
	// Flip the context so that the PDF page is rendered
	// right side up.
	CGContextTranslateCTM(context, 0.0, pageRect.size.height);
	CGContextScaleCTM(context, 1.0, -1.0);
	
	// Scale the context so that the PDF page is rendered 
	// at the correct size for the zoom level.
	CGContextScaleCTM(context, scale, scale);
	
	CGContextDrawPDFPage(context, page);
    
	CGContextRestoreGState(context);
	
	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	
	CGPDFDocumentRelease(pdf);
    CGDataProviderRelease(myData);
//	CGContextRelease(context);
	
	return image;
}

+ (BOOL)writePdf:(NSString *)pdfPath toImage:(NSString *)imagePath width:(float)width height:(float)height scale:(float)scale {
    
	UIImage *pdfImage = [self createImageFromPdfAtPath:pdfPath width:width height:height scale:scale];
	BOOL result = [self writeImage:pdfImage toPath:imagePath];
	
	return result;
	
	
}
//读取文件大小
+(float)getFileSize:(NSString *)filePath{
    if ([filePath isKindOfClass:[NSString class]]) {
        NSFileManager * filemanager = [[NSFileManager alloc]init];
        NSNumber *theFileSize = 0;
        NSError *error;
        NSDictionary * attributes = [filemanager attributesOfItemAtPath:filePath error:&error];
        theFileSize = [attributes objectForKey:NSFileSize];
        float thesize= [theFileSize floatValue];
        thesize = thesize/1024/1024;
        //  thesize =thesize/1024;
        //NSLog(@"thesize %.3f",thesize);
        [filemanager  release];
        return  thesize;
    }
    return 0;
}

+(UIImage *)generateVideoThumb:(NSString *)videoPath
{
    NSURL *videoURL = [NSURL fileURLWithPath:videoPath];
    NSDictionary *opts = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO]
                                                     forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
    AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:videoURL options:opts];
    
    AVAssetImageGenerator *generator = [AVAssetImageGenerator assetImageGeneratorWithAsset:urlAsset];
    generator.appliesPreferredTrackTransform = YES;
    generator.maximumSize = CGSizeMake(96, 128.0);
    NSError *error = nil;
    CGImageRef cgImg = [generator copyCGImageAtTime:CMTimeMake(10, 10) actualTime:NULL error:&error];
    if (error == nil) {
        UIImage *image =  [UIImage imageWithCGImage:cgImg];
        CGImageRelease(cgImg);
        return image;
    } else {
        NSLog(@"Can not generate thumb from video, %@", error);
        CGImageRelease(cgImg);
        return nil;
    }
}
+ (UIImage*)scaleImage:(UIImage*)img toSize:(CGSize)size  
{  
    // 创建一个bitmap的context  
    // 并把它设置成为当前正在使用的context  
    UIGraphicsBeginImageContext(size); 
    // 绘制改变大小的图片  
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];  
    // 从当前context中创建一个改变大小后的图片  
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();  
    // 使当前的context出堆栈  
    UIGraphicsEndImageContext();  
    // 返回新的改变大小后的图片  
    return scaledImage;  
} 
+(BOOL)deleteFileWithFilePath:(NSString *)filePath{
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    BOOL success;
    NSError *error;
    success = [fileManager removeItemAtPath:filePath error:&error];
    [fileManager release];
    return success;
}

+(void)removeFilesAndFoldorsExecpt:(NSString *)folderName{
    NSFileManager *fileManager = [[NSFileManager alloc] init];
	NSArray *array = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [array objectAtIndex:0];
	NSArray *folders = [fileManager contentsOfDirectoryAtPath:documentPath error:nil];
    
    for (NSString *filePath in folders) {
        if (![filePath isEqualToString:folderName]) {
            NSError *error;
            NSString *fullPathName = [documentPath stringByAppendingFormat:@"/%@",filePath];
            [fileManager removeItemAtPath:fullPathName error:&error];
        }
    }
    [fileManager release];
}
+(void)removeFilesAndFoldorsExecptFolders:(NSArray *)folderNames{
    NSFileManager *fileManager = [[NSFileManager alloc] init];
	NSArray *array = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [array objectAtIndex:0];
    NSString *parentFilePath = [documentPath stringByAppendingFormat:@"/paper/"];
	NSArray *folders = [fileManager contentsOfDirectoryAtPath:parentFilePath error:nil];
    for (NSString *filePath in folders) {
        if (![self filePath:filePath EqualToFolders:folderNames]) {
            NSError *error;
            NSString *fullPathName = [parentFilePath stringByAppendingFormat:@"%@",filePath];
            [fileManager removeItemAtPath:fullPathName error:&error];
        }
    }
    [fileManager release];
}
+(BOOL)filePath:(NSString *)path EqualToFolders:(NSArray*)folders{
    BOOL equal = NO;
    for (int i =0; i < [folders count] ; i++) {
        NSString *folder = [folders objectAtIndex:i];
        if ([path isEqualToString:folder]){
            equal =YES;
            break;
        }else{
            equal =NO;
        }
    }
    return equal;
}

@end
