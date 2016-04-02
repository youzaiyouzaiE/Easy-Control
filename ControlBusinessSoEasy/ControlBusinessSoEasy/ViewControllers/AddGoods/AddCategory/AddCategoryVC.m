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
    
    _bigTableView.rowHeight = 38;
    _smallTable.rowHeight = 38;
    
    [self checkBigCategors];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - dataFromDB
- (void)checkBigCategors {
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
    } else {
        BigCategoryBean *fristBigBean = arrayBigCategorys[0];
        [self checkSmallCategorsWithBigCategorID:fristBigBean.idKey];
    }
    
}

- (void)checkSmallCategorsWithBigCategorID:(NSString *)bigID {
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
        editCatagoryVC.bigCategoryBeanId = [arrayBigCategorys[selectBigItem] valueForKey:@"idKey"];
        editCatagoryVC.arrayCategorys = arraySmallCategorys;
    } else {
        editCatagoryVC.arrayCategorys = arrayBigCategorys;
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
        [tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:selectBigItem inSection:0] animated:NO scrollPosition:YES];
    } else if (tableView == _smallTable){
        bean = arraySmallCategorys[indexPath.row];
        [tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:selectSmallItem inSection:0] animated:NO scrollPosition:YES];
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
