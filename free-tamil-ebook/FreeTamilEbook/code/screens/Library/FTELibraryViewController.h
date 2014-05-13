//
//  FTELibraryViewController.h
//  FreeTamilEbook
//
//  Created by Kishore on 22/1/14.
//  Copyright (c) 2014 KishoreK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FTELibraryViewController : UIViewController
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *emptyTextLabel;

@end
