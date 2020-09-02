//
//  IflyMSCObject.h
//  OKYA
//
//  Created by 小谢 on 2020/8/5.
//  Copyright © 2020 xiaoxie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <iflyMSC/iflyMSC.h>
#import "ISRDataHelper.h"
NS_ASSUME_NONNULL_BEGIN
//MSCText:识别到的文字内容
typedef void(^MSCSuccess)(NSString *MSCText);

@interface IflyMSCObject : NSObject<IFlySpeechRecognizerDelegate>

@property (nonatomic,copy) MSCSuccess success;

@property (nonatomic,strong) IFlySpeechRecognizer *recognizer;
//听到的语音转换成的字符串
@property (nonatomic,copy) NSString *MSCStr;
//单例
+(IflyMSCObject *)shareIflyMS;
/**
 开始听写并返回转换得到的文字
 */
-(void)startMSC:(MSCSuccess)success;
/**
 停止录音,取消此次会话
 */
-(void)cancelRecord;
/**
 停止录音,识别此次会话
 */
-(void)stopRecord;
@end

NS_ASSUME_NONNULL_END
