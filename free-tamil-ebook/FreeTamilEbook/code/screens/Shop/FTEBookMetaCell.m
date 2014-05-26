//
//  FTEBookMetaCell.m
//  FreeTamilEbook
//
//  Created by Kishore on 22/1/14.
//  Copyright (c) 2014 KishoreK. All rights reserved.
//

#import "FTEBookMetaCell.h"
#import "UIImageView+AFNetworking.h"

@interface FTEBookMetaCell ()

@end

@implementation FTEBookMetaCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)setBookMetaInfo:(FTEBookMeta *)bookMetaInfo{
    _bookMetaInfo = bookMetaInfo;
    
    [self.bookImg setImageWithURL:[NSURL URLWithString:self.bookMetaInfo.imagePath] placeholderImage:[UIImage imageNamed:@"default-book"]];
    [self.lblTitle setText:self.bookMetaInfo.title];
    
    if (isNightModeOn()) {
        self.lblTitle.textColor = [UIColor whiteColor];
    } else {
        self.lblTitle.textColor = [UIColor blackColor];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
