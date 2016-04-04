//
//  AddCategoryVC.m
//  EasyBusiness
//
//  Created by jiahui on 15/12/1.
//  Copyright © 2015年 YouZai. All rights reserved.
//

#import "AddCategoryVC.h"
#import "EditCategoryViewController.h"
#import "BigCategoryDao.h"
#import "SmallCaregoryDao.h"
#import "BigCategoryBean.h"
#import "SmallCaregoryBean.h"

@interface AddCategoryVC () <UITableViewDataSource,UITableViewDelegate>{
    CategoryType selectType;
    
    NSInteger selectBigItem;
    NSInteger selectSmallItem;
    NSMutableArray *arrayBigCategorys;
    NSMutableArray *arraySmallCategorys;
}
@property (weak, nonatomic) IBOutlet UITableView *bigTableView;
@property (weak, nonatomic) IBOutlet UITableView *smallTable;

@end

@implementation AddCategoryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"商品分类";
    [UITools customNavigationBackButtonForController:self];
    selectBigItem = 0;
    selectSmallItem = 0;
    _bigTableView.rowHeight = 38;
    _smallTable.rowHeight = 38;
    arrayBigCategorys = [NSMutableArray array];
    arraySmallCategorys = [NSMutableArray array];
    
    [self checkBigCategors];
    BigCategoryBean *fristBigBean = arrayBigCategorys[0];
    [self checkSmallCategorsWithBigCategorID:fristBigBean.idKey];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - dataFromDB
- (void)checkBigCategors {
    [arrayBigCategorys removeAllObjects];
   NSArray *array = [[BigCategoryDao shareInstance] selectAll];
    arrayBigCategorys = [NSMutableArray arrayWithArray:array];
    if (arrayBigCategorys.count == 0) {
        BigCategoryBean *bigBean = [BigCategoryBean new];
        bigBean.userId = [UserInfo shareInstance].uid;
        bigBean.name = @"默认分类";
        bigBean.location = 0;
        if ([[BigCategoryDao shareInstance] insertBean:bigBean]) {
            [arrayBigCategorys addObject:bigBean];
        }
    }
}

- (void)checkSmallCategorsWithBigCategorID:(NSString *)bigID {
    [arraySmallCategorys removeAllObjects];
    NSArray *array = [[SmallCaregoryDao shareInstance] selectSmallCaregoryByBigID:bigID];
    arraySmallCategorys = [NSMutableArray arrayWithArray:array];
}
#pragma mark - Actions
- (IBAction)editBigCategory:(id)sender {
    selectType = bigCategory;
    [self performSegueWithIdentifier:@"editCategorySegue" sender:self];
}

- (IBAction)editSmallCategory:(id)sender {
    selectType = smallCategory;
    [self performSegueWithIdentifier:@"editCategorySegue" sender:self];
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    EditCategoryViewController *editCatagoryVC = (EditCategoryViewController *)segue.destinationViewController;
    editCatagoryVC.categoryType = selectType;
    if (selectType == smallCategory) {
        NSString *bigBeanID = [arrayBigCategorys[selectBigItem] valueForKey:@"idKey"];
        editCatagoryVC.bigCategoryBeanId = bigBeanID;
        editCatagoryVC.arrayCategorys = arraySmallCategorys;
        editCatagoryVC.needUpdateBlock = ^(BOOL needUpdate){
            if (needUpdate) {
                [self checkSmallCategorsWithBigCategorID:bigBeanID];
                [self.smallTable reloadData];
            }
        };
    } else {
        editCatagoryVC.arrayCategorys = arrayBigCategorys;
        editCatagoryVC.needUpdateBlock = ^(BOOL needUpdate){
            if (needUpdate) {
                [self checkBigCategors];
                [self.bigTableView reloadData];
            }
        };
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == _bigTableView) {
        return arrayBigCategorys.count;
    } else {
        return arraySmallCategorys.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"defaultCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    SuperBean *bean = nil;
    if (tableView == _bigTableView ) {
        bean = arrayBigCategorys[indexPath.row];
        if (indexPath.row == selectBigItem) {
            cell.selected = YES;
        } else
            cell.selected = NO;
    } else if (tableView == _smallTable){
        bean = arraySmallCategorys[indexPath.row];
        if (indexPath.row == selectSmallItem) {
            cell.selected = YES;
        } else
            cell.selected = NO;
    }
    [cell.textLabel setFont:[UIFont systemFontOfSize:16]];
    cell.textLabel.text = [bean valueForKey:@"name"];
    return cell;
}

#pragma mark - tableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _bigTableView ) {
        selectBigItem = indexPath.row;
    }  else if (tableView == _smallTable){
        selectSmallItem = indexPath.row;
    }
}

@end
