//
//  ScanBarViewController.m
//  ShantouMuseum
//
//  Created by jiahui on 15/5/31.
//  Copyright (c) 2015年 Home. All rights reserved.
//

#import "ScanBarViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface ScanBarViewController () <AVCaptureMetadataOutputObjectsDelegate> {
    AVCaptureSession *_session;
    AVCaptureDevice *_device;
    AVCaptureDeviceInput *_input;
    AVCaptureMetadataOutput *_output;
    AVCaptureVideoPreviewLayer *_prevLayer;
    
    UILabel *_label;
    NSTimer *timer;
    BOOL isStopMove;
    UIImageView *line;
    NSInteger num;
    CALayer *layer;
}

@end

@implementation ScanBarViewController


#define LAYER_W     200
#define LAYER_H     200
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"二维码";
    
    _label = [[UILabel alloc] init];
    _label.frame = CGRectMake(0, self.view.bounds.size.height - 40, self.view.bounds.size.width, 40);
    _label.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    _label.backgroundColor = [UIColor colorWithWhite:0.15 alpha:0.65];
    _label.textColor = [UIColor whiteColor];
    _label.textAlignment = NSTextAlignmentCenter;
    _label.text = @" ";
    [self.view addSubview:_label];
    

    _session = [[AVCaptureSession alloc] init];
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *error = nil;
    
    _input = [AVCaptureDeviceInput deviceInputWithDevice:_device error:&error];
    if (_input) {
        [_session addInput:_input];
    } else {
        NSLog(@"Error: %@", error);
    }
    _output = [[AVCaptureMetadataOutput alloc] init];
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    [_session addOutput:_output];
    _output.metadataObjectTypes = [_output availableMetadataObjectTypes];
    
    _prevLayer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
    _prevLayer.frame = self.view.bounds;
    _prevLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.view.layer addSublayer:_prevLayer];
    [_session startRunning];
    [self.view bringSubviewToFront:_label];
    
    layer = [CALayer layer];
    layer.backgroundColor = [UIColor clearColor].CGColor;
    layer.frame = CGRectMake((self.view.frame.size.width - LAYER_W)/2 , 100, LAYER_W, LAYER_H);
    layer.borderColor = [UIColor whiteColor].CGColor;
    layer.borderWidth = 1;
    [self.view.layer addSublayer:layer];
    
    CGSize size = [UIScreen mainScreen].bounds.size;
    [_output setRectOfInterest:CGRectMake(100/size.height, (self.view.frame.size.width - LAYER_W)/2/size.width, LAYER_W/size.height, LAYER_W/size.width)];
    
    UILabel *textLabl = [[UILabel alloc] initWithFrame:CGRectMake(layer.frame.origin.x, layer.frame.origin.y + LAYER_H + 5, layer.frame.size.width, 80)];
    textLabl.textColor = [UIColor whiteColor];
    textLabl.backgroundColor = [UIColor clearColor];
    textLabl.text = @"将二维码放入框内，即可扫描";
    textLabl.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:textLabl];
    num = 2;
    line = [[UIImageView alloc] init];
    line.frame = CGRectMake(layer.frame.origin.x, layer.frame.origin.y + 4, 200, 2);
    line.image = [UIImage imageNamed:@"line.png"];
    [self.view addSubview:line];
    self.view.backgroundColor = [UIColor colorWithWhite:0.15 alpha:0.65];
    timer = [NSTimer scheduledTimerWithTimeInterval:.2 target:self selector:@selector(animation) userInfo:nil repeats:YES];
}

-(void)animation
{
    if (!isStopMove) {
        num ++;
        line.frame = CGRectMake(line.frame.origin.x, line.frame.origin.y + 2*num, 200, 2);
        if (line.frame.origin.y >= layer.frame.origin.y + LAYER_H - 4) {
            num = 0;
            line.frame = CGRectMake(layer.frame.origin.x, layer.frame.origin.y + 4, 200, 2);
        }
    }
}

#pragma mark AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
//    CGRect highlightViewRect = CGRectZero;
    AVMetadataMachineReadableCodeObject *barCodeObject;
    NSString *detectionString = nil;
    NSArray *barCodeTypes = @[AVMetadataObjectTypeUPCECode, AVMetadataObjectTypeCode39Code, AVMetadataObjectTypeCode39Mod43Code,
                              AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode93Code, AVMetadataObjectTypeCode128Code,
                              AVMetadataObjectTypePDF417Code, AVMetadataObjectTypeQRCode, AVMetadataObjectTypeAztecCode];
    
    for (AVMetadataObject *metadata in metadataObjects) {
        for (NSString *type in barCodeTypes) {
            if ([metadata.type isEqualToString:type])
            {
                barCodeObject = (AVMetadataMachineReadableCodeObject *)[_prevLayer transformedMetadataObjectForMetadataObject:(AVMetadataMachineReadableCodeObject *)metadata];
//                highlightViewRect = barCodeObject.bounds;
                detectionString = [(AVMetadataMachineReadableCodeObject *)metadata stringValue];
                break;
            }
        }
        
        if (detectionString != nil)
        {
            _label.text = detectionString;
//            ScanWebView *webVC = [[ScanWebView alloc] init];
//            webVC.urlString = detectionString;
            NSLog(@"扫到的内容是：%@",detectionString);
//            self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
//            self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
            
//            [self.navigationController pushViewController:webVC animated:YES];
            [_session stopRunning];
            isStopMove = YES;
            break;
        }
        else
            _label.text = @"(none)";
    }
//    _highlightView.frame = highlightViewRect;
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
