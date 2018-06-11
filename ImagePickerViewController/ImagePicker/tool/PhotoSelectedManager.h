//
//  PhotoSelectedManager.h
//  ImagePickerViewController
//
//  Created by yfxiari on 2018/6/11.
//  Copyright © 2018年 Qingchifan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PhotoItem;
@interface PhotoSelectedManager : NSObject
@property (nonatomic, strong, readonly) NSMutableArray<PhotoItem *> *selectedPhotoItems;
@property (nonatomic, strong, readonly) NSMutableArray<UIImage *> *selectedImages;
@property (nonatomic, strong, readonly) NSMutableArray<NSString *> *selectedIocalIdentifiers;

///默认3张
@property (nonatomic, assign) NSInteger maxSelectedImages;

+ (instancetype)shareInstance;

/// 选中图片
+ (int32_t)addPhotoItem:(PhotoItem *)item resultHandler:(void (^)(UIImage *photo,NSDictionary *info))completion progressHandler:(void (^)(double progress, NSError *error, BOOL *stop, NSDictionary *info))progressHandler;

///取消选中图片
+ (void)removePhotoItem:(PhotoItem *)item;

//取消所有图片的选中状态
+ (void)removeAllPhotoItems;

+ (BOOL)checkIsAllowSelected;

@end
