//
//  ImagePickerViewController.m
//  Cell
//
//  Created by yfxiari on 2018/5/31.
//  Copyright © 2018年 Qingchifan. All rights reserved.
//

#import "ImagePickerViewController.h"
#import "ImageCropViewController.h"
#import "ImagePreViewController.h"
#import "ImagePickerBottomBar.h"
#import "PhotoCell.h"
#import "PhotoItem.h"
#import "PhotoAlbum.h"
#import <Photos/Photos.h>
#import "PhotoHelper.h"
#import "PhotoSelectedManager.h"
#import "ADUploadLoadingView.h"

@interface ImagePickerViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, ImagePickerBottomBarDelegate, ImageCropViewControllerDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) ImagePickerBottomBar *bottomBar;
@property (nonatomic, assign) ImagePickerStyle style;
@end

@implementation ImagePickerViewController {
    BOOL _isSelectedOriginalImage;
}

- (instancetype)initWithStyle:(ImagePickerStyle)style {
    if (self = [super init]) {
        _style = style;
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    _allowSelectedOriginalImage = NO;
    _isSelectedOriginalImage = NO;
    _allowPreview = NO;
    _allowTakePicture = NO;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor blackColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancel)];
    [self.view addSubview:self.collectionView];
    if (self.style == ImagePickerStyleMutiSelect) {
        [self.view addSubview:self.bottomBar];
    }
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGFloat bottomArea = 0;
    if ([UIScreen mainScreen].bounds.size.height == 812) {
        bottomArea = 34;
    }
    self.collectionView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    if (self.style == ImagePickerStyleMutiSelect) {
        UIEdgeInsets inset = self.collectionView.contentInset;
        inset.bottom = bottomArea + 44;
        self.collectionView.contentInset = inset;
        _bottomBar.frame = CGRectMake(0, self.view.bounds.size.height - bottomArea - 44, _collectionView.bounds.size.width, 44);
    }
}

#pragma mark - collectionView delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoCell" forIndexPath:indexPath];
    PhotoItem *item = self.dataArray[indexPath.row];
    cell.photoItem = item;
    cell.allowSelected = self.style == ImagePickerStyleMutiSelect ? YES : NO;
    cell.didClickSelectButtonBlock = ^(BOOL isSelected) {
        if (isSelected) {
            [ADUploadLoadingView show];
            [PhotoSelectedManager addPhotoItem:item resultHandler:^(UIImage *photo, NSDictionary *info) {
                [ADUploadLoadingView hide];
            } progressHandler:nil];
        }else {
            [PhotoSelectedManager removePhotoItem:item];
        }
    };
    return cell;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.style == ImagePickerStyleCrop) {//裁剪图片
        PhotoItem *item = self.dataArray[indexPath.row];
        [ADUploadLoadingView show];
        [PhotoHelper requestPreviewPhotoWithAsset:item.phAsset resultHandler:^(UIImage *photo, NSDictionary *info, BOOL isDegraded) {
            if (!isDegraded) {
                [ADUploadLoadingView hide];
                ImageCropViewController *vc = [[ImageCropViewController alloc] initWithImage:photo cropRect:CGRectMake(0.5 *([UIScreen mainScreen].bounds.size.width - 300), 0.5 *([UIScreen mainScreen].bounds.size.height - 300), 300, 300) imageCropStyle:ImageCropStyleCircle];
                vc.delegate = self;
                [self.navigationController pushViewController:vc animated:YES];
            }
            
        } progressHandler:nil networkAccessAllowed:YES];
    }
    
    if (self.style == ImagePickerStyleSingleSelect) {
        [ADUploadLoadingView show];
        PhotoItem *item = self.dataArray[indexPath.row];
        [PhotoSelectedManager addPhotoItem:item resultHandler:^(UIImage *photo, NSDictionary *info) {
            [ADUploadLoadingView hide];
            [self finish];
        } progressHandler:nil];
    }
    
}

#pragma mark - crop delegate

- (void)imageCropViewControllerDidCancel {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imageCropViewControllerDidFinishCrop:(UIImage *)cropImage {
    if (self.finishCropBlock) {
        self.finishCropBlock(cropImage);
    }
}

#pragma mark - bar delegate

- (void)imagePickerBottomBarDidClickSureButton {
    [self finish];
}

- (void)finish {
    if (self.delegate && [self.delegate respondsToSelector:@selector(imagePickerViewController:didFinishPickingPhotos:sourceAssets:isSelectedOriginalImage:)]) {
        [self.delegate imagePickerViewController:self didFinishPickingPhotos:[PhotoSelectedManager shareInstance].selectedImages sourceAssets:[PhotoSelectedManager shareInstance].selectedPhotoItems isSelectedOriginalImage:_isSelectedOriginalImage];
    }
    if (self.style != ImagePickerStyleMutiSelect) {
        [PhotoSelectedManager removeAllPhotoItems];
    }
}

- (void)imagePickerBottomBar:(ImagePickerBottomBar *)bar didClickOriginalButton:(BOOL)isSelected {
    _isSelectedOriginalImage = isSelected;
}

- (void)imagePickerBottomBarDidClickPreviewButton {
    if ([PhotoSelectedManager shareInstance].selectedPhotoItems.count) {
        ImagePreViewController *preview = [[ImagePreViewController alloc] init];
        preview.dataArray = [PhotoSelectedManager shareInstance].selectedPhotoItems;
        [self.navigationController pushViewController:preview animated:YES];
    }
}

#pragma mark - event

- (void)cancel {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - getter

- (void)setMaxAllowSelectedPhotoCount:(NSInteger)maxAllowSelectedPhotoCount {
    _maxAllowSelectedPhotoCount = maxAllowSelectedPhotoCount;
    [PhotoSelectedManager shareInstance].maxSelectedImages = maxAllowSelectedPhotoCount;
}

- (void)setPhotoAlbum:(PhotoAlbum *)photoAlbum {
    _photoAlbum = photoAlbum;
    
    self.navigationItem.title = _photoAlbum.albumName;
    [_photoAlbum getPhotoItemsResultHandler:^(NSArray<PhotoItem *> *imageArray) {
        [self.dataArray removeAllObjects];
        [self.dataArray addObjectsFromArray:imageArray];
        [self.collectionView reloadData];
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([PhotoSelectedManager shareInstance].selectedIocalIdentifiers.count && imageArray.count) {
                NSInteger index = 0;
                for (PhotoItem *item in self.dataArray) {
                    if ([[PhotoSelectedManager shareInstance].selectedIocalIdentifiers containsObject:item.phAsset.localIdentifier]) {
                        item.selected = YES;
                        index = [self.dataArray indexOfObject:item];
                    }
                }
                [self.collectionView reloadData];
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
                [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionTop animated:NO];
            }
        });
    }];
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        CGFloat cellWidth = floorf(([UIScreen mainScreen].bounds.size.width-6) / 4.0);
        layout.itemSize = CGSizeMake(cellWidth, cellWidth);
        layout.minimumLineSpacing = 2;
        layout.minimumInteritemSpacing = 2;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.alwaysBounceVertical = YES;
        self.collectionView.showsHorizontalScrollIndicator = NO;
        if (@available(iOS 11.0, *)) {
            self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        [_collectionView registerClass:[PhotoCell class] forCellWithReuseIdentifier:@"PhotoCell"];
    }
    return _collectionView;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (ImagePickerBottomBar *)bottomBar {
    if (!_bottomBar) {
        _bottomBar = [[ImagePickerBottomBar alloc] init];
        _bottomBar.delegate = self;
    }
    return _bottomBar;
}
@end
