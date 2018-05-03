//
//  ListingsViewController.m
//  Reference App
//
//  Created by Aaron Bratcher on 1/4/18.
//  Copyright © 2018 Liveperson. All rights reserved.
//

#import "ListingsViewController.h"
#import "Listing.h"
#import "ListingsManager.h"
#import "AppSettings.h"
#import "ContainerViewController.h"
#import "ListingCell.h"
#import "Reference_App-Swift.h"

@interface ListingsViewController () <ListingCellDelegate>
@property (nonatomic, strong) NSArray<Listing *> *listings;
@end

@implementation ListingsViewController


BOOL isVisible = NO;

-(void)viewDidLoad {
	[super viewDidLoad];
	self.listings = [[NSMutableArray alloc] init];

	__weak ListingsViewController* weakSelf = self;
	[[NSNotificationCenter defaultCenter] addObserverForName:@"pushNotificationReceived" object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
		ListingsViewController* strongSelf = weakSelf;
		Listing *listing = note.object;
		if (strongSelf && [listing isKindOfClass:[Listing class]]) {
			[strongSelf chatWithReferenceID:listing.referenceID name:listing.name];
		}
	}];

	[[NSNotificationCenter defaultCenter] addObserverForName:@"listingAdded" object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
		ListingsViewController* strongSelf = weakSelf;
		Listing *listing = note.object;
		if (strongSelf && [listing isKindOfClass:[Listing class]]) {
			NSMutableArray *newListings = [[NSMutableArray alloc] initWithArray:self.listings];
			[newListings addObject:listing];
			strongSelf.listings = newListings;
			[strongSelf.tableView reloadData];
		}
	}];
}

-(void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	self.listings = [[ListingsManager shared] listings];
	[self.tableView reloadData];
}

-(void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	if(!AppSettings.shared.hasCredentials) {
		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
			[self performSegueWithIdentifier:@"showSettings" sender:nil];
		});
	}
	isVisible = true;
}

-(void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
	isVisible = false;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if([segue.identifier isEqualToString:@"showChatContainer"]) {
		NSDictionary *chatInfo = sender;
		if(![chatInfo isKindOfClass:[NSDictionary class]]) return;

		NSString *referenceID = chatInfo[@"referenceID"];
		if(![referenceID isKindOfClass:[NSString class]]) return;

		NSString *title = chatInfo[@"name"];
		if(![title isKindOfClass:[NSString class]]) return;

		ContainerViewController *container = segue.destinationViewController;
		if(![container isKindOfClass:[ContainerViewController class]]) return;

		container.referenceID = referenceID;
		container.title = title;
	}
}

-(void)chatWithReferenceID:(NSString *)referenceID name:(NSString*)name {
	if(AppSettings.shared.useFullScreen) {
		[MessagingExperience.shared showConversationFor:referenceID name:name with:@"" in:nil];
	} else {
		NSDictionary *chatInfo = @{@"referenceID":referenceID, @"name":name};
		[self performSegueWithIdentifier:@"showChatContainer" sender:chatInfo];
	}
}

- (IBAction)showSettingsTapped:(id)sender {
	[self performSegueWithIdentifier:@"showSettings" sender:nil];
}

- (IBAction)showAllTapped:(id)sender {
	[MessagingExperience.shared showAllConversations];
}

- (IBAction)addTapped:(id)sender {
	UIAlertController *errorAlert = [UIAlertController alertControllerWithTitle:@"Add Listing" message:nil preferredStyle:UIAlertControllerStyleAlert];

	[errorAlert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
		// do nothing
	}]];

	__weak ListingsViewController *weakSelf = self;
	[errorAlert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
		ListingsViewController *strongSelf = weakSelf;
		if (strongSelf == nil) return;

		NSArray *textFields = errorAlert.textFields;
		if(textFields == nil) return;

		NSString *name = ((UITextField *)textFields[0]).text;
		NSString *referenceID = ((UITextField *)textFields[1]).text;

		Listing *listing = [[Listing alloc] init];
		listing.name = name;
		listing.referenceID = referenceID;
		[ListingsManager.shared addListing:listing];
	}]];

	[errorAlert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
		textField.placeholder = @"Name";
	}];

	[errorAlert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
		textField.placeholder = @"ReferenceID";
	}];

	[self presentViewController:errorAlert animated:YES completion:nil];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.listings.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	ListingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ListingCell" forIndexPath:indexPath];
	[cell initializeWithDelegate:self];
	Listing *listing = self.listings[indexPath.row];
	[cell showWithName:listing.name referenceID:listing.referenceID];

	return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:true];
}

@end
