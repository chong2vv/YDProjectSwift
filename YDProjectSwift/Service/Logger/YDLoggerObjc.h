//
//  YDLoggerObjc.h
//  YDProjectSwift
//
//  Created by 王远东 on 2024/3/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YDLoggerObjc : NSObject

+ (void)startOpen;
+ (void)YDLogError:(NSString *)frmt;
+ (void)YDLogInfo:(NSString *)frmt;
+ (void)YDLogDetail:(NSString *)frmt;
+ (void)YDLogMonitorDetail:(NSString *)frmt;
+ (void)YDLogDebug:(NSString *)frmt;
+ (void)YDLogVerbose:(NSString *)frmt;

@end

NS_ASSUME_NONNULL_END
