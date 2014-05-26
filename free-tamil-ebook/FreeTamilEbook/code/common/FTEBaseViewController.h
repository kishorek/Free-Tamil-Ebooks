//
//  FTEBaseViewController.h
//  FreeTamilEbook
//
//  Created by Kishore Kumar on 24/1/14.
//  Copyright (c) 2014 KishoreK. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^Action) (void);

@interface FTEBaseViewController : UIViewController

@property(nonatomic, strong) Action action;

@end
