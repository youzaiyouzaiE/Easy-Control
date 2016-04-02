//
//  AddOrEditViewController.m
//  ControlBusinessSoEasy
//
//  Created by jiahui on 16/3/27.
//  Copyright © 2016年 JiaHui. All rights reserved.
//

#import "AddOrEditViewController.h"
#import "SuperBean.h"
//#import "SmallCaregoryBean.h"
@interface AddOrEditViewController ()<UITextFieldDelegate,UIGestureRecognizerDelegate,UINavigationControllerDelegate>{
    
    __weak IBOutlet UITextField *contentTextField;
    __weak IBOutlet UIButton *completeButton;
    id <UINavigationControllerDelegate> navigationDelegate;
}

@end

@implementation AddOrEditViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.navigationController.delegate = self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = _navTitle;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(backItemAction:)];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    if (_textFiledStr) {
        contentTextField.text = _textFiledStr;
    } else
        contentTextField.placeholder = _navTitle;
    
    completeButton.layer.borderColor = [[UIColor grayColor] colorWithAlphaComponent:0.5].CGColor;
    completeButton.layer.borderWidth = 2;
    completeButton.layer.cornerRadius = 5;
    
//    navigationDelegate = self.navigationController.delegate;
//    self.navigationController.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action
-(void)backItemAction:(id)sender {
    self.navigationController.delegate = navigationDelegate;
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)completeAction:(id)sender {
    if (contentTextField.text == nil || contentTextField.text.length == 0 || [contentTextField.text isEqualToString:@""]) {
        [[UITools shareInstance] showMessageToView:self.view message:@"分类名称不能为空"];
        return ;
    }
    for (SuperBean *bean in _arrayContents ) {
        NSString *beanName = [bean valueForKey:@"name"];
        if ([beanName isEqualToString:contentTextField.text]) {
            [[UITools shareInstance] showMessageToView:self.view message:@"该分类已经添加"];
            [contentTextField becomeFirstResponder];
            return ;
        }
    }
    self.categoryName(contentTextField.text);
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)tapGestureRecognizer:(id)sender {
    [self.view endEditing:YES];
}

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    id<UIViewControllerTransitionCoordinator> tc = navigationController.topViewController.transitionCoordinator;
    [tc notifyWhenInteractionEndsUsingBlock:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        NSLog(@"添加 Is cancelled: %i", [context isCancelled]);
        if (![context isCancelled]) {
            self.navigationController.delegate = navigationDelegate;
        }
    }];
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
