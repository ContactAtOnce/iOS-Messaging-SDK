//
//  ListingCell.m
//  Reference App
//
//  Created by Aaron Bratcher on 1/4/18.
//  Copyright © 2018 Liveperson. All rights reserved.
//

#import "ListingCell.h"

@interface ListingCell()

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (nonatomic, copy) NSString *referenceID;
@property (nonatomic, weak) id<ListingCellDelegate> delegate;

@end

@implementation ListingCell

-(void)prepareForReuse {
	[super prepareForReuse];
	self.name.text = nil;
	self.referenceID = nil;
}

-(void)initializeWithDelegate:(id<ListingCellDelegate>)delegate {
	self.delegate = delegate;
}

-(void)showWithName:(NSString *)name referenceID:(NSString *)referenceID {
	self.name.text = [name copy];
	self.referenceID = [referenceID copy];
}

- (IBAction)chatButtonTapped:(id)sender {
	if(self.delegate)
		[self.delegate chatWithReferenceID:self.referenceID name:self.name.text];
}

@end
