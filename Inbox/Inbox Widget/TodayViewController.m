//
//  TodayViewController.m
//  Inbox Widget
//
//  Created by Subhankar Ghosh on 30/04/16.
//  Copyright © 2016 Subhankar Ghosh. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>

@interface TodayViewController () <NCWidgetProviding>

@end

@implementation TodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self updateWidgetView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(userDefaultsDidChange:)
                                                     name:NSUserDefaultsDidChangeNotification
                                                   object:nil];
    }
    return self;
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData

    completionHandler(NCUpdateResultNewData);
}

- (UIEdgeInsets)widgetMarginInsetsForProposedMarginInsets:(UIEdgeInsets)margins
{
    margins.bottom = 10.0;
    return margins;
}

- (IBAction)tapWidget:(id)sender {
    
    NSURL *customURL = [NSURL URLWithString:@"InboxApp://"];
    [self.extensionContext openURL:customURL completionHandler:nil];
    
}

- (void)userDefaultsDidChange:(NSNotification *)notification {
    [self updateWidgetView];
}

-(void)updateWidgetView{
    
    NSUserDefaults *sharedDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.home.InboxWidget"];
    _nameLabel.text = [sharedDefaults objectForKey:@"Name"];
    _descriptionLabel.text = [sharedDefaults objectForKey:@"Description"];
}

@end
