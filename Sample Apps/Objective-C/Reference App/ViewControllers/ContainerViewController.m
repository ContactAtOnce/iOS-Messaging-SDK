//
//  ContainerViewController.m
//  Reference App
//
//  Created by Aaron Bratcher on 1/3/18.
//  Copyright © 2018 Liveperson. All rights reserved.
//

#import "ContainerViewController.h"
#import "Reference_App-Swift.h"

@interface ContainerViewController ()

@end

@implementation ContainerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	[[MessagingExperience shared] showConversationFor:self.referenceID name:self.title ?: @"" with:@"" in: self];
}

@end
