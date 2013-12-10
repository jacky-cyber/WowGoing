/*
 * This file is part of the SDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "SDWebImageCompat.h"
#import "SDWebImageManagerDelegate.h"



#define BRAND_PRO       8801
#define BRAND_DET       8802
#define BRAND_PRO_DET   8803
#define BRAND_FAV       8804

#define ADPRODUCT       88058

@interface UIImageView (WebCache) <SDWebImageManagerDelegate>


- (void)setImageWithURL:(NSURL *)url;
- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder;
- (void)cancelCurrentImageLoad;

@end
