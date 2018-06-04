//
//  ViewController.m
//  3DTouch
//
//  Created by yfxiari on 2018/5/24.
//  Copyright © 2018年 Qingchifan. All rights reserved.
//

#import "ViewController.h"
#import "PhotoAlbumsViewController.h"
#import "ImagePickerViewController.h"
#import "PhotoHelper.h"
#import "SelectedCell.h"

@interface ViewController ()<ImagePickerViewControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIButton *selectPhotoButton;
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation ViewController
{
    ImagePickerViewController *_imagePickerViewController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.selectPhotoButton];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    _collectionView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 100);
    _selectPhotoButton.frame = CGRectMake(0.5 * (self.view.frame.size.width - 110), CGRectGetMaxY(_collectionView.frame), 110, 30);
}

#pragma mark - collectionView delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SelectedCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SelectedCell" forIndexPath:indexPath];
    PhotoItem *item = self.dataArray[indexPath.row];
    cell.image = [item getScaleImage];
    NSLog(@"%@", NSStringFromCGSize(cell.image.size));
    return cell;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

#pragma mark - imagePicker delegate

- (void)imagePickerViewController:(ImagePickerViewController *)imagePickerViewController didFinished:(NSArray<PhotoItem *> *)photos isSelectedOriginalImage:(BOOL)isSelectedOriginalImage {
    if (isSelectedOriginalImage) {
        for (PhotoItem *item in photos) {
            [item getOriginalPhotoWithAsset:item.phAsset resultHandler:^(UIImage *photo, NSDictionary *info, BOOL isDegraded) {
                
                self.dataArray = nil;
                [self.dataArray addObjectsFromArray:photos];
                [self.collectionView reloadData];
                [_imagePickerViewController dismissViewControllerAnimated:YES completion:nil];
            }];
        }
    }else {
        self.dataArray = nil;
        [self.dataArray addObjectsFromArray:photos];
        [self.collectionView reloadData];
    }
    
    [_imagePickerViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerViewControllerDidCanceled:(ImagePickerViewController *)imagePickerViewController {
    
}

#pragma mark - event

- (void)selectPhotoButtonClick {
    PhotoAlbumsViewController *vc = [[PhotoAlbumsViewController alloc] init];
    _imagePickerViewController = [[ImagePickerViewController alloc] init];
    _imagePickerViewController.delegate = self;
    _imagePickerViewController.photoAlbum = [PhotoHelper getTheAllPhotoAlbum];
    vc.imagePickerViewController = _imagePickerViewController;
    _imagePickerViewController.selectedPhotoItems = self.dataArray;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    nav.viewControllers = @[vc, _imagePickerViewController];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}

#pragma mark - getter

- (UICollectionView *)collectionView {
    if (!_collectionView) {
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
        [_collectionView registerClass:[SelectedCell class] forCellWithReuseIdentifier:@"SelectedCell"];
    }
    return _collectionView;
}

- (UIButton *)selectPhotoButton {
    if (!_selectPhotoButton) {
        _selectPhotoButton = [[UIButton alloc] init];
        [_selectPhotoButton setTitle:@"选择图片" forState:UIControlStateNormal];
        [_selectPhotoButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_selectPhotoButton addTarget:self action:@selector(selectPhotoButtonClick) forControlEvents:UIControlEventTouchDown];
    }
    return _selectPhotoButton;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
