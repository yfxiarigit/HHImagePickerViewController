//
//  PhotoItem.m
//  Cell
//
//  Created by yfxiari on 2018/5/31.
//  Copyright © 2018年 Qingchifan. All rights reserved.
//

#import "PhotoItem.h"
#import "PhotoHelper.h"

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


@end
