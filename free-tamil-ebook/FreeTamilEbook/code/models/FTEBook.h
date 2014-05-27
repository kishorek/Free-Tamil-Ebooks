//
//  FTEBook.h
//  FreeTamilEbook
//
//  Created by Kishore on 21/1/14.
//  Copyright (c) 2014 KishoreK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FTEBook : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *author;
@property (nonatomic, copy) NSString *bookId;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, copy) NSString *currentLocation;

@property (nonatomic, strong) NSArray *toc;
@property (nonatomic, strong) NSDictionary *availablePages;

-(instancetype) initWithBookXML:(NSDictionary *) dict;

@end
