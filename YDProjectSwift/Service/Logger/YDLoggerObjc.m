//
//  YDLoggerObjc.m
//  YDProjectSwift
//
//  Created by 王远东 on 2024/3/26.
//

#import "YDLoggerObjc.h"
#import <YDLogger/YDLogger.h>
@implementation YDLoggerObjc

+ (void)startOpen {
    [[YDLogService shared] startLogNeedHook:NO];
}

+ (void)YDLogDebug:(NSString *)frmt {
    YDLogDebug(@"%@",frmt);
}

+ (void)YDLogDetail:(NSString *)frmt {
    YDLogDetail(@"%@",frmt);
}

+ (void)YDLogError:(NSString *)frmt {
    YDLogError(@"%@",frmt);
}

+ (void)YDLogInfo:( NSString *)frmt {
    YDLogInfo(@"%@",frmt);
}

+ (void)YDLogMonitorDetail:(NSString *)frmt {
    YDLogMonitorDetail(@"%@",frmt);
}

+ (void)YDLogVerbose:(NSString *)frmt {
    YDLogVerbose(@"%@",frmt);
}

@end
