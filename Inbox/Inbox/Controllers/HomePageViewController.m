//
//  HomePageViewController.m
//  Inbox
//
//  Created by Subhankar Ghosh on 27/04/16.
//  Copyright © 2016 Subhankar Ghosh. All rights reserved.
//

#import "HomePageViewController.h"
#import "EmailTableViewCell.h"

@interface HomePageViewController ()<MGSwipeTableCellDelegate>

@property (strong, nonatomic) IBOutlet UITableView *emailTableview;

@end

@implementation HomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSURL *url = [NSURL URLWithString:@"https://api.myjson.com/bins/1xubp"];
    if (url) {
        NSData *urlData = [NSData dataWithContentsOfURL:url];
        if (urlData && urlData.length) {
            NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:urlData options:kNilOptions error:nil];
            if (jsonDictionary && [jsonDictionary isKindOfClass:[NSDictionary class]]) {
                
                if (jsonDictionary && [jsonDictionary objectForKey:@"data"]) {
                    id data = [jsonDictionary objectForKey:@"data"];
                    if (data && [data objectForKey:@"emails"] ) {
                        id emailData = [data objectForKey:@"emails"];
                        if (emailData && [emailData isKindOfClass:[NSArray class]]) {
                            
                            NSArray *arrData = [data objectForKey:@"emails"];
                            for (NSDictionary *dict in arrData) {
                                
                                if (_emailDataArray == nil) {
                                    _emailDataArray = [[NSMutableArray alloc]init];
                                }
                                [_emailDataArray addObject:dict];
                                
                            }
                        }
                    }
                }
            }
            else
            {
                //failed
            }
        }
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_emailDataArray && _emailDataArray.count) {
        return _emailDataArray.count;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"EmailTableCell";
    EmailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    if (cell==nil) {
        cell = [[EmailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.delegate  = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    if (_emailDataArray && _emailDataArray.count > indexPath.row) {
        NSDictionary *val = [_emailDataArray objectAtIndex:indexPath.row];
        if (val && [val isKindOfClass:[NSDictionary class]] && val.count) {
            NSString *strName = [val objectForKey:@"name"];
            NSString *strDescription = [val objectForKey:@"desc"];
            NSString *strTimestamp = [val objectForKey:@"timestamp"];
            
            NSTimeInterval _interval = [strTimestamp doubleValue];
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
            
            NSString *dateString = [self convertDateStringFromDate:date];
            
            cell.senderNameLabel.text = strName;
            cell.timeLabel.text = dateString;
            cell.emailDesciptionLabel.text = strDescription;
        }
    }
    return cell;
}

-(NSString *)convertDateStringFromDate:(NSDate *)givenDate
{
    NSDate *today = [NSDate date];
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSUInteger units = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute;
    NSDateComponents *components = [gregorian components:units fromDate:givenDate toDate:today options:0];
    
    NSInteger years = [components year];
    NSInteger months = [components month];
    NSInteger days = [components day];
    NSInteger hours = [components hour];
    NSInteger minutes = [components minute];
    
    NSString *strDate;
    if (years ==0 && months==0 && days==0 && hours==0 && minutes<60) {
        strDate = [NSString stringWithFormat:@"%ld min ago",(long)minutes];
        return strDate;
    }
    else if (years ==0 && months==0 && days==0 && hours<24){
        strDate = [NSString stringWithFormat:@"%ld hrs ago",(long)hours];
        return strDate;
    }
    else if(years ==0 && months==0 && days==0 && hours<48 && hours>24){
        strDate = @"Yesterday";
        return strDate;
    }
    else if(years ==0 && months==0 && days <7){
        strDate = [NSString stringWithFormat:@"%ld days ago",(long)days];
        return strDate;
    }
    else{
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setLocale:[NSLocale currentLocale]];
        
        NSString *strDate1 = nil;

        if (years==0) {
            [formatter setDateFormat:@"MMM d"];
            strDate1 = [formatter stringFromDate:givenDate];
            
            strDate = [NSString stringWithFormat:@"%@", strDate1];
            return strDate;
        }
        else{
            if (years==1) {
                strDate = [NSString stringWithFormat:@"%ld year ago",(long)years];

            }
            else
            {
                strDate = [NSString stringWithFormat:@"%ld years ago",(long)years];
            }
            return strDate;
        }
        
    }
    return 0;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark Swipe Delegate

-(BOOL) swipeTableCell:(MGSwipeTableCell*) cell canSwipe:(MGSwipeDirection) direction;
{
    return YES;
}

-(NSArray*) swipeTableCell:(MGSwipeTableCell*) cell swipeButtonsForDirection:(MGSwipeDirection)direction
             swipeSettings:(MGSwipeSettings*) swipeSettings expansionSettings:(MGSwipeExpansionSettings*) expansionSettings
{
    
    swipeSettings.transition = MGSwipeTransitionBorder;
    expansionSettings.buttonIndex = 0;
    
    __weak typeof(self) weakSelf = self;
    
    if (direction == MGSwipeDirectionRightToLeft) {
        
        }
    else {
        
        expansionSettings.fillOnTrigger = NO;
        expansionSettings.threshold = 2;
        
        NSIndexPath * indexPath = [(UITableView *) self.emailTableview indexPathForCell:cell];

        if (_emailDataArray) {
            NSDictionary *val = [_emailDataArray objectAtIndex:indexPath.row];
            if (val && [val isKindOfClass:[NSDictionary class]] && val.count) {
                NSString *strName = [val objectForKey:@"name"];
                NSString *strDescription = [val objectForKey:@"desc"];
                
                
                NSUserDefaults *sharedDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.home.InboxWidget"];
                
                [sharedDefaults setObject:strName forKey:@"Name"];
                [sharedDefaults setObject:strDescription forKey:@"Description"];
                [sharedDefaults synchronize];               }
        }
        
        CGFloat padding = 15;
        
        MGSwipeButton * readButton = [MGSwipeButton buttonWithTitle:@"Mark as\nUnread" backgroundColor:[UIColor colorWithRed:15.0/255.0 green:95.0/255.0 blue:200.0/255.0 alpha:1.0] padding:padding callback:^BOOL(MGSwipeTableCell *sender) {
            __strong typeof(self) strongSelf = weakSelf;
//            NSIndexPath * indexPath = [strongSelf.emailTableview indexPathForCell:sender];
            [strongSelf markAsReadtheMailAtIndexPath:indexPath];
            
            return NO; //don't autohide to improve delete animation
        }];
        
        return @[readButton];
    }
    
    return nil;
    
}

-(void) swipeTableCell:(MGSwipeTableCell*) cell didChangeSwipeState:(MGSwipeState)state gestureIsActive:(BOOL)gestureIsActive
{
    NSString * str;
    switch (state) {
        case MGSwipeStateNone: str = @"None"; break;
        case MGSwipeStateSwippingLeftToRight: str = @"SwippingLeftToRight"; break;
        case MGSwipeStateSwippingRightToLeft: str = @"SwippingRightToLeft"; break;
        case MGSwipeStateExpandingLeftToRight: str = @"ExpandingLeftToRight"; break;
        case MGSwipeStateExpandingRightToLeft: str = @"ExpandingRightToLeft"; break;
    }
    NSLog(@"Swipe state: %@ ::: Gesture: %@", str, gestureIsActive ? @"Active" : @"Ended");
}

-(void)markAsReadtheMailAtIndexPath:(NSIndexPath*)indexPath
{
    //Perform action as read.
    
}

@end
