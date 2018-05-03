//
//  AppSettingsController.m
//  Reference App
//
//  Created by Aaron Bratcher on 1/4/18.
//  Copyright © 2018 Liveperson. All rights reserved.
//

#import "AppSettingsController.h"
#import "Reference_App-Swift.h"
#import "ListingsManager.h"
#import "AppSettings.h"

@interface AppSettingsController ()
@property (weak, nonatomic) IBOutlet UITextField *applicationID;
@property (weak, nonatomic) IBOutlet UITextField *providerID;
@property (weak, nonatomic) IBOutlet UITextField *baseURL;
@property (weak, nonatomic) IBOutlet UISwitch *useFullScreenSwitch;

@end

@implementation AppSettingsController

-(void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];

	NSInteger applicationID = AppSettings.shared.applicationID;
	self.applicationID.text = (applicationID > 0 ? @(applicationID).stringValue : nil);

	NSInteger providerID = AppSettings.shared.providerID;
	self.providerID.text = (providerID > 0 ? @(providerID).stringValue : nil);

	self.baseURL.text = AppSettings.shared.baseURL;
	[self.useFullScreenSwitch setOn:AppSettings.shared.useFullScreen];
}

-(void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];

	if(self.applicationID.text && self.applicationID.text.length > 0) {
		AppSettings.shared.applicationID = self.applicationID.text.integerValue;
	} else {
		if(self.applicationID.placeholder && self.applicationID.placeholder.length > 0) {
			AppSettings.shared.applicationID = self.applicationID.placeholder.integerValue;
		} else {
			AppSettings.shared.applicationID = 0;
		}
	}

	if(self.providerID.text && self.providerID.text.length > 0) {
		AppSettings.shared.providerID = self.providerID.text.integerValue;
	} else {
		if(self.providerID.placeholder && self.providerID.placeholder.length > 0) {
			AppSettings.shared.providerID = self.providerID.placeholder.integerValue;
		} else {
			AppSettings.shared.providerID = 0;
		}
	}

	if(self.baseURL.text && self.baseURL.text.length > 0) {
		AppSettings.shared.baseURL = self.baseURL.text;
	} else {
		if(self.baseURL.placeholder && self.baseURL.placeholder.length > 0) {
			AppSettings.shared.baseURL = self.baseURL.placeholder;
		} else {
			AppSettings.shared.baseURL = nil;
		}
	}

	[[MessagingExperience shared] initialize];
}

- (IBAction)useFullScreenSwitchFlipped:(UISwitch *)sender {
	[[AppSettings shared] setUseFullScreen:sender.isOn];
}

- (IBAction)resetDataTapped:(id)sender {
	UIAlertController *errorAlert = [UIAlertController alertControllerWithTitle:@"Reset Data" message:@"Resetting data will remove all Liveperson conversations and credentials from this application." preferredStyle:UIAlertControllerStyleAlert];

	[errorAlert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
		// do nothing
	}]];

	__weak AppSettingsController *weakSelf = self;
	[errorAlert addAction:[UIAlertAction actionWithTitle:@"Reset" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
		AppSettingsController *strongSelf = weakSelf;
		if (strongSelf == nil) return;

		dispatch_async(dispatch_get_main_queue(), ^{
			[[MessagingExperience shared] reset];
			[[NSUserDefaults standardUserDefaults] removeObjectForKey:referenceDefaultsKey];
			strongSelf.applicationID.placeholder = strongSelf.applicationID.text;
			strongSelf.providerID.placeholder = strongSelf.providerID.text;
			strongSelf.baseURL.placeholder = strongSelf.baseURL.text;
			strongSelf.applicationID.text = nil;
			strongSelf.providerID.text = nil;
			strongSelf.baseURL.text = nil;
		});
	}]];

	[self presentViewController:errorAlert animated:YES completion:nil];
}

@end
