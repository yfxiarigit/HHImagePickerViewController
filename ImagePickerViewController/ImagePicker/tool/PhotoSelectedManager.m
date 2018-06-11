//
//  PhotoSelectedManager.m
//  ImagePickerViewController
//
//  Created by yfxiari on 2018/6/11.
//  Copyright © 2018年 Qingchifan. All rights reserved.
//

#import "PhotoSelectedManager.h"
#import "PhotoHelper.h"
#import "PhotoItem.h"

@interface PhotoSelectedManager()
@property (nonatomic, strong) NSMutableArray<PhotoItem *> *selectedPhotoItems;
@property (nonatomic, strong) NSMutableArray<UIImage *> *selectedImages;
@property (nonatomic, strong) NSMutableArray<NSString *> *selectedIocalIdentifiers;
@end

@implementation PhotoSelectedManager

+ (instancetype)shareInstance {
    static PhotoSelectedManager *_shareInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shareInstance = [[self alloc] init];
    });
    return _shareInstance;
}

- (instancetype)init {
    if (self = [super init]) {
        self.maxSelectedImages = 3;
    }
    return self;
}

+ (int32_t)addPhotoItem:(PhotoItem *)item resultHandler:(void (^)(UIImage *photo, NSDictionary *info))completion progressHandler:(void (^)(double, NSError *, BOOL *, NSDictionary *))progressHandler {
    if (item.phAsset == nil) {
        return 0;
    }
    int32_t requestImageID = [PhotoHelper requestPreviewPhotoWithAsset:item.phAsset resultHandler:^(UIImage *photo, NSDictionary *info, BOOL isDegraded) {
        if (!isDegraded) {
            [self addPhoto:photo item:item];
        }
        if (completion && !isDegraded) {
            completion(photo, info);
        }
    } progressHandler:^(double progress, NSError *error, BOOL *stop, NSDictionary *info) {
        if (progressHandler) {
            progressHandler(progress, error, stop, info);
        }
    } networkAccessAllowed:YES];
    return requestImageID;
}

+ (void)removePhotoItem:(PhotoItem *)item {
    if (item && [[PhotoSelectedManager shareInstance].selectedIocalIdentifiers containsObject:item.phAsset.localIdentifier]) {
        NSInteger index = [[PhotoSelectedManager shareInstance].selectedIocalIdentifiers indexOfObject:item.phAsset.localIdentifier];
        [[PhotoSelectedManager shareInstance].selectedPhotoItems removeObjectAtIndex:index];
        [[PhotoSelectedManager shareInstance].selectedImages removeObjectAtIndex:index];
        [[PhotoSelectedManager shareInstance].selectedIocalIdentifiers removeObjectAtIndex:index];;
    }
}

+ (void)removeAllPhotoItems {
    [[PhotoSelectedManager shareInstance].selectedPhotoItems removeAllObjects];
    [[PhotoSelectedManager shareInstance].selectedImages removeAllObjects];
}

+ (BOOL)checkIsAllowSelected {
    if ([PhotoSelectedManager shareInstance].selectedImages.count < [PhotoSelectedManager shareInstance].maxSelectedImages) {
        return YES;
    }else {
        return NO;
    }
}

#pragma mark - Private
+ (void)addPhoto:(UIImage *)photo item:(PhotoItem *)item {
    if (photo && item && item.phAsset) {
        [[PhotoSelectedManager shareInstance].selectedPhotoItems addObject:item];
        [[PhotoSelectedManager shareInstance].selectedImages addObject:photo];
        [[PhotoSelectedManager shareInstance].selectedIocalIdentifiers addObject:item.phAsset.localIdentifier];
    }
}

#pragma mark - getter

- (NSMutableArray<UIImage *> *)selectedImages {
    if (!_selectedImages) {
        _selectedImages = [NSMutableArray array];
    }
    return _selectedImages;
}

- (NSMutableArray<PhotoItem *> *)selectedPhotoItems {
    if (!_selectedPhotoItems) {
        _selectedPhotoItems = [NSMutableArray array];
    }
    return _selectedPhotoItems;
}

- (NSMutableArray<NSString *> *)selectedIocalIdentifiers {
    if (!_selectedIocalIdentifiers) {
        _selectedIocalIdentifiers = [NSMutableArray array];
    }
    return _selectedIocalIdentifiers;
}

@end
