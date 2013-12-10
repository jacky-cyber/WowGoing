//
//  FileUtil.h
//  HuaShang
//
//  Created by Alur on 11-8-30.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileUtil : NSObject {
    
}
//读写本地文件
+ (NSString *)dataFilePath:(NSString *)name;
// 将NSData写入到指定的路径
+ (BOOL)writeToFile:(NSString *)path withData:(NSData *)data;
// 判断路径中的文件是否存在
+ (BOOL)fileIsExist:(NSString *)path;
+ (BOOL)writeImage:(UIImage *)image toPath:(NSString *)path;
// 将UIImage文件写入到指定的路径。目前只支持jpg和png两种格式
+ (UIImage *)createImageFromPdfAtPath:(NSString *)path width:(float)width height:(float)height scale:(float)scale;
// 将pdf文件转换为image文件写入到指定的路径。目前只能将pdf转换为jpg和png
+ (BOOL)writePdf:(NSString *)pdfPath toImage:(NSString *)imagePath width:(float)width height:(float)height scale:(float)scale;
+(void)createDirectoryWithString:(NSString *)directory;
+(UIImage *)createImageWithData:(NSData *)data width:(float)width height:(float)height scale:(float)scale; 
+(float)getFileSize:(NSString *)filePath;
+(UIImage *)generateVideoThumb:(NSString *)videoPath;
+ (UIImage*)scaleImage:(UIImage*)img toSize:(CGSize)size;
+(BOOL)deleteFileWithFilePath:(NSString *)filePath;
+(void)removeFilesAndFoldorsExecpt:(NSString *)folderName;
+(BOOL)filePath:(NSString *)path EqualToFolders:(NSArray*)folders;
+(void)removeFilesAndFoldorsExecptFolders:(NSArray *)folderNames;
+ (BOOL)filePathIsKindOfImageFilePath:(NSString *)filePath;
@end
