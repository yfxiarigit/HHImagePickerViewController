//
//  PhotoAlbum.h
//  Cell
//
//  Created by yfxiari on 2018/5/31.
//  Copyright © 2018年 Qingchifan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PhotoItem.h"

@interface PhotoAlbum : NSObject
/// 该相册中包含的照片数量
@property (nonatomic, assign) NSInteger photoCount;
/// 相册名字。如果是英文的，需要在info.plist中添加CFBundleAllowMixedLocalizations = true
@property (nonatomic, strong) NSString *albumName;

/// 相册示例
+ (instancetype)albumWithPHAssetCollection:(PHAssetCollection *)collection;

/// 获得相册中的相片
- (void)getPhotoItemsResultHandler:(void (^)(NSArray<PhotoItem *> *imageArray))handler;

/// 获得相册的封面
- (void)getAlbumsPosterImageWithSize:(CGSize)size resultHandler:(void (^)(UIImage *image, NSDictionary *info))resultHandler;
@end
