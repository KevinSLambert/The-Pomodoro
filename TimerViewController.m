//
//  TimerViewController.m
//  The Pomodoro
//
//  Created by Kevin Lambert on 1/20/15.
//  Copyright (c) 2015 DevMountain. All rights reserved.
//

#import "TimerViewController.h"
#import "RoundsViewController.h"

@interface TimerViewController ()

@property (nonatomic, assign) BOOL active;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *button;

@property (nonatomic, assign) NSInteger seconds;
@property (nonatomic, assign) NSInteger minutes;


- (IBAction)startButton:(id)sender;

@end

@implementation TimerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self registerForNotifications];
    }
    return self;
}//Don't know what this is

-(void)registerForNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newRound:) name:NewRoundTimeNotificationName object:nil];
}

-(void)unregisterForNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NewRoundTimeNotificationName object:nil];
}

-(void)dealloc {
    [self unregisterForNotifications];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Focus";
    
    [self updateLabel];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)startButton:(id)sender {
    self.button.enabled = NO;
    [self.button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    self.active = YES;
    [self performSelector:@selector(decreaseSecond) withObject:nil afterDelay:1.0];
}

-(void)decreaseSecond {
    if (self.seconds > 0) {
        self.seconds --;
    }
    
    if (self.minutes >0) {
        if (self.seconds == 0) {
            self.seconds = 59;
            self.minutes --;
        }
    } else {
        if (self.seconds == 0) {
            self.button.enabled = YES;
            [self.button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            
            self.active = NO;
            
            [[NSNotificationCenter defaultCenter] postNotificationName:RoundCompleteNotificationName object:nil userInfo:nil];
        }
    }
    
    [self updateLabel];
    
    if (self.active) {
        [self performSelector:@selector(decreaseSecond) withObject:nil afterDelay:1.0];
    }
}

- (void)updateLabel {
    
    if (self.seconds < 10) {
        self.timeLabel.text = [NSString stringWithFormat:@"%d:0%d", self.minutes, self.seconds];
    } else {
        self.timeLabel.text = [NSString stringWithFormat:@"%d:%d", self.minutes, self.seconds];
    }
    
}

- (void)newRound:(NSNotification *)notification {
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(decreaseSecond) object:nil];
    
    self.minutes = [notification.userInfo[UserInfoMinutesKey] integerValue];
    self.seconds = 0;
    
    self.button.enabled = YES;
    [self.button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [self updateLabel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
