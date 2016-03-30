//
//  AddOrEditViewController.m
//  ControlBusinessSoEasy
//
//  Created by jiahui on 16/3/27.
//  Copyright © 2016年 JiaHui. All rights reserved.
//

#import "AddOrEditViewController.h"

@interface AddOrEditViewController ()<UITextFieldDelegate>{
    
    __weak IBOutlet UITextField *contentTextField;
    __weak IBOutlet UIButton *completeButton;
}

@end

@implementation AddOrEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = _navTitle;
    [UITools customNavigationBackButtonForController:self];
    if (_textFiledStr) {
        contentTextField.text = _textFiledStr;
    } else
        contentTextField.placeholder = _navTitle;
    
    completeButton.layer.borderColor = [[UIColor grayColor] colorWithAlphaComponent:0.5].CGColor;
    completeButton.layer.borderWidth = 2;
    completeButton.layer.cornerRadius = 5;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action
- (IBAction)completeAction:(id)sender {
    if (contentTextField.text == nil || contentTextField.text.length == 0 || [contentTextField.text isEqualToString:@""]) {
        [[UITools shareInstance] showMessageToView:self.view message:@"分类名称不能为空"];
        return ;
    }
    self.categoryName(contentTextField.text);
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)tapGestureRecognizer:(id)sender {
    [self.view endEditing:YES];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
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
