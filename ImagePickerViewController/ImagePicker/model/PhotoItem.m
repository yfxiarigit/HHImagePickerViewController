//
//  PhotoItem.m
//  Cell
//
//  Created by yfxiari on 2018/5/31.
//  Copyright © 2018年 Qingchifan. All rights reserved.
//

#import "PhotoItem.h"
#import "UIImage+PhotoEx.h"

@interface PhotoItem()
/// 最大缩略图
@property (nonatomic, strong) UIImage *scalePhoto;
@end

@implementation PhotoItem


+ (PhotoItem *)itemWithPHAsset:(PHAsset *)asset {
    if (!asset) {
        return nil;
    }
    
    PhotoItem *item = [[PhotoItem alloc] init];
    item.phAsset = asset;
    return item;
}

- (PHImageRequestID)getThumbImageWithSize:(CGSize)size resultHandler:(void (^)(UIImage *image, NSDictionary *info))resultHandler
{
    if (CGSizeEqualToSize(size, CGSizeZero)) {
        CGFloat imageLength = 135.f;
        size = CGSizeMake(imageLength, imageLength);
    }
    
    if (self.phAsset) {
        PHImageManager *imageManager = [PHImageManager defaultManager];
        
        PHImageRequestID imageRequestId = [imageManager requestImageForAsset:self.phAsset
                                targetSize:size
                               contentMode:PHImageContentModeAspectFill
                                   options:nil
                             resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                                 
                                 if (result) {
                                     if (resultHandler) {
                                         resultHandler(result, info);
                                     }
                                 }
                             }];
        
        return imageRequestId;
    }
    return -1;
}


- (UIImage *)getScaleImage
{
    if (self.scalePhoto) {
        return _scalePhoto;
    }
    __block UIImage *originImage = nil;

    if (!self.phAsset) {
        return nil;
    }

    PHAsset *asset = self.phAsset;
    PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
    option.synchronous = YES;
    option.resizeMode = PHImageRequestOptionsResizeModeFast;
    option.deliveryMode = PHImageRequestOptionsDeliveryModeFastFormat;

    //从asset中获得图片
    CGSize size = CGSizeMake(asset.pixelWidth, asset.pixelHeight);
    [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:[PhotoItem maxImageSizeWithOriginalSize:size] contentMode:PHImageContentModeAspectFill options:option resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
    
        BOOL downloadFinined = (![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey]);
        if (downloadFinined && result != nil) {
            // 调整图片方向
            result = [PhotoItem fixOrientation:result];
            originImage = result;
            //下面两个中任一个都可以标示相册中图片的唯一性
            originImage.localIdentifier = asset.localIdentifier;
            originImage.phImageFileURLKey = info[@"PHImageFileURLKey"];
        }
    }];
    self.scalePhoto = originImage;
    return originImage;
}

+ (UIImage *)fixOrientation:(UIImage *)srcImg {
    if (srcImg.imageOrientation == UIImageOrientationUp) return srcImg;
    CGAffineTransform transform = CGAffineTransformIdentity;
    switch (srcImg.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, srcImg.size.width, srcImg.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, srcImg.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, srcImg.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
            break;
    }
    
    switch (srcImg.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, srcImg.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, srcImg.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationDown:
        case UIImageOrientationLeft:
        case UIImageOrientationRight:
            break;
    }
    
    CGContextRef ctx = CGBitmapContextCreate(NULL, srcImg.size.width, srcImg.size.height,
                                             CGImageGetBitsPerComponent(srcImg.CGImage), 0,
                                             CGImageGetColorSpace(srcImg.CGImage),
                                             CGImageGetBitmapInfo(srcImg.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (srcImg.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            CGContextDrawImage(ctx, CGRectMake(0,0,srcImg.size.height,srcImg.size.width), srcImg.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,srcImg.size.width,srcImg.size.height), srcImg.CGImage);
            break;
    }
    
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

+ (CGSize)maxImageSizeWithOriginalSize:(CGSize)originalSize
{
    CGFloat sizeScale = originalSize.width / originalSize.height;
    
        if (sizeScale >= 2.0) { // 宽大于高的两倍
            // 宽图 按高来压 高不超过800
            CGFloat compressionRatio = originalSize.height / 800;
            if (compressionRatio > 1.0) {
                originalSize = CGSizeMake(floor(originalSize.width / compressionRatio), floor(originalSize.height / compressionRatio));
            }
        } else if (sizeScale <= 0.5) { // 宽小于高的一半
            // 长图 按宽来压 宽不超过800
            CGFloat compressionRatio = originalSize.width / 800;
            if (compressionRatio > 1.0) {
                originalSize = CGSizeMake(floor(originalSize.width / compressionRatio), floor(originalSize.height / compressionRatio));
            }
        } else { // 正常图
    
            // 根据图片的宽高尺寸设置图片约束（宽高压缩过不超过1000 * 1000）
            CGFloat tempWidth = originalSize.width / 1000;
            CGFloat tempHeight = originalSize.height / 1000;
    
            if(tempWidth > 1. && tempWidth >= tempHeight)
            {
                // 如果宽大于高的  高缩小时 要往小了取整 不然图片会有白边
                originalSize = CGSizeMake(floor(originalSize.width / tempWidth), floor(originalSize.height / tempWidth));
            }
            else if(tempHeight > 1. && tempWidth <= tempHeight)
            {
                // 如果高大于宽的  宽缩小时 要往小了取整 不然图片会有白边
                originalSize = CGSizeMake(floor(originalSize.width / tempHeight), floor(originalSize.height / tempHeight));
            }
    
        }
    
    return originalSize;
}


- (void)getOriginalPhotoWithAsset:(PHAsset *)asset resultHandler:(void (^)(UIImage *photo,NSDictionary *info,BOOL isDegraded))completion {
    PHImageRequestOptions *option = [[PHImageRequestOptions alloc]init];
    option.networkAccessAllowed = YES;
    option.resizeMode = PHImageRequestOptionsResizeModeFast;
    [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeAspectFit options:option resultHandler:^(UIImage *result, NSDictionary *info) {
        BOOL downloadFinined = (![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey]);
        if (downloadFinined && result) {
            result = [PhotoItem fixOrientation:result];
            BOOL isDegraded = [[info objectForKey:PHImageResultIsDegradedKey] boolValue];
            if (completion) completion(result,info,isDegraded);
        }
    }];
}


@end
