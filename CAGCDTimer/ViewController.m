//
//  ViewController.m
//  CAGCDTimer
//
//  Created by umer on 2020/3/24.
//  Copyright © 2020 umer. All rights reserved.
//

#import "ViewController.h"
#import "CAGCDTimer.h"

@interface ViewController ()

@property (nonatomic,strong) CAGCDTimer *timer;
@property (nonatomic,strong) dispatch_source_t source;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    dispatch_queue_t progressQueue = dispatch_queue_create("com.cy.gcdtimer", DISPATCH_QUEUE_CONCURRENT);
    self.source = dispatch_source_create(DISPATCH_SOURCE_TYPE_DATA_ADD, 0, 0, progressQueue);
    
    __weak typeof(self) weakSelf = self;
    dispatch_source_set_event_handler(self.source, ^{
        NSUInteger progress = dispatch_source_get_data(self.source);
        if (progress >= 100) {
            progress = 100;
            dispatch_source_cancel(weakSelf.source);
            weakSelf.source = nil;
        }
        NSLog(@"percent: %@",[NSString stringWithFormat:@"%ld",progress]);
    });
    
    dispatch_resume(self.source);
}

- (void)createButton {
    UIButton *clickButton = [UIButton buttonWithType:UIButtonTypeCustom];
    clickButton.frame = CGRectMake(self.view.frame.size.width/2-40, self.view.frame.size.height/2-20, 80, 40);
    [clickButton setTitle:@"Click" forState:UIControlStateNormal];
    [clickButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [clickButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:clickButton];
}

- (void)buttonClicked:(UIButton *)button {
    [self.timer startTimer];
}

- (CAGCDTimer *)timer {
    if (!_timer) {
        __weak typeof(self) weakSelf = self;
        _timer = [CAGCDTimer timerWithInterval:1 repeat:YES completion:^{
            static NSUInteger _progress = 0;
            if (_progress > 100) {
                _progress = 100;
                [weakSelf.timer invalidateTimer];
                weakSelf.timer = nil;
            }
            if (weakSelf.source) {
                dispatch_source_merge_data(weakSelf.source, _progress);
            }
        }];
        
    }
    return _timer;
}


@end
