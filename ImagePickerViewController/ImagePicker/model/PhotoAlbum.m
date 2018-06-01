//
//  PhotoAlbum.m
//  Cell
//
//  Created by yfxiari on 2018/5/31.
//  Copyright © 2018年 Qingchifan. All rights reserved.
//

#import "PhotoAlbum.h"

@interface PhotoAlbum()
@property (nonatomic, strong) PHFetchResult *assetFetchResult;
/// 相册封面
@property (nonatomic, strong) UIImage *albumPoster;
@end

@implementation PhotoAlbum

+ (instancetype)albumWithPHAssetCollection:(PHAssetCollection *)collection {
    if (!collection) {
        return nil;
    }
    
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    options.predicate = [NSPredicate predicateWithFormat:@"mediaType == %d", PHAssetMediaTypeImage];
    options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
    
    PHFetchResult *result = [PHAsset fetchAssetsInAssetCollection:collection options:options];
    PhotoAlbum *album = [[PhotoAlbum alloc] init];
    
    album.assetFetchResult = result;
    album.photoCount = result.count;
    album.albumName = collection.localizedTitle;
    
    return album;
}

- (void)getPhotoItemsResultHandler:(void (^)(NSArray<PhotoItem *> *imageArray))handler
{
    if (!handler) {
        return;
    }
    
    NSMutableArray<PhotoItem *> *imageArray = [NSMutableArray array];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.assetFetchResult enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            @autoreleasepool {
                if (!obj || ![obj isKindOfClass:[PHAsset class]]) {
                    return ;
                }
                
                PhotoItem *item = [PhotoItem itemWithPHAsset:(PHAsset *)obj];
                if (item.phAsset)  {
                    [imageArray addObject:item];
                }
            }
        }];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            handler(imageArray);
        });
    });
}

- (void)getAlbumsPosterImageWithSize:(CGSize)size resultHandler:(void (^)(UIImage *image, NSDictionary *info))resultHandler
{
    if (self.albumPoster && resultHandler) {
        resultHandler(self.albumPoster, nil);
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    PHImageManager *imageManager = [PHImageManager defaultManager];
    
    if (CGSizeEqualToSize(size, CGSizeZero)) {
        CGFloat length = 100.f;
        size = CGSizeMake(length, length);
    }
    
    [imageManager requestImageForAsset:[self.assetFetchResult lastObject]
                            targetSize:size
                           contentMode:PHImageContentModeAspectFit
                               options:nil
                         resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                             
                             if (result) {
                                 __strong typeof(weakSelf) strongSelf = weakSelf;
                                 strongSelf.albumPoster = result;
                                 
                                 if (resultHandler) {
                                     resultHandler(result, info);
                                 }
                             }
                         }];
}

@end
