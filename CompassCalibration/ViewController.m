//
//  ViewController.m
//  CompassCalibration
//
//  Created by qiyun on 16/5/10.
//  Copyright © 2016年 ProDrone. All rights reserved.
//

#import "ViewController.h"
#import "YNCompassCalibration.h"

@interface ViewController ()

@property (nonatomic, retain) NSTimer *connectionTimer;
@property (nonatomic, strong) PDLReminderTableView  *tableView;                 /*  toast提示         */
@property (nonatomic, strong) PDLReminderView *reminderView;

@property (nonatomic, strong) YNCompassCalibration *compassView;

@end

@implementation ViewController

#define KCurrentView_Height_(UIView) (UIView.bounds.size.height)
#define KCurrentView_width_(UIView) (UIView.bounds.size.width)
#define Iphone  ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    //[self test];

    [self.view addSubview:self.compassView];
}

- (YNCompassCalibration *)compassView{
    
    if (!_compassView) {
        
        _compassView = [[YNCompassCalibration alloc] initWithFrame:self.view.bounds];
        _compassView.backgroundColor = [UIColor lightGrayColor];
        __weak typeof(_compassView) compass = _compassView;
        
        /*校磁成功*/
        _compassView.calibration = ^(BOOL success){
          
            if (success)   [compass removeFromSuperview];
        };
    }
    return _compassView;
}

- (void)test{
    
    [self.view addSubview:self.reminderView];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(20 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self.connectionTimer invalidate];
    });
    
    self.connectionTimer = [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop]addTimer:self.connectionTimer forMode:NSDefaultRunLoopMode];
}

- (PDLReminderView *)reminderView{
    
    if (!_reminderView) {
        
        _reminderView = [[PDLReminderView alloc] initWithFrame:CGRectMake(KCurrentView_width_(self.view)*3/8, (Iphone?44:66) + 50, KCurrentView_width_(self.view)/4, 0)];
    }
    return _reminderView;
}

- (PDLReminderTableView *)tableView{
    
    if (!_tableView) {
        
        _tableView = [[PDLReminderTableView alloc] initWithFrame:CGRectMake(KCurrentView_width_(self.view)*4, (Iphone?44:66) + 50, KCurrentView_width_(self.view)/2, 0)];
    }
    return _tableView;
}


-(void)timerFired:(NSTimer *)timer{
    
    NSLog(@"%@",[[NSDate date] description]);
    
    //int second = [[NSCalendar currentCalendar] component:kCFCalendarUnitSecond fromDate:[NSDate date]];
    [self.reminderView showMessage:[[[NSDate date] description] substringFromIndex:11]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

#define KPDLTitleHeightAdding 20
#define KPDL_label_height_less      (Iphone?30:(30 + KPDLTitleHeightAdding))


@implementation PDLReminderTableView{
    
    NSMutableArray *messages;
    NSTimer  *_timer;
    
    NSDate  *startDate, *endDate;
}

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        messages = [[NSMutableArray alloc] init];
        
        self.delegate           = self;
        self.dataSource         = self;
        self.tableFooterView    = [UIView new];
        self.backgroundColor    = [UIColor blackColor];
        self.layer.cornerRadius = 4;
        self.clipsToBounds = YES;
    }
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return messages.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return KPDL_label_height_less;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (!cell) {
        
        cell.detailTextLabel.text = @"";
    }
    
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:cellId];
    cell.detailTextLabel.text = messages[MIN(indexPath.row, messages.count-1)];
    cell.detailTextLabel.textAlignment = NSTextAlignmentCenter;
    cell.detailTextLabel.numberOfLines = 0;
    //cell.textLabel.textColor = [UIColor whiteColor];
    cell.backgroundColor = [UIColor lightGrayColor];
    
    return cell;
}

- (void)deleteIndexPath:(NSTimer *)timer{
    
    if (messages.count >= 1){
        
        endDate = [NSDate date];
        [messages removeObjectAtIndex:0];
        
        CGRect rect = self.frame;
        rect.size.height = messages.count * KPDL_label_height_less;
        
        [UIView animateWithDuration:0.2 animations:^{
            
            self.frame = rect;
            
        } completion:^(BOOL finished) {
            
            [self tableViewEdit:YES];
        }];
    }
}

- (void)showMessage:(NSString *)msg/* complete:(void (^) (BOOL finished))completed */{
    
    if ([messages containsObject:msg] || ![msg length] || !self) return;
    
    [messages addObject:msg];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:(messages.count) * 3 target:self selector:@selector(deleteIndexPath:) userInfo:nil repeats:YES];
    
    CGRect rect = self.frame;
    rect.size.height = (messages.count) * KPDL_label_height_less;
    self.frame = rect;
    
    [self tableViewEdit:NO];
}

- (void)tableViewEdit:(BOOL)ifDelete{
    
    if (ifDelete) {
        
        [self deleteRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:0 inSection:0],nil]
                    withRowAnimation:UITableViewRowAnimationBottom];
        
    }else{
        
        NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:MAX(0,messages.count-1) inSection:0];
        [self beginUpdates];
        [self insertRowsAtIndexPaths:[NSArray arrayWithObjects:newIndexPath, nil] withRowAnimation:UITableViewRowAnimationTop];
        [self endUpdates];
    }
}

- (void)dealloc{
    
    [_timer invalidate];
    _timer = nil;
}


@end



@implementation PDLReminderView{
    
    NSMutableArray  *messages, *views;
    NSTimer *_timer;
}

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        messages = [[NSMutableArray alloc] init];
        views = [NSMutableArray array];
        
        self.backgroundColor    = [UIColor blackColor];
        self.layer.cornerRadius = 4;
        self.clipsToBounds = YES;
        
        _timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(removeReminderLastCell) userInfo:nil repeats:YES];
    }
    return self;
}

- (void)showMessage:(NSString *)msg{
    
    if (msg && msg.length) {
        
        [messages addObject:msg];
        
        [self addSubview:[self addReminderImageViewCell:MAX(0, messages.count - 1)]];
    }
}

- (UIView *)addReminderImageViewCell:(NSInteger)index{
    
    CGRect rect = self.frame;
    rect.size.height += 40;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), 40)];
    view.backgroundColor = [UIColor clearColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectInset(view.frame, 0, 0)];
    label.text = messages.lastObject;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    
    [UIView animateWithDuration:0.15 animations:^{
        
        self.frame = rect;
        [views enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
           
            UIView *view = (UIView *)obj;
            CGRect rect = view.frame;
            rect.origin.y += 40;
            view.frame = rect;
        }];
        
    } completion:^(BOOL finished) {
        
        [view addSubview:label];
        [views addObject:view];
        
        [_timer setFireDate:[NSDate dateWithTimeIntervalSinceNow:2.8]];
    }];
    
    return view;
}

- (void)removeReminderLastCell{
    
    if (messages.count >= 1 && views.count >= 1){
        
        CGRect rect = self.frame;
        rect.size.height -= 40;
        
        [UIView animateWithDuration:0.15 animations:^{
            
            self.frame = rect;
            
        } completion:^(BOOL finished) {
            
            UIView *view = views.firstObject;
            [view removeFromSuperview];
        }];
        
    }else [_timer invalidate];
}

- (void)dealloc{
    
    _timer = nil;
}

@end





