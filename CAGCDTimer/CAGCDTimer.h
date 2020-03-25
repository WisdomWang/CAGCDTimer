//
//  CAGCDTimer.h
//  CAGCDTimer
//
//  Created by umer on 2020/3/24.
//  Copyright © 2020 umer. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^CACGDTimerBlock)(void);

@interface CAGCDTimer : NSObject

+ (CAGCDTimer *)timerWithInterval:(NSTimeInterval)interval repeat:(BOOL)repeat completion:(CACGDTimerBlock)completion;

- (void)startTimer;

- (void)invalidateTimer;

- (void)pauseTimer;

- (void)resumeTimer;

@end

NS_ASSUME_NONNULL_END
