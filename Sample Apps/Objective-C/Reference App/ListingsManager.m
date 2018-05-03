//
//  ListingsManager.m
//  Reference App
//
//  Created by Aaron Bratcher on 1/3/18.
//  Copyright © 2018 Liveperson. All rights reserved.
//

#import "ListingsManager.h"
#import "Listing.h"

@implementation ListingsManager

NSString *const referenceDefaultsKey = @"referenceDefaultsKey";
NSString *const nameKey = @"name";
NSString *const referenceIDKey = @"referenceID";

ListingsManager *_sharedManager;

+(ListingsManager *)shared {
	if (_sharedManager)
		return _sharedManager;

	_sharedManager = [[ListingsManager alloc] init];
	return _sharedManager;
}

-(NSArray<Listing *> *) listings {
	NSMutableArray *listings = [[NSMutableArray alloc] init];
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSArray *savedReferences = [defaults arrayForKey:referenceDefaultsKey];
	if([savedReferences isKindOfClass:[NSArray class]]) {
		for (NSDictionary *reference in savedReferences) {
			if(![reference isKindOfClass:[NSDictionary class]]) continue;
			NSString *name = reference[nameKey];
			NSString *referenceID = reference[referenceIDKey];
			
			if(!name || ![name isKindOfClass:[NSString class]]) continue;
			if(!referenceID || ![referenceID isKindOfClass:[NSString class]]) continue;

			Listing *listing = [[Listing alloc] init];
			listing.name = name;
			listing.referenceID = referenceID;

			[listings addObject:listing];
		}
	}

	return listings;
}

-(void) addListing:(Listing *) listing {
	NSMutableArray *references = [[NSMutableArray alloc] init];
	NSDictionary *listingDict = @{nameKey:listing.name, referenceIDKey:listing.referenceID};
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSArray *savedReferences = [defaults arrayForKey:referenceDefaultsKey];

	if([savedReferences isKindOfClass:[NSArray class]]) {
		references = [[NSMutableArray alloc] initWithArray: savedReferences];
	}

	[references addObject:listingDict];
	[defaults setObject:references forKey:referenceDefaultsKey];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"listingAdded" object:listing];
}


@end
