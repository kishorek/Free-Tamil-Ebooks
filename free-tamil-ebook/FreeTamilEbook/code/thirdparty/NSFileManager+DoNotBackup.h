//
//  NSFileManager+DoNotBackup.h
//  HinEngDictionary
//
//  Created by Kishore Kumar on 21/3/13.
//  Copyright (c) 2013 @KishoreK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSFileManager (DoNotBackup)

- (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL;

@end
