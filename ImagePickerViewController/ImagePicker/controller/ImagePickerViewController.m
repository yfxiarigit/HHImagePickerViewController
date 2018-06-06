//
//  ImagePickerViewController.m
//  Cell
//
//  Created by yfxiari on 2018/5/31.
//  Copyright © 2018年 Qingchifan. All rights reserved.
//

#import "ImagePickerViewController.h"
#import "ImagePreViewController.h"
#import "ImagePickerBottomBar.h"
#import "PhotoCell.h"
#import "PhotoItem.h"
#import "PhotoAlbum.h"

@interface ImagePickerViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, ImagePickerBottomBarDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) ImagePickerBottomBar *bottomBar;
@end

@implementation ImagePickerViewController {
    NSMutableArray<PhotoItem *> * _selectedPhotoItems;
    BOOL _isSelectedOriginalImage;
}

- (instancetype)init {
    self = [super init];
    _maxAllowSelectedPhotoCount = 1;
    _allowSelectedOriginalImage = NO;
    _isSelectedOriginalImage = NO;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor blackColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancel)];
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.bottomBar];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGFloat bottomArea = 0;
    if ([UIScreen mainScreen].bounds.size.height == 812) {
        bottomArea = 34;
    }
    self.collectionView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    UIEdgeInsets inset = self.collectionView.contentInset;
    inset.bottom = bottomArea + 44;
    self.collectionView.contentInset = inset;
    _bottomBar.frame = CGRectMake(0, self.view.bounds.size.height - bottomArea - 44, _collectionView.bounds.size.width, 44);
}

#pragma mark - collectionView delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoCell" forIndexPath:indexPath];
    PhotoItem *item = self.dataArray[indexPath.row];
    cell.photoItem = item;
    __weak __typeof(&*self)weakSelf = self;
    cell.didClickSelectButtonBlock = ^(BOOL isSelected) {
        if (isSelected) {
            [weakSelf.selectedPhotoItems addObject:item];
        }else {
            [weakSelf.selectedPhotoItems removeObject:item];
        }
    };
    return cell;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    [cell seletedPhoto:!item.isSelected];
//    if (item.isSelected) {
//        [self.selectedPhotoItems addObject:item];
//    }else {
//        [self.selectedPhotoItems removeObject:item];
//    }
}

#pragma mark - bar delegate

- (void)imagePickerBottomBarDidClickSureButton {
    if (self.delegate && [self.delegate respondsToSelector:@selector(imagePickerViewController:didFinished: isSelectedOriginalImage:)]) {
        [self.delegate imagePickerViewController:self didFinished:self.selectedPhotoItems isSelectedOriginalImage:_isSelectedOriginalImage];
    }
}

- (void)imagePickerBottomBar:(ImagePickerBottomBar *)bar didClickOriginalButton:(BOOL)isSelected {
    _isSelectedOriginalImage = isSelected;
}

- (void)imagePickerBottomBarDidClickPreviewButton {
    if (self.selectedPhotoItems.count) {
        ImagePreViewController *preview = [[ImagePreViewController alloc] init];
        preview.dataArray = self.selectedPhotoItems;
        [self.navigationController pushViewController:preview animated:YES];
    }
}

#pragma mark - event

- (void)cancel {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - getter

- (void)setAllowSelectedOriginalImage:(BOOL)allowSelectedOriginalImage {
    _allowSelectedOriginalImage = allowSelectedOriginalImage;
    self.bottomBar.showOriginalButton = _allowSelectedOriginalImage;
}

- (void)setPhotoAlbum:(PhotoAlbum *)photoAlbum {
    _photoAlbum = photoAlbum;
    
    self.navigationItem.title = _photoAlbum.albumName;
    [_photoAlbum getPhotoItemsResultHandler:^(NSArray<PhotoItem *> *imageArray) {
        [self.dataArray removeAllObjects];
        [self.dataArray addObjectsFromArray:imageArray];
        [self.collectionView reloadData];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.selectedPhotoItems.count) {
                NSMutableArray *arr = [NSMutableArray array];
                for (PhotoItem *item in self.selectedPhotoItems) {
                    [arr addObject:item.phAsset.localIdentifier];
                }
                [self.selectedPhotoItems removeAllObjects];
                NSInteger index = 0;
                for (PhotoItem *item in self.dataArray) {
                    if ([arr containsObject:item.phAsset.localIdentifier]) {
                        item.selected = YES;
                        index = [self.dataArray indexOfObject:item];
                        [self.selectedPhotoItems addObject:item];
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

- (NSMutableArray<PhotoItem *> *)selectedPhotoItems {
    if (!_selectedPhotoItems) {
        _selectedPhotoItems = [NSMutableArray array];
    }
    return _selectedPhotoItems;
}

- (ImagePickerBottomBar *)bottomBar {
    if (!_bottomBar) {
        _bottomBar = [[ImagePickerBottomBar alloc] init];
        _bottomBar.delegate = self;
    }
    return _bottomBar;
}
@end
