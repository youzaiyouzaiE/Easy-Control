//
//  EditCategoryViewController.m
//  ControlBusinessSoEasy
//
//  Created by jiahui on 16/3/20.
//  Copyright © 2016年 JiaHui. All rights reserved.
//

#import "EditCategoryViewController.h"
#import "BigCategoryBean.h"
#import "SmallCaregoryBean.h"
#import "SmallCaregoryDao.h"
#import "BigCategoryDao.h"
#import "AddOrEditViewController.h"

@interface EditCategoryViewController ()<UITableViewDataSource,UITableViewDelegate> {
    BOOL isEditType;
    BOOL isAddCategory;
    
    NSString *categoryName;
}

@property (weak, nonatomic) IBOutlet UITableView *tableVeiw;

@end

@implementation EditCategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [UITools customNavigationBackButtonForController:self];
    if (self.categoryType == smallCategory) {
        self.navigationItem.title = @"小分类";
    } else {
        self.navigationItem.title = @"大分类";
    }
    UIButton *editButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [editButton addTarget:self action:@selector(editButtionItemAction:) forControlEvents:UIControlEventTouchUpInside];
    [editButton setTitle:@"编辑" forState:UIControlStateNormal];
    [editButton setTitle:@"完成" forState:UIControlStateSelected];
    editButton.frame = CGRectMake(0, 0, 40, 40);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:editButton];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - action
- (void)editButtionItemAction:(UIButton *)button {
    button.selected = !button.selected;
    isEditType = button.selected;
    
    
}

#pragma mark - UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < _arrayCategorys.count) {
        return 40;
    } else {
        return 70;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _arrayCategorys.count +1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"defaultCell";
    static NSString *addIdentifier = @"addCell";
    if (indexPath.row < _arrayCategorys.count) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
        }
        SuperBean *bean = _arrayCategorys[indexPath.row];
        cell.textLabel.text = [bean valueForKey:@"name"];
        return cell;
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:addIdentifier forIndexPath:indexPath];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
        }
        UILabel *titleLable = (UILabel *)[cell viewWithTag:1];
        self.categoryType == smallCategory ? (titleLable.text = @"添加小分类" ): (titleLable.text = @"添加大分类" );
        return cell;
    }
}

#pragma mark - tableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < _arrayCategorys.count) {
        isAddCategory = NO;
        if (isEditType) {
            
        } else {///Choose
            
            
        }
    } else {
        isAddCategory = YES;
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        [self performSegueWithIdentifier:@"AddOrEditSegue" sender:self];
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    AddOrEditViewController *addOrEidtVC = ( AddOrEditViewController *)[segue destinationViewController];
    if (isAddCategory && self.categoryType == smallCategory) {
        addOrEidtVC.navTitle = @"添加小分类";
    } else if (isAddCategory && self.categoryType == bigCategory) {
        addOrEidtVC.navTitle = @"添加大分类";
    } else if (!isAddCategory && self.categoryType == bigCategory) {
        addOrEidtVC.navTitle = @"修改大分类";
    } else if (!isAddCategory && self.categoryType == smallCategory) {
        addOrEidtVC.navTitle = @"修改小分类";
    }
//    __weak typeof(self) weakSelf = self;
    addOrEidtVC.categoryName = ^(NSString *name){
        categoryName = name;
        if (self.categoryType == smallCategory) {
            SmallCaregoryBean *bean = [SmallCaregoryBean new];
            bean.bigCaregoryID = _bigCategoryBeanId;
            bean.name = name;
            bean.location = _arrayCategorys.count;
            [[SmallCaregoryDao shareInstance] insertBean:bean];
            [_arrayCategorys addObject:bean];
        } else {
            BigCategoryBean *bean = [BigCategoryBean new];
            bean.name = name;
            bean.location = _arrayCategorys.count;
            [[SmallCaregoryDao shareInstance] insertBean:bean];
            [_arrayCategorys addObject:bean];
        }
        [self.tableVeiw reloadData];
    };
}





@end
