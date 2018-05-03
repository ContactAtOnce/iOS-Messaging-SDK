//
//  AppSettings.m
//  Reference App
//
//  Created by Aaron Bratcher on 1/3/18.
//  Copyright © 2018 Liveperson. All rights reserved.
//

#import "AppSettings.h"

NSString *const useFullScreenKey = @"useFullScreen";
NSString *const providerIDKey = @"ProviderIDKey";
NSString *const applicationIDKey = @"ApplicationIDKey";
NSString *const baseDomainKey = @"BaseDomainKey";

@implementation AppSettings

AppSettings *_sharedSettings;
NSUserDefaults *defaults;

-(instancetype) init {
	self = [super init];
	defaults = [NSUserDefaults standardUserDefaults];
	self.useFullScreen = [defaults boolForKey:useFullScreenKey];
	self.providerID = [defaults integerForKey:providerIDKey];
	self.applicationID = [defaults integerForKey:applicationIDKey];
	self.baseURL = [defaults stringForKey:baseDomainKey];

	return self;
}

+(AppSettings *) shared {
	if (_sharedSettings)
		return _sharedSettings;

	_sharedSettings = [[AppSettings alloc] init];
	return _sharedSettings;
}

-(BOOL) hasCredentials {
	return self.providerID > 0 && self.applicationID > 0 && self.baseURL;
}

-(void) setProviderID:(NSInteger)providerID {
	_providerID = providerID;
	[defaults setInteger:providerID forKey:providerIDKey];
}

-(void) setApplicationID:(NSInteger)applicationID {
	_applicationID = applicationID;
	[defaults setInteger:applicationID forKey:applicationIDKey];
}

-(void) setBaseURL:(NSString *)baseURL {
	_baseURL = [baseURL copy];
	[defaults setObject:baseURL forKey:baseDomainKey];
}

-(void) setUseFullScreen:(BOOL)useFullScreen {
	_useFullScreen = useFullScreen;
	[defaults setBool:useFullScreen forKey:useFullScreenKey];
}

@end

