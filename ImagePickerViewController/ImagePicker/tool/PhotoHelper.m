//
//  PhotoHelper.m
//  Cell
//
//  Created by yfxiari on 2018/5/31.
//  Copyright © 2018年 Qingchifan. All rights reserved.
//

#import "PhotoHelper.h"

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

@end
