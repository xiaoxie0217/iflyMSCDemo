//
//  IflyMSCObject.m
//  OKYA
//
//  Created by 小谢 on 2020/8/5.
//  Copyright © 2020 xiaoxie. All rights reserved.
//

#import "IflyMSCObject.h"
@implementation IflyMSCObject

+(IflyMSCObject *)shareIflyMS{
    static IflyMSCObject *iflyMSC;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        iflyMSC = [[IflyMSCObject alloc] init];
    });
    return iflyMSC;
}

-(id)init{
    if (self == [super init]) {
        
        if (self.recognizer == nil) {
            self.recognizer = [IFlySpeechRecognizer sharedInstance];
        }
        //清空上一段听到的内容
        [self.recognizer setParameter:@"" forKey:[IFlySpeechConstant PARAMS]];
        //设置业务类型
        [self.recognizer setParameter:@"iat" forKey:[IFlySpeechConstant IFLY_DOMAIN]];
        //设置语言
        [self.recognizer setParameter:@"zh_cn" forKey:[IFlySpeechConstant LANGUAGE_CHINESE]];
        //设置普通话
        [self.recognizer setParameter:@"mandarin" forKey:[IFlySpeechConstant ACCENT]];
        //超出时间  单位ms  最长 14s
        [self.recognizer setParameter:@"14000" forKey:[IFlySpeechConstant SPEECH_TIMEOUT]];
        //前断点超时(即开始检测以后多少秒没检测到说话,直接结束当前的识别)
        [self.recognizer setParameter:@"14000" forKey:[IFlySpeechConstant VAD_BOS]];
        //后断点超时(即说话以后多少秒没检测到再次说话,直接结束当前的识别)
        [self.recognizer setParameter:@"14000" forKey:[IFlySpeechConstant  VAD_EOS]];
        //音频采样率 8K/16K
        [self.recognizer setParameter:@"16000" forKey:[IFlySpeechConstant SAMPLE_RATE]];
        //标点
        [self.recognizer setParameter:@"1" forKey:[IFlySpeechConstant ASR_PTT]];
        //音频源
        [self.recognizer setParameter:@"1" forKey:@"audio_source"];
        //返回值类型
        [self.recognizer setParameter:@"json" forKey:[IFlySpeechConstant RESULT_TYPE]];
        
        [self.recognizer setDelegate:self];
        
    }
    return self;
}
-(void)startMSC:(MSCSuccess)success{
    
    self.MSCStr = @"";
    self.success = success;
    BOOL res = [self.recognizer startListening];
    if (res) {
        NSLog(@"准备就绪开始听写");
    }else{
        NSLog(@"准备过程出现错误");
    }
}
//停止录音识别此次回话
-(void)stopRecord{
    [self.recognizer stopListening];
}
//取消录音,并舍弃此次回话
-(void)cancelRecord{
    [self.recognizer cancel];
}
//错误回调
- (void)onError:(IFlySpeechError *)errorCode {
    
}
//音量回调
-(void)onVolumeChanged:(int)volume{
    
}
-(void)onBeginOfSpeech{
    NSLog(@"准备完成,开始说话");
}
-(void)onEndOfSpeech{
    NSLog(@"说话结束");
}


//结果回调
-(void)onResults:(NSArray *)results isLast:(BOOL)isLast{
    NSMutableString *resultString = [[NSMutableString alloc] init];
    NSDictionary *Dic = results[0];
    
    for (NSString *key in Dic) {
        [resultString appendFormat:@"%@",key];
    }
    NSString *result = [ISRDataHelper stringFromJson:resultString];
    self.MSCStr = [NSString stringWithFormat:@"%@%@",self.MSCStr,result];
    self.success(self.MSCStr?:@"");
    [self cancelRecord];
}
@end
