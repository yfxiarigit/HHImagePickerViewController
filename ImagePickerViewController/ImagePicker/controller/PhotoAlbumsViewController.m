//
//  PhotoAlbumsViewController.m
//  Cell
//
//  Created by yfxiari on 2018/6/1.
//  Copyright © 2018年 Qingchifan. All rights reserved.
//

#import "PhotoAlbumsViewController.h"
#import "ImagePickerViewController.h"
#import "PhotoAlbumCell.h"
#import "PhotoHelper.h"

@interface PhotoAlbumsViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation PhotoAlbumsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"照片";
    [self configTableView];
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
        NSArray *photoAlbums = [PhotoHelper getPhotoAlbums];
        for (int i = 0; i < photoAlbums.count; i++) {
            PhotoAlbum *album = photoAlbums[i];
            [_dataArray addObject:album];
        }
    }
    return _dataArray;
}

- (void)configTableView {
    
    _tableView = [[UITableView alloc] init];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [UIView new];
    [self.view addSubview:_tableView];
    [_tableView registerClass:[PhotoAlbumCell class] forCellReuseIdentifier:@"photoCell"];
}

- (void)viewDidLayoutSubviews {
    _tableView.frame = self.view.bounds;
    [super viewDidLayoutSubviews];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PhotoAlbumCell *cell = (PhotoAlbumCell *)[tableView dequeueReusableCellWithIdentifier:@"photoCell" forIndexPath:indexPath];
    PhotoAlbum *album = self.dataArray[indexPath.row];
    cell.photoAlbum = album;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    PhotoAlbum *photoAlbum = [self.dataArray objectAtIndex:indexPath.row];
    ImagePickerViewController *picker = [[ImagePickerViewController alloc] init];
    picker.photoAlbum = photoAlbum;
    [self.navigationController pushViewController:picker animated:YES];
}
@end
