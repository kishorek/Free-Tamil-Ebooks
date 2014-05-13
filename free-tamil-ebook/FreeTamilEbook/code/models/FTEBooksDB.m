//
//  FTEBooksDB.m
//  FreeTamilEbook
//
//  Created by Kishore on 21/1/14.
//  Copyright (c) 2014 KishoreK. All rights reserved.
//

#import "FTEBooksDB.h"

@implementation FTEBooksDB

-(id)init{
    if (self == [super init]) {
        self.availableBooks = [NSMutableArray array];
        self.downloadedBooks = [NSMutableArray array];
    }
    return self;
}

//===========================================================
//  Keyed Archiving
//
//===========================================================
- (void)encodeWithCoder:(NSCoder *)encoder
{
    //[encoder encodeObject:self.downloadedBooks forKey:@"downloadedBooks"];
    [encoder encodeObject:self.availableBooks forKey:@"availableBooks"];
    [encoder encodeObject:[NSNumber numberWithLong:self.lastSynced] forKey:@"lastSynced"];
    [encoder encodeObject:self.currentBook forKey:@"currentBook"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if (self) {
        //self.downloadedBooks = [decoder decodeObjectForKey:@"downloadedBooks"];
        self.availableBooks = [decoder decodeObjectForKey:@"availableBooks"];
        [self setLastSynced:[[decoder decodeObjectForKey:@"lastSynced"] longValue]];
        self.currentBook = [decoder decodeObjectForKey:@"currentBook"];
    }
    return self;
}

@end
