//
//  CAGCDTimer.m
//  CAGCDTimer
//
//  Created by umer on 2020/3/24.
//  Copyright © 2020 umer. All rights reserved.
//

#import "CAGCDTimer.h"

@interface CAGCDTimer ()

@property (nonatomic, assign) NSTimeInterval interval;
@property (nonatomic, assign) BOOL repeat;
@property (nonatomic, copy) CACGDTimerBlock completion;

@property (nonatomic, strong)dispatch_source_t timer;
@property (nonatomic, assign) BOOL isRunning;

@end

@implementation CAGCDTimer

+ (CAGCDTimer *)timerWithInterval:(NSTimeInterval)interval repeat:(BOOL)repeat completion:(CACGDTimerBlock)completion {
    CAGCDTimer *timer = [[CAGCDTimer alloc]initWithINterval:interval repeat:repeat completion:completion];
    return timer;
}

- (instancetype)initWithINterval:(NSTimeInterval)interval repeat:(BOOL)repeat completion:(CACGDTimerBlock)completion {
    if (self = [super init]) {
        self.interval = interval;
        self.repeat = repeat;
        self.completion = completion;
        self.isRunning = NO;
        
        self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(0, 0));
        dispatch_source_set_timer(self.timer, DISPATCH_TIME_NOW, self.interval *NSEC_PER_SEC, 0 *NSEC_PER_SEC);
        
        __weak typeof(self) weakSelf = self;
        dispatch_source_set_event_handler(self.timer, ^{
            [weakSelf excute];
        });
    }
    return self;
}

- (void)excute {
    if (self.completion) {
        self.completion();
    }
}

- (void)startTimer {
    if (self.timer && !self.isRunning) {
        self.isRunning = YES;
        dispatch_resume(self.timer);
    }
}

- (void)invalidateTimer {
    if (_timer) {
        dispatch_source_cancel(_timer);
        self.isRunning = NO;
        _timer = nil;
    }
}

- (void)pauseTimer {
    if (self.timer && self.isRunning) {
        dispatch_suspend(self.timer);
    }
}

- (void)resumeTimer {
    if (self.timer && !self.isRunning) {
        dispatch_resume(self.timer);
    }
}

@end
