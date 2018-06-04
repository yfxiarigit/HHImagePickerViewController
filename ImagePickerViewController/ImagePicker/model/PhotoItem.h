//
//  PhotoItem.h
//  Cell
//
//  Created by yfxiari on 2018/5/31.
//  Copyright © 2018年 Qingchifan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

@interface PhotoItem : NSObject

@property (nonatomic, assign, getter=isSelected) BOOL selected;
@property (nonatomic, strong) PHAsset *phAsset;

+ (PhotoItem *)itemWithPHAsset:(PHAsset *)asset;
- (PHImageRequestID)getThumbImageWithSize:(CGSize)size resultHandler:(void (^)(UIImage *image, NSDictionary *info))resultHandler;

///获得压缩原图, 尺寸最大1000.
- (UIImage *)getScaleImage;

///获得原图
- (void)getOriginalPhotoWithAsset:(PHAsset *)asset resultHandler:(void (^)(UIImage *photo,NSDictionary *info,BOOL isDegraded))completion;
@end
