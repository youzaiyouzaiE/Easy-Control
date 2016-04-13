//
//  GraphicsView.m
//  CoreGraphicsTest
//
//  Created by jiahui on 16/4/13.
//  Copyright © 2016年 JiaHui. All rights reserved.
//

#import "GraphicsView.h"

@implementation GraphicsView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    [[UIColor redColor] set];
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path addArcWithCenter:CGPointMake(100, 100) radius:50 startAngle:-M_PI endAngle:0 clockwise:YES];
    [path addArcWithCenter:CGPointMake(200, 200) radius:50 startAngle:-M_PI endAngle:M_PI_2 clockwise:YES];
//    [path moveToPoint:CGPointMake(220, 200)];
    [path closePath];
    [path fill];
    
}


@end
