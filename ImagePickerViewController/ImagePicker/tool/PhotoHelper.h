//
//  PhotoHelper.h
//  Cell
//
//  Created by yfxiari on 2018/5/31.
//  Copyright © 2018年 Qingchifan. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *KOriginalImageDataLengthKey = @"KOriginalImageDataLengthKey";

@class PhotoAlbum, PhotoItem, PHAsset;
@interface PhotoHelper : NSObject

///获取相册集合
+ (NSArray<PhotoAlbum *> *)getPhotoAlbums;

///获得‘所有照片’相册
+(PhotoAlbum *)getTheAllPhotoAlbum;

///获取指定大小的图片
+ (int32_t)requestPhotoWithPHAsset:(PHAsset *)asset imageSize:(CGSize)imageSize completion:(void (^)(UIImage *photo,NSDictionary *info,BOOL isDegraded))completion progressHandler:(void (^)(double progress, NSError *error, BOOL *stop, NSDictionary *info))progressHandler networkAccessAllowed:(BOOL)networkAccessAllowed;

///获取原图 (dataLength:单位kb)
+ (int32_t)requestOriginalPhotoWithAsset:(PHAsset *)asset resultHandler:(void (^)(UIImage *photo,NSDictionary *info,NSInteger dataLength))completion progressHandler:(void (^)(double progress, NSError *error, BOOL *stop, NSDictionary *info))progressHandler;

///获取预览图片
+ (int32_t)requestPreviewPhotoWithAsset:(PHAsset *)asset resultHandler:(void (^)(UIImage *photo,NSDictionary *info,BOOL isDegraded))completion progressHandler:(void (^)(double progress, NSError *error, BOOL *stop, NSDictionary *info))progressHandler;

///获取相册的封面
+ (int32_t)requestAlbumPosterWithAlbum:(PhotoAlbum *)album imageWithSize:(CGSize)size resultHandler:(void (^)(UIImage *photo, NSDictionary *info,BOOL isDegraded))resultHandler;

///取消请求图片
+ (void)cancelImageRequest:(int32_t)imageRequestID;

///调整图片方向
+ (UIImage *)fixOrientation:(UIImage *)srcImg;

@end
