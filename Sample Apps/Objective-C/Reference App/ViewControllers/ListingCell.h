//
//  ListingCell.h
//  Reference App
//
//  Created by Aaron Bratcher on 1/4/18.
//  Copyright © 2018 Liveperson. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ListingCellDelegate

-(void) chatWithReferenceID:(NSString *)referenceID name:(NSString*)name;

@end

@interface ListingCell : UITableViewCell

-(void)initializeWithDelegate:(id<ListingCellDelegate>)delegate;
-(void)showWithName:(NSString*)name referenceID:(NSString*)referenceID;

@end
