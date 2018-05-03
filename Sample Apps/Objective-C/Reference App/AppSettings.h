//
//  AppSettings.h
//  Reference App
//
//  Created by Aaron Bratcher on 1/3/18.
//  Copyright © 2018 Liveperson. All rights reserved.
//

@import Foundation;

@interface AppSettings : NSObject

@property (class, nonatomic, readonly) AppSettings *shared;

@property (nonatomic, readonly) BOOL hasCredentials;
@property (nonatomic, assign) BOOL useFullScreen;
@property (nonatomic, assign) NSInteger providerID;
@property (nonatomic, assign) NSInteger applicationID;
@property (nonatomic, copy) NSString *baseURL;

@end
