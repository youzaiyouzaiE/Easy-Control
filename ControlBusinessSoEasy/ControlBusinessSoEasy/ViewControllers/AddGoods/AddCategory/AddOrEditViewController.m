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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action
- (IBAction)completeAction:(id)sender {
    self.categoryName(contentTextField.text);
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
