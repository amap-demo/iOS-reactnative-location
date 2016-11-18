//
//  RCTAMapLocation.m
//  HelloRN
//
//  Created by xiaoming han on 16/11/11.
//  Copyright © 2016年 Facebook. All rights reserved.
//

#import "AMapRCLocationManager.h"
#import <AMapLocationKit/AMapLocationManager.h>

#define kAMapRCLocationObserveKey  @"amapLocationDidChange"

@interface AMapRCLocationManager ()<AMapLocationManagerDelegate>
{
  AMapLocationManager *_locationManagerSingle;
  AMapLocationManager *_locationManagerSeries;
}

@end

@implementation AMapRCLocationManager

- (instancetype)init
{
  self = [super init];
  if (self)
  {
    _locationManagerSingle = [[AMapLocationManager alloc] init];
    _locationManagerSingle.desiredAccuracy = 300;
    
    _locationManagerSeries = [[AMapLocationManager alloc] init];
    _locationManagerSeries.delegate = self;
  }
  
  return self;
}

RCT_EXPORT_MODULE();

RCT_EXPORT_METHOD(getLocation:(RCTResponseSenderBlock)callback)
{
  [_locationManagerSingle requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
    
    id e = [NSNull null];
    if (error)
    {
      e = error.description;
    }
    
    NSDictionary *lo = (NSDictionary *)[NSNull null];
    if (location) {
      lo = @{@"latitude" : @(location.coordinate.latitude), @"longitude" : @(location.coordinate.longitude), @"timestamp" : @((long)location.timestamp.timeIntervalSince1970)};
    }
    
    NSDictionary *re = (NSDictionary *)[NSNull null];
    if (regeocode) {
      re = @{@"address" : regeocode.formattedAddress ?: @"",
             @"province" : regeocode.province ?: @"",
             @"city" : regeocode.city ?: @"",
             @"district" : regeocode.district ?: @"",
             @"citycode" : regeocode.citycode ?: @"",
             @"adcode" : regeocode.adcode ?: @""
             };
    }
    
    callback(@[e, lo, re]);
    
  }];
}

#pragma mark - Emitter

- (NSArray<NSString *> *)supportedEvents
{
  return @[kAMapRCLocationObserveKey];
}

- (void)startObserving
{
  [_locationManagerSeries startUpdatingLocation];
}

- (void)stopObserving
{
  [_locationManagerSeries stopUpdatingLocation];
}

#pragma mark - AMapLocationManagerDelegate

- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location
{
  
  NSDictionary *lo = @{@"latitude" : @(location.coordinate.latitude), @"longitude" : @(location.coordinate.longitude), @"timestamp" : @((long)location.timestamp.timeIntervalSince1970)};
  
  [self sendEventWithName:kAMapRCLocationObserveKey body:lo];
}

@end
