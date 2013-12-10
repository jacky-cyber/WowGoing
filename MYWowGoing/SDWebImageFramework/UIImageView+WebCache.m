/*
 * This file is part of the SDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "UIImageView+WebCache.h"
#import "SDWebImageManager.h"
#import <QuartzCore/QuartzCore.h>
@implementation UIImageView (WebCache)

- (void)setImageWithURL:(NSURL *)url
{
    [self setImageWithURL:url placeholderImage:nil];
    
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder
{
    SDWebImageManager *manager = [SDWebImageManager sharedManager];

    // Remove in progress downloader from queue
    [manager cancelForDelegate:self];

    self.image = placeholder;

    if (url)
    {
        [manager downloadWithURL:url delegate:self];
    }
}

- (void)cancelCurrentImageLoad
{
    [[SDWebImageManager sharedManager] cancelForDelegate:self];
}

- (UIImage *)cutImage:(UIImage *)image toSize:(CGSize)size
{
    if (!image)
    {
        return nil;
    }
    
    // 先缩放
    CGFloat scale = size.width / image.size.width;
    UIGraphicsBeginImageContext(CGSizeMake(size.width, image.size.height * scale));
    [image drawInRect:CGRectMake(0, 0, size.width, image.size.height * scale)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // 再截断
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    CGImageRef imageRef = scaledImage.CGImage;
    CGImageRef subImageRef = CGImageCreateWithImageInRect(imageRef, rect);
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, rect, subImageRef);
    UIImage * cuttedImage = [UIImage imageWithCGImage:subImageRef];
    CGImageRelease(subImageRef);
    UIGraphicsEndImageContext();
    return cuttedImage;
}

- (void)webImageManager:(SDWebImageManager *)imageManager didFinishWithImage:(UIImage *)image
{ 
    switch (self.tag) {
        case BRAND_FAV:
            self.image = [self cutImage:image toSize:self.frame.size];
            break;
            
        default:
            self.image = image;
            break;
    }

//        self.image = image;

}

- (UIImage *) scaleImage:(UIImage *)image toScale:(float)scaleSize {
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width / scaleSize, image.size.height / scaleSize));
    [image drawInRect:CGRectMake(0, 0, image.size.width / scaleSize, image.size.height / scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

@end
