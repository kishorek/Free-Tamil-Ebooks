//
//  FTEBook.m
//  FreeTamilEbook
//
//  Created by Kishore on 21/1/14.
//  Copyright (c) 2014 KishoreK. All rights reserved.
//

#import "FTEBook.h"

@implementation FTEBook

-(instancetype) initWithBookXML:(NSDictionary *) dict{
    self = [super init];
    if (self) {
        NSDictionary *metaData = [dict objectForKey:@"metadata"];
#warning Check all the Strings below for a possibility of becoming Dictionary
        if ([[metaData objectForKey:@"dc:creator"] isKindOfClass:[NSString class]]) {
            [self setAuthor:[metaData objectForKey:@"dc:creator"]];
        }
        
        if ([[metaData objectForKey:@"dc:title"] isKindOfClass:[NSString class]]) {
            [self setTitle:[metaData objectForKey:@"dc:title"]];
        }
        
        NSDictionary *spine = [dict objectForKey:@"spine"];
        NSArray *itemsList = [spine objectForKey:@"itemref"];
        NSMutableArray *tocList = [NSMutableArray array];
        for (int i=0;i<itemsList.count;i++) {
            [tocList addObject:[[itemsList objectAtIndex:i] objectForKey:@"_idref"]];
        }
        
        NSArray *manifest = [[dict objectForKey:@"manifest"] objectForKey:@"item"];
        NSMutableDictionary *tocItems = [NSMutableDictionary dictionary];
        for (NSDictionary *tItem in manifest) {
            [tocItems setObject:[tItem objectForKey:@"_href"] forKey:[tItem objectForKey:@"_id"]];
        }
        
        [self setAvailablePages:tocItems];
        [self setToc:tocList];
    }
    
    return self;
}
-(BOOL)isEqual:(id)object{
    if ([object isKindOfClass:[FTEBook class]]) {
        FTEBook *tObj = (FTEBook *) object;
        return [tObj.bookId isEqualToString:self.bookId];
    }
    return NO;
}

//===========================================================
//  Keyed Archiving
//
//===========================================================
- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.title forKey:@"title"];
    [encoder encodeObject:self.author forKey:@"author"];
    [encoder encodeObject:self.bookId forKey:@"bookId"];
    [encoder encodeInteger:self.currentPage forKey:@"currentPage"];
    [encoder encodeObject:self.currentLocation forKey:@"currentLocation"];
    [encoder encodeObject:self.toc forKey:@"toc"];
    [encoder encodeObject:self.availablePages forKey:@"availablePages"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if (self) {
        self.title = [decoder decodeObjectForKey:@"title"];
        self.author = [decoder decodeObjectForKey:@"author"];
        self.bookId = [decoder decodeObjectForKey:@"bookId"];
        self.currentPage = [decoder decodeIntegerForKey:@"currentPage"];
        self.currentLocation = [decoder decodeObjectForKey:@"currentLocation"];
        self.toc = [decoder decodeObjectForKey:@"toc"];
        self.availablePages = [decoder decodeObjectForKey:@"availablePages"];
    }
    return self;
}

@end
