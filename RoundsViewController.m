//
//  RoundsViewController.m
//  The Pomodoro
//
//  Created by Kevin Lambert on 1/20/15.
//  Copyright (c) 2015 DevMountain. All rights reserved.
//

#import "RoundsViewController.h"
#import "TimerViewController.h"

static NSString * const CurrentRoundKey = @"CurrentRound";

@interface RoundsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSInteger currentRound; //when do you use "assign" instead of strong?

@end

@implementation RoundsViewController
//Don't know what this next method is doing
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.currentRound = [[NSUserDefaults standardUserDefaults] integerForKey:CurrentRoundKey];
        
        [self registerForNotifications];
    }
    return self;
}

- (void) registerForNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endRound:) name:RoundCompleteNotificationName object:nil];
}

-(void)unregisterForNotification {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:RoundCompleteNotificationName object:nil];
}

-(void)dealloc {
    [self unregisterForNotification];
}

-(void)setCurrentRound:(NSInteger)currentRound {
    _currentRound = currentRound; //What is _currentRound?
    
    [[NSUserDefaults standardUserDefaults] setValue:@(currentRound) forKeyPath:CurrentRoundKey]; //Why the @()?
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Rounds";
    
    [self postMinutes];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.tableView];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    [self selectCurrentRound];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self times] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.textLabel.text = [NSString stringWithFormat:@"Round %d - %@ min", indexPath.row + 1, [[[self times] objectAtIndex:indexPath.row] stringValue]];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.currentRound = indexPath.row;
    [self postMinutes];
}

-(void) postMinutes {
    [[NSNotificationCenter defaultCenter] postNotificationName:NewRoundTimeNotificationName object:nil userInfo:@{UserInfoMinutesKey: [self times][self.currentRound]}];
}

-(NSArray *) times {
    return @[@25, @5, @25, @5, @25, @5, @25, @15];
}

- (void)endRound:(NSNotification *)notification {
    
    self.currentRound++;
    if (self.currentRound == [[self times] count]) {
        self.currentRound = 0;
    }
    
    [self selectCurrentRound];
    
    [self postMinutes];
    
}

- (void)selectCurrentRound {
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:self.currentRound inSection:0];
    [self.tableView selectRowAtIndexPath:indexPath
                                animated:NO
                          scrollPosition:UITableViewScrollPositionTop];
    
} //Need Help with this method

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end












