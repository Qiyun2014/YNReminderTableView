//
//  YNCompassCalibration.m
//  CompassCalibration
//
//  Created by qiyun on 16/5/10.
//  Copyright © 2016年 ProDrone. All rights reserved.
//

#import "YNCompassCalibration.h"

@implementation YNCompassCalibration
{
    UILabel *course;
    CAShapeLayer *frontFillLayer;      //用来填充的图层
    UIBezierPath *frontFillBezierPath;  //用来填充的贝赛尔曲线
    CGFloat progressValue;
}


- (id)initWithFrame:(CGRect)frame{
    
    if (self == [super initWithFrame:frame]) {
        
        if ([CLLocationManager headingAvailable]) {
         
            [self.locationManager startUpdatingLocation];
            
            //创建填充图层
            frontFillLayer = [CAShapeLayer layer];
            frontFillLayer.fillColor = nil;
            frontFillLayer.frame = self.bounds;
            frontFillLayer.strokeColor = [UIColor redColor].CGColor;
            frontFillLayer.lineWidth = 25;
            [self.layer addSublayer:frontFillLayer];
            
            [self addSubview:self.compass];
            [self.compass addSubview:self.ball];
            [self drawPathWithProgress:0/360];

        }else   NSLog(@"当前设备不支持指南针...");
    }
    return self;
}

- (UIImageView *)compass{
    
    if (!_compass) {
        
        UIImage *image = [UIImage imageNamed:@"circle@3x.png"];
        _compass = [[UIImageView alloc] initWithFrame:CGRectInset(self.bounds, (CGRectGetWidth(self.bounds) - image.size.width)/2, (CGRectGetHeight(self.bounds) - image.size.height)/2)];
        _compass.image = image;
        _compass.contentMode = UIViewContentModeScaleToFill;
    }
    return _compass;
}

- (UIImageView *)ball{
    
    if (!_ball) {
        
        _ball = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.compass.frame)/2-15, 0, 30, 30)];
        _ball.image = [UIImage imageNamed:@"spot@3x.png"];
        //_ball.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _ball;
}

- (CLLocationManager *)locationManager{
    
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    _locationManager.delegate = self;
    //Start the compass updates.
    [_locationManager startUpdatingLocation];
    [_locationManager startUpdatingHeading];
    return _locationManager;
}


- (BOOL)locationManagerShouldDisplayHeadingCalibration:(CLLocationManager *)manager{
    
    if(!manager.heading) return YES; // Got nothing, We can assume we got to calibrate.
    else if(manager.heading.headingAccuracy < 0 ) return YES; // 0 means invalid heading, need to calibrate
    else if(manager.heading.headingAccuracy > 5 ) return YES; // 5 degrees is a small value correct for my needs, too.
    else return NO; // All is good. Compass is precise enough.
}


- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading
{
   // NSLog(@"New magnetic heading: %f", newHeading.magneticHeading);
   // NSLog(@"New true heading: %f", newHeading.trueHeading);
    
    float mHeading = newHeading.trueHeading;
    
    if ((mHeading >= 339) || (mHeading <= 22)) {
        
        /*N 北*/
        //self.compass.transform = CGAffineTransformMakeRotation(mHeading<339?mHeading/360:(360 - mHeading)/360);
        
    }else if ((mHeading > 23) && (mHeading <= 68)) {
        
        /*NE 西北*/
        
    }else if ((mHeading > 69) && (mHeading <= 113)) {
        
        /*E 西*/
        
    }else if ((mHeading > 114) && (mHeading <= 158)) {
        
        /*SE 西南*/
        
    }else if ((mHeading > 159) && (mHeading <= 203)) {
        
        /*S 南*/
        
    }else if ((mHeading > 204) && (mHeading <= 248)) {
        
        /*SW 东南*/
        
    }else if ((mHeading > 249) && (mHeading <= 293)) {
        
        /*W 东*/
        
    }else if ((mHeading > 294) && (mHeading <= 338)) {
        
        /*NW 东北*/
    }
    
    if (mHeading >= 359 && self.calibration)  self.calibration(YES);
    
    [self drawPathWithProgress:mHeading/360];
}

#pragma mark 绘制圆形

- (void)drawPathWithProgress:(CGFloat)value{
    
    self.compass.transform = CGAffineTransformMakeRotation((2*M_PI)*value);

    
    frontFillBezierPath = [UIBezierPath bezierPathWithArcCenter:self.compass.center
                                                         radius:(CGRectGetWidth(self.compass.bounds)-30)/2.f
                                                     startAngle:-M_PI_2
                                                       endAngle:(2*M_PI)*value-M_PI_2
                                                      clockwise:YES];
    frontFillLayer.path = frontFillBezierPath.CGPath;
}


-(void) locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation   *)newLocation fromLocation:(CLLocation *)oldLocation {
    //somecode
    
    double theCourse = newLocation.course;
    NSLog(@"%f",theCourse);
    
    if ((theCourse >= 315) || (theCourse  < 45)) {

        //course.text =@ "N";
    }
    if ((theCourse >135) || (theCourse  <= 225)) {
        
        //course.text =@ "E";
    }
}


@end
