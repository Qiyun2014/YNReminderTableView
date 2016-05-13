//
//  YNCompassCalibration.h
//  CompassCalibration
//
//  Created by qiyun on 16/5/10.
//  Copyright © 2016年 ProDrone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface YNCompassCalibration : UIViewController<CLLocationManagerDelegate>

@property (nonatomic, retain) CLLocationManager *locationManager;

@end
