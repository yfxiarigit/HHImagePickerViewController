//
//  PhotoHelper.m
//  Cell
//
//  Created by yfxiari on 2018/5/31.
//  Copyright © 2018年 Qingchifan. All rights reserved.
//

#import "PhotoHelper.h"
#import "PhotoAlbum.h"

@implementation PhotoHelper

+(PhotoAlbum *)getTheAllPhotoAlbum {
    PhotoAlbum *album;
    PHFetchResult *systemCollections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    for (PHAssetCollection *collection in systemCollections) {
        switch (collection.assetCollectionSubtype) {
            case PHAssetCollectionSubtypeSmartAlbumUserLibrary:
            {
                album = [PhotoAlbum albumWithPHAssetCollection:collection];
                break;
            }
            default:
                break;
        }
    }
    return album;
}

+ (NSArray<PhotoAlbum *> *)getPhotoAlbums {
    NSMutableArray<PHAssetCollection *> *albumArray = [[NSMutableArray alloc] init];
    
    // 获得自带相册（除去相机胶卷、视频及无法上传的图片类型）
    PHFetchResult *systemCollections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    for (PHAssetCollection *collection in systemCollections) {
        switch (collection.assetCollectionSubtype) {
            // 视频
            case PHAssetCollectionSubtypeSmartAlbumVideos:
            // 慢动作
            case PHAssetCollectionSubtypeSmartAlbumSlomoVideos:
            // 所有照片
            //case PHAssetCollectionSubtypeSmartAlbumUserLibrary:
            // 延时摄影
            case PHAssetCollectionSubtypeSmartAlbumTimelapses:
            // 连拍快照
            case PHAssetCollectionSubtypeSmartAlbumBursts:
            // 最近添加
            case PHAssetCollectionSubtypeSmartAlbumRecentlyAdded:
                break;
            default:
                // 最近删除
                if (collection.assetCollectionSubtype != 1000000201) {
                    [albumArray addObject:collection];
                }
                break;
        }
    }
    
    // 获得自定义相册
    PHFetchResult<PHAssetCollection *> *customCollections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    for (PHAssetCollection *collection in customCollections) {
        [albumArray addObject:collection];
    }
    
    NSMutableArray<PhotoAlbum *> *albumResults = [NSMutableArray arrayWithCapacity:albumArray.count];
    [albumArray enumerateObjectsUsingBlock:^(PHAssetCollection * _Nonnull collection, NSUInteger idx, BOOL * _Nonnull stop) {
        PhotoAlbum *album = [PhotoAlbum albumWithPHAssetCollection:collection];
        if (album.photoCount > 0) {
            [albumResults addObject:album];
        }
    }];
    
    return albumResults;
}

+ (int32_t)requestPhotoWithPHAsset:(PHAsset *)asset imageSize:(CGSize)imageSize completion:(void (^)(UIImage *photo,NSDictionary *info,BOOL isDegraded))completion progressHandler:(void (^)(double progress, NSError *error, BOOL *stop, NSDictionary *info))progressHandler networkAccessAllowed:(BOOL)networkAccessAllowed {
    
    if (!CGSizeEqualToSize(imageSize, PHImageManagerMaximumSize)) {
        CGFloat imageW = imageSize.width * [UIScreen mainScreen].scale;
        CGFloat imageH = imageSize.height * [UIScreen mainScreen].scale;
        if (asset.pixelWidth < imageW || asset.pixelHeight < imageH) {
            imageSize = PHImageManagerMaximumSize;
        }else {
            imageSize = CGSizeMake(imageW, imageH);
        }
    }
    
    PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
    option.resizeMode = PHImageRequestOptionsResizeModeFast;
    option.networkAccessAllowed = networkAccessAllowed;
    int32_t imageRequestID = [[PHImageManager defaultManager] requestImageForAsset:asset
                                                                    targetSize:imageSize
                                                   contentMode:PHImageContentModeAspectFill
                                                                           options:option        resultHandler:^(UIImage *result, NSDictionary *info) {
        
        BOOL downloadFinined = (![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey]);
        if (downloadFinined && result) {
            //result = [PhotoHelper fixOrientation:result];//这种方式不会设置scale。
            result = [UIImage imageWithCGImage:result.CGImage scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp];
            if (completion) completion(result,info,[[info objectForKey:PHImageResultIsDegradedKey] boolValue]);
        }
    }];
    return imageRequestID;
}

+ (int32_t)requestPreviewPhotoWithAsset:(PHAsset *)asset resultHandler:(void (^)(UIImage *photo,NSDictionary *info,BOOL isDegraded))completion progressHandler:(void (^)(double progress, NSError *error, BOOL *stop, NSDictionary *info))progressHandler {
    return [self requestPhotoWithPHAsset:asset imageSize:[UIScreen mainScreen].bounds.size completion:completion progressHandler:progressHandler networkAccessAllowed:YES];
}

+ (int32_t)requestOriginalPhotoWithAsset:(PHAsset *)asset resultHandler:(void (^)(UIImage *photo,NSDictionary *info,NSInteger dataLength))completion progressHandler:(void (^)(double progress, NSError *error, BOOL *stop, NSDictionary *info))progressHandler {
    
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.networkAccessAllowed = YES;
    options.progressHandler = ^(double progress, NSError *error, BOOL *stop, NSDictionary *info) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (progressHandler) {
                progressHandler(progress, error, stop, info);
            }
        });
    };
    int32_t imageRequestID = [[PHImageManager defaultManager] requestImageDataForAsset:asset options:options resultHandler:^(NSData *imageData, NSString *dataUTI, UIImageOrientation orientation, NSDictionary *info) {
        if (imageData) {
            UIImage *resultImage = [UIImage imageWithData:imageData scale:[UIScreen mainScreen].scale];
//            resultImage = [PhotoHelper fixOrientation:resultImage];
            if (completion) completion(resultImage, info, imageData.length / 1024);
        }
    }];
    return imageRequestID;
}

+ (int32_t)requestAlbumPosterWithAlbum:(PhotoAlbum *)album imageWithSize:(CGSize)size resultHandler:(void (^)(UIImage *image, NSDictionary *info,BOOL isDegraded))resultHandler
{
    if (resultHandler == nil) {
        return 0;
    }
    int32_t imageRequestID = [self requestPhotoWithPHAsset:[album.assetFetchResult lastObject] imageSize:size completion:^(UIImage *photo, NSDictionary *info, BOOL isDegraded) {
        if (photo) {
            resultHandler(photo, info, isDegraded);
        }
    } progressHandler:nil networkAccessAllowed:YES];
    return imageRequestID;
}

+ (void)cancelImageRequest:(int32_t)imageRequestID {
    if (imageRequestID) {
        [[PHImageManager defaultManager] cancelImageRequest:imageRequestID];
    }
}

#pragma mark - Private

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


//等比例缩放到指定宽度
+ (UIImage *)compressImage:(UIImage *)sourceImage toTargetSize:(CGSize)targetSize {
    CGSize imageSize = sourceImage.size;
    
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    if (width < targetSize.width && height < targetSize.height) {
        return sourceImage;
    }
    
    CGFloat scaleWidth = width;
    CGFloat scaleHeight = height;
    if (width > height) {
        scaleWidth = targetSize.width;
        scaleHeight = height / width * scaleWidth;
    }else {
        scaleHeight = targetSize.height;
        scaleWidth = width / height * scaleHeight;
    }
    
    UIGraphicsBeginImageContext(CGSizeMake(scaleWidth, scaleHeight));
    [sourceImage drawInRect:CGRectMake(0, 0, scaleWidth, scaleHeight)];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}


@end
