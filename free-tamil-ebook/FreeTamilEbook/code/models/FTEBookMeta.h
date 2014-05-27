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
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *bookId;
@property (nonatomic, copy) NSString *author;
@property (nonatomic, copy) NSString *imagePath;
@property (nonatomic, copy) NSString *epubLink;
@property (nonatomic, copy) NSString *pdfLink;
@property (nonatomic, copy) NSString *webLink;
@property (nonatomic, copy) NSString *category;
@property (nonatomic, assign) NSInteger imageHeight;
@property (nonatomic, assign) NSInteger imageWidth;

@end
