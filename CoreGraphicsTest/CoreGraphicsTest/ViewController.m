//
//  ViewController.m
//  CoreGraphicsTest
//
//  Created by jiahui on 16/4/13.
//  Copyright © 2016年 JiaHui. All rights reserved.
//

#import "ViewController.h"
#import "GraphicsView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    GraphicsView *view = [[GraphicsView alloc] initWithFrame:self.view.bounds];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
