//
//  FTEBook.h
//  FreeTamilEbook
//
//  Created by Kishore on 21/1/14.
//  Copyright (c) 2014 KishoreK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FTEBook : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *author;
@property (nonatomic, strong) NSString *bookId;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) NSString *currentLocation;

@property (nonatomic, strong) NSArray *toc;
@property (nonatomic, strong) NSDictionary *availablePages;

-(instancetype) initWithBookXML:(NSDictionary *) dict;

@end
