//
//  GoodsDetailViewController.m
//  ControlBusinessSoEasy
//
//  Created by jiahui on 16/4/7.
//  Copyright © 2016年 JiaHui. All rights reserved.
//

#import "GoodsDetailViewController.h"
#import "GoodsInfoBean.h"

@interface GoodsDetailViewController ()<UITableViewDelegate,UITableViewDataSource> {
    NSArray *section0TitleArray;
    NSArray *section1TitleArray;
    NSArray *section2TitleArray;
    
    NSArray *section0KeysArr;
    NSArray *section1KeysArr;
    NSArray *section2KeysArr;
    
    NSArray *section0ImageArr;
    NSArray *section1ImageArr;
    
    NSMutableArray *smallImagesArray;
    NSMutableArray *bigImagesArray;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation GoodsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[UITools shareInstance] customNavigationLeftBarButtonForController:self];
    section0TitleArray = @[@"条码",@"名称",@"类别"];
    section1TitleArray = @[@"进价",@"售价",@"规格",@"库存",@"供应商"];
    section2TitleArray = @[@"供应商",@"备注"];
    
    section0KeysArr = @[@"goodsIDCode",@"name",@"category"];
    section1KeysArr = @[@"inPrice",@"outPrice",@"standard",@"stock",@"author"];
    
    section0ImageArr = @[@"NG_code_Gray",@"NG_name_Gray",@"NG_category_Gray"];
    section1ImageArr = @[@"NG_inPrice_Gray",@"NG_outPrice_Gray",@"NG_standard_Gray",@"NG_stock_Gray",@"NG_Author_Gray"];
    
    smallImagesArray = [NSMutableArray array];
    bigImagesArray = [NSMutableArray array];
    
    [self loadImages];
    [self loadImages];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    smallImagesArray = nil;
    bigImagesArray = nil;
}

#pragma mark - imageFileOperation
- (void)loadImages {
    NSArray *samllImages = [self imagePathForDocument:_contentGoodsBean.imagePath isBigImage:NO];
    NSArray *bigImages = [self imagePathForDocument:_contentGoodsBean.imagePath isBigImage:YES];
    [smallImagesArray addObjectsFromArray:samllImages];
    [bigImagesArray addObjectsFromArray:bigImages];
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
        if (smallImagesArray.count >= 1) {
            imageView1.image = [UIImage imageWithContentsOfFile:smallImagesArray[0]];
        } 
        if (smallImagesArray.count >= 2) {
            imageView2.image = [UIImage imageWithContentsOfFile:smallImagesArray[1]];
        }
        if (smallImagesArray.count >= 3) {
            imageView3.image = [UIImage imageWithContentsOfFile:smallImagesArray[2]];
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
            if ([contentText isKindOfClass:[NSNumber class]]) {
                contentLabel.text = ((NSNumber *)contentText).stringValue;
            } else
                contentLabel.text = [_contentGoodsBean valueForKeyPath:section0KeysArr[row]];
        } else if(section == 1) {
            imageView.image = [UIImage imageNamed:section1ImageArr[row]];
            titleLabel.text = section1TitleArray[row];
            id contentText = [_contentGoodsBean valueForKeyPath:section1KeysArr[row]];
            if ([contentText isKindOfClass:[NSNumber class]]) {
                contentLabel.text = ((NSNumber *)contentText).stringValue;
            } else
                contentLabel.text = [_contentGoodsBean valueForKeyPath:section1KeysArr[row]];
        }
    }
    return cell;
}

#pragma mark - tableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
