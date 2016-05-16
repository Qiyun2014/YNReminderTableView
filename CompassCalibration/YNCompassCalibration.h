//
//  YNCompassCalibration.h
//  CompassCalibration
//
//  Created by qiyun on 16/5/10.
//  Copyright © 2016年 ProDrone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

typedef void (^YNCalibrationSuccess) (BOOL success);

@interface YNCompassCalibration : UIView<CLLocationManagerDelegate>

@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, strong) UIImageView   *compass;
@property (nonatomic, strong) UIImageView   *ball;

@property (nonatomic, copy)YNCalibrationSuccess calibration;
- (id)initWithFrame:(CGRect)frame;

@end
