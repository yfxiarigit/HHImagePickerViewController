//
//  PhotoHelper.h
//  Cell
//
//  Created by yfxiari on 2018/5/31.
//  Copyright © 2018年 Qingchifan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PhotoAlbum.h"

@interface PhotoHelper : NSObject

///获取相册专辑集合
+ (NSArray<PhotoAlbum *> *)getPhotoAlbums;

///获得所有照片专辑
+(PhotoAlbum *)getTheAllPhotoAlbum;

@end
