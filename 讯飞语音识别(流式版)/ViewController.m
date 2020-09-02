//
//  ViewController.m
//  讯飞语音识别(流式版)
//
//  Created by 谢立新 on 2020/9/2.
//  Copyright © 2020 xiaoxie. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "IflyMSCObject.h"
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *textLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (IBAction)buttonClick:(UIButton *)sender {
    if (sender.tag == 10) {//点击开始听写
        if ([self examineJurisdiction]) {
            __weak typeof(self) weakSelf = self;
            [[IflyMSCObject shareIflyMS] startMSC:^(NSString * _Nonnull MSCText) {
                weakSelf.textLabel.text = MSCText;
            }];
        }else{
            NSLog(@"请先开启麦克风权限");
        }
    }else{//点击结束并返回结果
        [[IflyMSCObject shareIflyMS] stopRecord];
    }
}

//检查权限
-(BOOL)examineJurisdiction{
    AVAuthorizationStatus sta = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
        switch (sta) {
            case AVAuthorizationStatusAuthorized:{
                //有权限
                NSLog(@"有权限");
                return YES;
                
            }
                break;
            case AVAuthorizationStatusNotDetermined:{
                [self alert];
            }
            case AVAuthorizationStatusRestricted:
            case AVAuthorizationStatusDenied:{
                return NO;
            }
                break;
            default:
                break;
        }
}

-(void)alert{
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
        if (granted) {
        }else{
        }

    }];
}

@end
