//
//  FTEBookViewController.h
//  FreeTamilEbook
//
//  Created by Kishore on 21/1/14.
//  Copyright (c) 2014 KishoreK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FTEBookViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIWebView *bookView;
- (IBAction)previousPageTapped:(id)sender;
- (IBAction)nextPageTapped:(id)sender;

@end
