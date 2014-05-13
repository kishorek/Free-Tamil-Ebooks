//
//  FTESettingsViewController.m
//  FreeTamilEbook
//
//  Created by Kishore on 23/1/14.
//  Copyright (c) 2014 KishoreK. All rights reserved.
//

#import "FTESettingsViewController.h"

@interface FTESettingsViewController ()<UIAlertViewDelegate>

@end

@implementation FTESettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.nightModeSwitch.on = isNightModeOn();
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)nightModeTapped:(id)sender {
    UISwitch *nightModeButton = sender;
    if (nightModeButton.on) {
        turnNightModeOn(self.navigationController);
    } else {
        turnNightModeOff(self.navigationController);
    }
}

- (IBAction)resetTapped:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"This will delete all the books you have downloaded.\n Are you sure?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    [alert show];
}

- (IBAction)closeTapped:(id)sender {
    if (self.action) {
        self.action();
    }
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        resetCache();
    }
}

@end
