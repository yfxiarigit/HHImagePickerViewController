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
#import "PhotoItem.h"
#import "CircleProgressView.h"
#import "PhotoSelectedManager.h"

@interface ViewController ()<ImagePickerViewControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIButton *selectPhotoButton;
@property (nonatomic, strong) UIButton *cancelAllSelectedImagesButton;
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
    UIImage *image = self.dataArray[indexPath.row];
    cell.image = image;
    return cell;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

#pragma mark - imagePicker delegate

- (void)imagePickerViewController:(ImagePickerViewController *)imagePickerViewController didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray<PhotoItem *> *)sourceAssets isSelectedOriginalImage:(BOOL)isSelectedOriginalImage {
    self.dataArray = nil;
    [self.dataArray addObjectsFromArray:photos];
    [self.collectionView reloadData];
    
    [_imagePickerViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerViewControllerDidCanceled:(ImagePickerViewController *)imagePickerViewController {
    
}

#pragma mark - event

- (void)selectPhotoButtonClick {
    PHAuthorizationStatus status = [PhotoHelper authorizationStatusAuthorized];
    if (status == PHAuthorizationStatusNotDetermined) {
        [PhotoHelper requestAuthorization:^(BOOL authorizationStatusAuthorized) {
            if (!authorizationStatusAuthorized) {
                return;
            }
            [self gotoImagePickerController];
            
        }];
    }else if (status == PHAuthorizationStatusDenied) {
        // alert
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请在iPhone的\"设置->隐私->相机\"选项中，允许xxx访问你的相机" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [alert dismissViewControllerAnimated:YES completion:nil];
        }];
        [alert addAction:sure];
        [self presentViewController:alert animated:YES completion:nil];
    }else {
        [self gotoImagePickerController];
    }
}

- (void)cancelAllSelectedImagesButtonClick {
    [self.dataArray removeAllObjects];
    [PhotoSelectedManager removeAllPhotoItems];
    [self.collectionView reloadData];
}

- (void)gotoImagePickerController {
    PhotoAlbumsViewController *vc = [[PhotoAlbumsViewController alloc] init];
    _imagePickerViewController = [[ImagePickerViewController alloc] initWithStyle:ImagePickerStyleMutiSelect];
    _imagePickerViewController.delegate = self;
    _imagePickerViewController.photoAlbum = [PhotoHelper getTheAllPhotoAlbum];
    __weak __typeof(&*_imagePickerViewController)imagePickerView = _imagePickerViewController;
    __weak __typeof(&*self)weakSelf = self;
    _imagePickerViewController.finishCropBlock = ^(UIImage *image) {
        [weakSelf.dataArray addObject:image];
        [weakSelf.collectionView reloadData];
        [imagePickerView dismissViewControllerAnimated:YES completion:nil];
    };
    vc.imagePickerViewController = _imagePickerViewController;
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

- (UIButton *)cancelAllSelectedImagesButton {
    if (!_cancelAllSelectedImagesButton) {
        _cancelAllSelectedImagesButton = [[UIButton alloc] init];
        [_cancelAllSelectedImagesButton setTitle:@"删除所有所有的图片" forState:UIControlStateNormal];
        [_cancelAllSelectedImagesButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_cancelAllSelectedImagesButton addTarget:self action:@selector(selectPhotoButtonClick) forControlEvents:UIControlEventTouchDown];
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
