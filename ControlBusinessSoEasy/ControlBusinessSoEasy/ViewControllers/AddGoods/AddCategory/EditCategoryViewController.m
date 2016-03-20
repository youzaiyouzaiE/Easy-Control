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

@interface EditCategoryViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate> {
    
    UIAlertView *alertView;
    UITextField *inputTextField;
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
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < _arrayCategorys.count) {
        return 40;
    } else {
        return 64;
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
        return cell;
    }
}

#pragma mark - tableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < _arrayCategorys.count) {
    
    } else {
        if (!alertView) {
            alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                       message:@"请输入类别名称"
                                                      delegate:self
                                             cancelButtonTitle:@"取消"
                                             otherButtonTitles:@"确定", nil];
            
            [alertView setAlertViewStyle:UIAlertViewStylePlainTextInput];
//            [alertView textFieldAtIndex:0].secureTextEntry = YES;
            inputTextField = [alertView textFieldAtIndex:0];
        }
        [alertView show];
    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
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
