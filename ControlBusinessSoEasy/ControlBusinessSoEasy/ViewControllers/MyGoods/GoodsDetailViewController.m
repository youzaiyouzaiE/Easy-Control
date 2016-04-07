//
//  GoodsDetailViewController.m
//  ControlBusinessSoEasy
//
//  Created by jiahui on 16/4/7.
//  Copyright © 2016年 JiaHui. All rights reserved.
//

#import "GoodsDetailViewController.h"

@interface GoodsDetailViewController ()

@end

@implementation GoodsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[UITools shareInstance] customNavigationLeftBarButtonForController:self];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)testAction:(id)sender {
    [self performSegueWithIdentifier:@"pushToNewGoodsVC" sender:self];
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
