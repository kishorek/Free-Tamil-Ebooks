//
//  FTEBookMeta.h
//  FreeTamilEbook
//
//  Created by Kishore on 22/1/14.
//  Copyright (c) 2014 KishoreK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FTEBookMeta : NSObject

-(instancetype) initWithMetaData:(NSDictionary *) dict;

@property (nonatomic, strong) NSDate   *publishedDate;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *bookId;
@property (nonatomic, strong) NSString *author;
@property (nonatomic, strong) NSString *imagePath;
@property (nonatomic, strong) NSString *epubLink;
@property (nonatomic, strong) NSString *pdfLink;
@property (nonatomic, strong) NSString *webLink;
@property (nonatomic, strong) NSString *category;
@property (nonatomic, assign) NSInteger imageHeight;
@property (nonatomic, assign) NSInteger imageWidth;

@end
