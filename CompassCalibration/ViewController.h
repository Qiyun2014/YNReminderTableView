//
//  ViewController.h
//  CompassCalibration
//
//  Created by qiyun on 16/5/10.
//  Copyright © 2016年 ProDrone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController


@end


#pragma mark    -   PDLReminderTableView

@interface PDLReminderTableView : UITableView<UITableViewDelegate,UITableViewDataSource>

- (instancetype)initWithFrame:(CGRect)frame;

- (void)showMessage:(NSString *)msg/* complete:(void (^) (BOOL finished))completed */;

@end



@interface PDLReminderView : UIImageView

- (instancetype)initWithFrame:(CGRect)frame;

- (void)showMessage:(NSString *)msg;

@end