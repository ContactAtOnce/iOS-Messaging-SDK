//
//  ListingsManager.h
//  Reference App
//
//  Created by Aaron Bratcher on 1/3/18.
//  Copyright © 2018 Liveperson. All rights reserved.
//

@import Foundation;

extern NSString *const referenceDefaultsKey;

@class Listing;

@interface ListingsManager : NSObject

@property (class, nonatomic, readonly) ListingsManager *shared;
-(NSArray<Listing *> *) listings;
-(void) addListing:(Listing *) listing;

@end
