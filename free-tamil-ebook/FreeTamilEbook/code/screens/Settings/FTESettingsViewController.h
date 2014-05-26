//
//  FTESettingsViewController.h
//  FreeTamilEbook
//
//  Created by Kishore on 23/1/14.
//  Copyright (c) 2014 KishoreK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FTESettingsViewController : FTEBaseViewController

- (IBAction)nightModeTapped:(id)sender;
- (IBAction)resetTapped:(id)sender;
- (IBAction)closeTapped:(id)sender;

@property (weak, nonatomic) IBOutlet UISwitch *nightModeSwitch;
@property (weak, nonatomic) IBOutlet UITextView *aboutTV;
@property (weak, nonatomic) IBOutlet UILabel *lblVersion;
@property (nonatomic, assign) BOOL hideResetOption;

@end
