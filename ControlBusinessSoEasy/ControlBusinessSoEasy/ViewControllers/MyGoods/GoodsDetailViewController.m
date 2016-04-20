//
//  GoodsDetailViewController.m
//  ControlBusinessSoEasy
//
//  Created by jiahui on 16/4/7.
//  Copyright © 2016年 JiaHui. All rights reserved.
//

#import "GoodsDetailViewController.h"
#import "GoodsInfoBean.h"
#import "MWPhotoBrowser.h"
#import "NewGoodsViewController.h"


@interface GoodsDetailViewController ()<UITableViewDelegate,UITableViewDataSource,MWPhotoBrowserDelegate> {
    NSArray *section0TitleArray;
    NSArray *section1TitleArray;
    NSArray *section2TitleArray;
    
    NSArray *section0KeysArr;
    NSArray *section1KeysArr;
    NSArray *section2KeysArr;
    
    NSArray *section0ImageArr;
    NSArray *section1ImageArr;
    
    NSMutableArray *smallImagesPathArray;
    NSMutableArray *bigImagesPathArray;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *photos;

@end

@implementation GoodsDetailViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (_isFromSearchView && self.navigationController.navigationBar.frame.origin.y < 0) {
        self.navigationController.navigationBar.frame = CGRectMake(0, 20, self.navigationController.navigationBar.bounds.size.width, self.navigationController.navigationBar.bounds.size.height);
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = _contentGoodsBean.name;
    [[UITools shareInstance] customNavigationLeftBarButtonForController:self];
    section0TitleArray = @[@"条码",@"名称",@"类别"];
    section1TitleArray = @[@"进价",@"售价",@"规格",@"库存",@"供应商"];
    section2TitleArray = @[@"供应商",@"备注"];
    
    section0KeysArr = @[@"goodsIDCode",@"name",@"category"];
    section1KeysArr = @[@"inPrice",@"outPrice",@"standard",@"stock",@"author"];
    
    section0ImageArr = @[@"NG_code_Gray",@"NG_name_Gray",@"NG_category_Gray"];
    section1ImageArr = @[@"NG_inPrice_Gray",@"NG_outPrice_Gray",@"NG_standard_Gray",@"NG_stock_Gray",@"NG_Author_Gray"];
    
    smallImagesPathArray = [NSMutableArray array];
    bigImagesPathArray = [NSMutableArray array];
    
    UIButton *editButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [editButton addTarget:self action:@selector(editButtionItemAction:) forControlEvents:UIControlEventTouchUpInside];
    [editButton setTitle:@"编辑" forState:UIControlStateNormal];
    editButton.frame = CGRectMake(0, 0, 40, 40);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:editButton];
    
    [self loadImages];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    smallImagesPathArray = nil;
    bigImagesPathArray = nil;
}

#pragma mark - Action
- (void)editButtionItemAction:(UIButton *)button {
    [self performSegueWithIdentifier:@"pushToNewGoodsVC" sender:self];
}

#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NewGoodsViewController *editGoods = (NewGoodsViewController *)[segue destinationViewController];
    editGoods.isEditType = YES;
    editGoods.contentBean = _contentGoodsBean;
    editGoods.modifyBlock = ^(GoodsInfoBean *bean) {
        self.contentGoodsBean = bean;
        [_tableView reloadData];
    };
}

#pragma mark - imageFileOperation
- (void)loadImages {
    [smallImagesPathArray removeAllObjects];
    [bigImagesPathArray removeAllObjects];
    NSArray *samllImages = [self imagePathForDocument:_contentGoodsBean.imagePath isBigImage:NO];
    NSArray *bigImages = [self imagePathForDocument:_contentGoodsBean.imagePath isBigImage:YES];
    [smallImagesPathArray addObjectsFromArray:samllImages];
    [bigImagesPathArray addObjectsFromArray:bigImages];
}

- (NSArray *)imagePathForDocument:(NSString *)imageDoumet isBigImage:(BOOL)isBigImage {
    NSString *imageDocumetPath = nil;
    if (isBigImage) {
        imageDocumetPath = [AppData getCachesDirectoryBigDocumentPath:imageDoumet];
    } else
        imageDocumetPath = [AppData getCachesDirectorySmallDocumentPath:imageDoumet];
    NSArray *sourceArray = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:imageDocumetPath error:nil];
    if (sourceArray.count != 0) {
        NSMutableArray *array = [NSMutableArray array];
        [sourceArray enumerateObjectsUsingBlock:^(NSString *fileName, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *imagePath = [imageDocumetPath stringByAppendingPathComponent:fileName];
            [array addObject:imagePath];
        }];
        return array;
    }else
        return nil;
}

