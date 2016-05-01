//
//  HomePageViewController.h
//  Inbox
//
//  Created by Subhankar Ghosh on 27/04/16.
//  Copyright © 2016 Subhankar Ghosh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomePageViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>

@property (strong, nonatomic) NSMutableArray *emailDataArray;
@end
