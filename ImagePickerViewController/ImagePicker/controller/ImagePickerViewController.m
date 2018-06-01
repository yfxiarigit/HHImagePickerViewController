//
//  ImagePickerViewController.m
//  Cell
//
//  Created by yfxiari on 2018/5/31.
//  Copyright © 2018年 Qingchifan. All rights reserved.
//

#import "ImagePickerViewController.h"
#import "ImagePickerBottomBar.h"

@interface ImagePickerViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, ImagePickerBottomBarDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) ImagePickerBottomBar *bottomBar;
@end

@implementation ImagePickerViewController {
    NSMutableArray<PhotoItem *> * _selectedPhotoItems;
}

- (instancetype)init {
    self = [super init];
    _maxSelectedPhotoCount = 1;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self configCollectionView];
    [self.view addSubview:self.bottomBar];
    self.navigationItem.title = _photoAlbum.albumName;
    [_photoAlbum getPhotoItemsResultHandler:^(NSArray<PhotoItem *> *imageArray) {
        [self.dataArray removeAllObjects];
        [self.dataArray addObjectsFromArray:imageArray];
        [self.collectionView reloadData];
    }];
}

- (void)configCollectionView{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    CGFloat cellWidth = floorf((self.view.bounds.size.width-6) / 4.0);
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
    [self.view addSubview:_collectionView];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGFloat bottomArea = 0;
    if ([UIScreen mainScreen].bounds.size.height == 812) {
        bottomArea = 34;
    }
    _collectionView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    UIEdgeInsets inset = _collectionView.contentInset;
    inset.bottom = bottomArea + 44;
    _collectionView.contentInset = inset;
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
    return cell;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    PhotoItem *item = self.dataArray[indexPath.row];
    PhotoCell *cell = (PhotoCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [cell seletedPhoto:!item.isSelected];
    if (item.isSelected) {
        [self.selectedPhotoItems addObject:item];
    }else {
        [self.selectedPhotoItems removeObject:item];
    }
}

#pragma mark - bar delegate

- (void)imagePickerBottomBarDidClickSureButton {
    
    NSMutableArray *arr = [NSMutableArray array];
    for (PhotoItem *item in self.selectedPhotoItems) {
         UIImage *image = [item getScaleImage];
        [arr addObject:image];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(imagePickerViewController:didFinished:)]) {
        [self.delegate imagePickerViewController:self didFinished:arr];
    }
}

#pragma mark - getter

- (void)setSelectedPhotoItems:(NSMutableArray<PhotoItem *> *)selectedPhotoItems {
    while (selectedPhotoItems.count > self.maxSelectedPhotoCount) {
        [selectedPhotoItems removeLastObject];
    }
    _selectedPhotoItems = selectedPhotoItems;
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