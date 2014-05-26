//
//  FTEAppDelegate.h
//  FreeTamilEbook
//
//  Created by Kishore on 20/1/14.
//  Copyright (c) 2014 KishoreK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FTEBooksDB.h"
#import "FTEUtilities.h"

@interface FTEAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) FTEBooksDB *booksDB;

@end
