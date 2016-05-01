//
//  KeyboardViewController.m
//  Swift Keyboard
//
//  Created by Subhankar Ghosh on 28/04/16.
//  Copyright © 2016 Subhankar Ghosh. All rights reserved.
//

#import "KeyboardViewController.h"
#import "SwiftKeyboard.h"

@interface KeyboardViewController ()

@property (strong, nonatomic) SwiftKeyboard *swiftKeyboard;
@end

@implementation KeyboardViewController

//-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//    }
//    return self;
//}

- (void)updateViewConstraints {
    [super updateViewConstraints];
    
    // Add custom view sizing constraints here
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Perform custom UI setup here
   
    self.swiftKeyboard = [[[NSBundle mainBundle] loadNibNamed:@"SwiftKeyboard" owner:nil options:0] objectAtIndex:0];
    self.swiftKeyboard.inboxButton.layer.cornerRadius = 10;
    self.swiftKeyboard.inboxButton.layer.borderColor = (__bridge CGColorRef _Nullable)([UIColor blueColor]);
    self.swiftKeyboard.inboxButton.layer.borderWidth = 2.0f;
    
    self.inputView = self.swiftKeyboard;
    
    [self.swiftKeyboard.inboxButton addTarget:self action:@selector(launchApp) forControlEvents:UIControlEventTouchUpInside];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated
}

- (void)textWillChange:(id<UITextInput>)textInput {
    // The app is about to change the document's contents. Perform any preparation here.
}

- (void)textDidChange:(id<UITextInput>)textInput {
    // The app has just changed the document's contents, the document context has been updated.
    
    UIColor *textColor = nil;
    if (self.textDocumentProxy.keyboardAppearance == UIKeyboardAppearanceDark) {
        textColor = [UIColor whiteColor];
    } else {
        textColor = [UIColor blackColor];
    }
}

-(void)dismissKeyboard
{
    [self.inputView endEditing:YES];
    [self.swiftKeyboard endEditing:YES];
    
}

-(void)launchApp
{
    NSURL *customURL = [NSURL URLWithString:@"InboxApp://"];
    [self.extensionContext openURL:customURL completionHandler:nil];

}

@end