#pragma mark - UITableView data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"商品信息";
    } else if (section == 1) {
        return @"";
    }  else if (section == 2) {
        return @"备注";
    }else if (section == 3) {
        return @"图片";
    }
    return @"";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 3;
    } else if (section == 1) {
        return 5;
    }  else if (section == 2) {
        return 1;
    }else if (section == 3) {
        return 1;
    }
    return @"";
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 3)
        return 98;
    else if (indexPath.section == 2) {
        return 70;
    } else
        return 53;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"goodsInfoCell";
    static NSString *imageCellIdentifier = @"ThreeImagesCell";
    static NSString *noteCellIdentifier = @"NoteCellIdentifier";
    NSInteger section = indexPath.section;
    NSUInteger row = indexPath.row;
    UITableViewCell *cell = nil;
    if (section == 2) {/////note
        cell = [tableView dequeueReusableCellWithIdentifier:noteCellIdentifier forIndexPath:indexPath];
        UILabel *contentLabel = (UILabel *)[cell viewWithTag:1];
        contentLabel.text = _contentGoodsBean.note;
    } else if (section == 3) {/////image
        cell = [tableView dequeueReusableCellWithIdentifier:imageCellIdentifier forIndexPath:indexPath];
        UIImageView *imageView1 = (UIImageView *)[cell viewWithTag:1];
        UIImageView *imageView2 = (UIImageView *)[cell viewWithTag:2];
        UIImageView *imageView3 = (UIImageView *)[cell viewWithTag:3];
        if (smallImagesPathArray.count >= 1) {
            imageView1.image = [UIImage imageWithContentsOfFile:smallImagesPathArray[0]];
        } 
        if (smallImagesPathArray.count >= 2) {
            imageView2.image = [UIImage imageWithContentsOfFile:smallImagesPathArray[1]];
        }
        if (smallImagesPathArray.count >= 3) {
            imageView3.image = [UIImage imageWithContentsOfFile:smallImagesPathArray[2]];
        }
        
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
        UIImageView *imageView = (UIImageView *)[cell viewWithTag:1];
        UILabel *titleLabel = (UILabel *)[cell viewWithTag:2];
        UILabel *contentLabel = (UILabel *)[cell viewWithTag:3];
        if (section == 0) {
            imageView.image = [UIImage imageNamed:section0ImageArr[row]];
            titleLabel.text = section0TitleArray[row];
            id contentText = [_contentGoodsBean valueForKeyPath:section0KeysArr[row]];
            if ([contentText isKindOfClass:[NSNumber class]] && contentText != nil) {
                contentLabel.text = ((NSNumber *)contentText).stringValue;
            } else if ([contentText isKindOfClass:[NSString class]]){
                contentLabel.text = [_contentGoodsBean valueForKeyPath:section0KeysArr[row]];
            }
        } else if(section == 1) {
            imageView.image = [UIImage imageNamed:section1ImageArr[row]];
            titleLabel.text = section1TitleArray[row];
            id contentText = [_contentGoodsBean valueForKeyPath:section1KeysArr[row]];
            if ([contentText isKindOfClass:[NSNumber class]] && contentText != nil) {
                contentLabel.text = ((NSNumber *)contentText).stringValue;
            } else if ([contentText isKindOfClass:[NSString class]]){
                contentLabel.text = [_contentGoodsBean valueForKeyPath:section1KeysArr[row]];
            }
        }
    }
    return cell;
}

#pragma mark - tableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section != 3) {//////noly image can select
        return ;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (bigImagesPathArray.count != 0) {
        NSMutableArray *photos = [NSMutableArray array];
        for (NSString *sourceStr in bigImagesPathArray) {
            UIImage *image = [UIImage imageWithContentsOfFile:sourceStr];
            [photos addObject:[MWPhoto photoWithImage:image]];
        }
        _photos = photos;
        MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
        //            browser.navigationController.navigationBar.tintColor = self.navigationController.navigationBar.tintColor;
        //            browser.navigationController.navigationBar.barTintColor = self.navigationController.navigationBar.barTintColor;
        //            browser.navigationController.navigationBar.titleTextAttributes = self.navigationController.navigationBar.titleTextAttributes;
        browser.displayActionButton = NO;
        browser.displayNavArrows = NO;
        browser.displaySelectionButtons = NO;
        browser.alwaysShowControls = NO;
        browser.zoomPhotosToFill = YES;
        browser.enableGrid = NO;
        browser.startOnGrid = NO;
        browser.enableSwipeToDismiss = YES;
        browser.autoPlayOnAppear = NO;
        [browser setCurrentPhotoIndex:0];
        [self.navigationController pushViewController:browser animated:YES];
    }
}

#pragma mark - MWPhotoBrowserDelegate
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return _photos.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < _photos.count)
        return [_photos objectAtIndex:index];
    return nil;
}

- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser didDisplayPhotoAtIndex:(NSUInteger)index {
    NSLog(@"Did start viewing photo at index %lu", (unsigned long)index);
}


@end
