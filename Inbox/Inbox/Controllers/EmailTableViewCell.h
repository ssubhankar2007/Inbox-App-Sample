//
//  EmailTableViewCell.h
//  Inbox
//
//  Created by Subhankar Ghosh on 28/04/16.
//  Copyright © 2016 Subhankar Ghosh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGSwipeTableCell.h"

@interface EmailTableViewCell : MGSwipeTableCell

@property (strong, nonatomic) IBOutlet UILabel *senderNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *emailDesciptionLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;

@end
