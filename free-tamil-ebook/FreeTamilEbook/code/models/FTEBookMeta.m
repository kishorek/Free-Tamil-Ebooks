//
//  FTEBookMeta.m
//  FreeTamilEbook
//
//  Created by Kishore on 22/1/14.
//  Copyright (c) 2014 KishoreK. All rights reserved.
//

#import "FTEBookMeta.h"

@implementation FTEBookMeta

-(instancetype) initWithMetaData:(NSDictionary *) dict{
    if (self == [super init]) {
        self.title = [dict objectForKey:@"title"];
        self.imagePath = [dict objectForKey:@"image"];
        self.epubLink = [dict objectForKey:@"epub"];
        self.imageHeight = [[dict objectForKey:@"image-height"] intValue];
        self.imageWidth = [[dict objectForKey:@"image-width"] intValue];
        self.bookId = [dict objectForKey:@"bookid"];
        self.author = [dict objectForKey:@"author"];
    }
    return self;
}

-(BOOL)isEqual:(id)object{
    if ([object isKindOfClass:[FTEBookMeta class]]) {
        FTEBookMeta *tObj = (FTEBookMeta *) object;
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
    [encoder encodeObject:self.publishedDate forKey:@"publishedDate"];
    [encoder encodeObject:self.title forKey:@"title"];
    [encoder encodeObject:self.imagePath forKey:@"imagePath"];
    [encoder encodeObject:self.epubLink forKey:@"epubLink"];
    [encoder encodeObject:self.pdfLink forKey:@"pdfLink"];
    [encoder encodeObject:self.webLink forKey:@"webLink"];
    [encoder encodeObject:self.category forKey:@"category"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if (self) {
        self.publishedDate = [decoder decodeObjectForKey:@"publishedDate"];
        self.title = [decoder decodeObjectForKey:@"title"];
        self.imagePath = [decoder decodeObjectForKey:@"imagePath"];
        self.epubLink = [decoder decodeObjectForKey:@"epubLink"];
        self.pdfLink = [decoder decodeObjectForKey:@"pdfLink"];
        self.webLink = [decoder decodeObjectForKey:@"webLink"];
        self.category = [decoder decodeObjectForKey:@"category"];
    }
    return self;
}

@end
