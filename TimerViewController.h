//
//  TimerViewController.h
//  The Pomodoro
//
//  Created by Kevin Lambert on 1/20/15.
//  Copyright (c) 2015 DevMountain. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString * const RoundCompleteNotificationName = @"RoundCompleteNotification";

@interface TimerViewController : UIViewController

-(void)roundEndedNotification;

@end
