//
//  MyGoodsViewController.m
//  ControlBusinessSoEasy
//
//  Created by jiahui on 16/4/7.
//  Copyright © 2016年 JiaHui. All rights reserved.
//

#import "MyGoodsViewController.h"
#import "GoodsInfoDao.h"
#import "GoodsInfoBean.h"

@interface MyGoodsViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate> {
    
    NSMutableArray *arrayGoods;
}

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation MyGoodsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[UITools shareInstance] customNavigationLeftBarButtonForController:self];
    NSArray *array = [[GoodsInfoDao shareInstance] selectUserAllGoods];
    arrayGoods = [NSMutableArray arrayWithArray:array];
    
    _tableView.rowHeight = 92;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - dataOperation
- (NSString *)imagePathForDocument:(NSString *)imageDoumet {
    NSString *imageDocumetPath = [AppData getCachesDirectorySmallDocumentPath:imageDoumet];
    NSArray *sourceArray = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:imageDocumetPath error:nil];
    if (sourceArray.count != 0) {
        NSString *source = sourceArray.firstObject;
        return [imageDocumetPath stringByAppendingPathComponent:source];
    }else
        return nil;
}

#pragma mark - UISearchBarDelegate
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return arrayGoods.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
     NSString *const cellIdentifier = @"goodsListCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    GoodsInfoBean *bean = arrayGoods[indexPath.row];
    
    UIImageView *imageView = (UIImageView *)[cell viewWithTag:1];
    NSString *imagePath = [self imagePathForDocument:bean.imagePath];
    if (imagePath) {
        imageView.image = [UIImage imageWithContentsOfFile:imagePath];
    } else
        imageView.image  = [UIImage imageNamed:@"NOPhoto"];
    
    UILabel *nameLabel = (UILabel *)[cell viewWithTag:2];
    nameLabel.text = [NSString stringWithFormat:@"名称：%@",bean.name];
    
    UILabel *categoryLabel = (UILabel *)[cell viewWithTag:3];
    categoryLabel.text = [NSString stringWithFormat:@"类别：%@",bean.category];
    
    UILabel *outPriceAndStockLabel = (UILabel *)[cell viewWithTag:4];
    outPriceAndStockLabel.text = [NSString stringWithFormat:@"售价：%@   库存：%@",bean.outPrice.stringValue ,bean.stock];
    return cell;
}

#pragma mark - tableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self performSegueWithIdentifier:@"pushToGoodsDetailVC" sender:self];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
