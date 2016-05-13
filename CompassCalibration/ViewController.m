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

@end

@implementation ViewController

#define KCurrentView_Height_(UIView) (UIView.bounds.size.height)
#define KCurrentView_width_(UIView) (UIView.bounds.size.width)
#define Iphone  ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //[self.navigationController popToViewController:[[YNCompassCalibration alloc] init] animated:YES];
    
    
    [self.view addSubview:self.tableView];
    
    self.connectionTimer = [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop]addTimer:self.connectionTimer forMode:NSDefaultRunLoopMode];
}


- (PDLReminderTableView *)tableView{
    
    if (!_tableView) {
        
        _tableView = [[PDLReminderTableView alloc] initWithFrame:CGRectMake(KCurrentView_width_(self.view)*3/8, (Iphone?44:66) + 50, KCurrentView_width_(self.view)/4, 0)];
    }
    return _tableView;
}


-(void)timerFired:(NSTimer *)timer{
    
    NSLog(@"%@",[[NSDate date] description]);
    
    int second = [[NSCalendar currentCalendar] component:kCFCalendarUnitSecond fromDate:[NSDate date]];
    [self.tableView showMessage:[[[NSDate date] description] substringFromIndex:11]];
    
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