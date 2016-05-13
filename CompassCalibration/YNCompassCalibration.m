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
}

- (CLLocationManager *)locationManager{
    
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    _locationManager.delegate = self;
    //Start the compass updates.
    [_locationManager startUpdatingHeading];
    
    return _locationManager;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading
{
    NSLog(@"New magnetic heading: %f", newHeading.magneticHeading);
    NSLog(@"New true heading: %f", newHeading.trueHeading);
    
    float mHeading = newHeading.trueHeading;
    
    if ((mHeading >= 339) || (mHeading <= 22)) {
        
        /*N*/
        
    }else if ((mHeading > 23) && (mHeading <= 68)) {
        
        /*NE*/
        
    }else if ((mHeading > 69) && (mHeading <= 113)) {
        
        /*E*/
        
    }else if ((mHeading > 114) && (mHeading <= 158)) {
        
        /*SE*/
        
    }else if ((mHeading > 159) && (mHeading <= 203)) {
        
        /*S*/
        
    }else if ((mHeading > 204) && (mHeading <= 248)) {
        
        /*SW*/
        
    }else if ((mHeading > 249) && (mHeading <= 293)) {
        
        /*W*/
        
    }else if ((mHeading > 294) && (mHeading <= 338)) {
        
        /*NW*/
    }
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
