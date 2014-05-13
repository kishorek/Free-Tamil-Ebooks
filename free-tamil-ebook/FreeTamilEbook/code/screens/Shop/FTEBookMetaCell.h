//
//  FTEBookMetaCell.h
//  FreeTamilEbook
//
//  Created by Kishore on 22/1/14.
//  Copyright (c) 2014 KishoreK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FTEBookMeta.h"

@interface FTEBookMetaCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *bookImg;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UIImageView *downloadIndicator;

@property (nonatomic, strong) FTEBookMeta *bookMetaInfo;

@end
