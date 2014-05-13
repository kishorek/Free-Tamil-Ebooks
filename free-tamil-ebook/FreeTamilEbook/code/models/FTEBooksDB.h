//
//  FTEBooksDB.h
//  FreeTamilEbook
//
//  Created by Kishore on 21/1/14.
//  Copyright (c) 2014 KishoreK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FTEBook.h"

@interface FTEBooksDB : NSObject

@property (nonatomic, strong) NSMutableArray *downloadedBooks;
@property (nonatomic, strong) NSMutableArray *availableBooks;

@property (nonatomic, assign) long lastSynced;
@property (nonatomic, strong) FTEBook *currentBook;
@property (nonatomic, strong) NSMutableDictionary *booksPosition; //Will store

@end
