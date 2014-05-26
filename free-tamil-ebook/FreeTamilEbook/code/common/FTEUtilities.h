//
//  FTEUtilities.h
//  FreeTamilEbook
//
//  Created by Kishore on 21/1/14.
//  Copyright (c) 2014 KishoreK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FTEAppDelegate.h"
#import "FTEBook.h"
#import "FTEBookMeta.h"
#import "FTEBooksDB.h"
#import "SVProgressHUD.h"
#import "FTEBaseViewController.h"
#import "NSFileManager+DoNotBackup.h"

extern FTEAppDelegate *appDelegate;

/* Paths */
BOOL isBooksDBCached();
NSString *booksDownloadPath();
NSString *booksDownloadTempPath();
NSString *booksPath();
NSString *booksPathForId(NSString *bookId);
NSString *booksDownloadPathForId(NSString *bookId);
NSString *booksDBPath();
NSString *cssPath(NSString *basePath);
NSString *imagePath(NSString *basePath);

/* Utils */
BOOL unzipEbook(NSString *book);
FTEBook *parseBook(NSString *bookId);
BOOL isBookDownloaded(NSString *bookId);
NSMutableArray *downloadedBooks();
NSString *pageContent(NSString *bookId,NSString *path);
NSURLRequest *pageRequest(NSString *bookId,NSString *path);
void loadAvailableBooks();

/* Local DB */
void addBookToDB(FTEBookMeta *book);
void deleteBookFromDB(FTEBookMeta *book);
void resetCache();

BOOL isNightModeOn();
void turnNightModeOn(UINavigationController *navC);
void turnNightModeOff(UINavigationController *navC);
void prepareNightModeSettings();
void setNightModeForNavigationController(UINavigationController *navC);

BOOL isNotNull(id obj);

BOOL isiPad();

@interface FTEUtilities : NSObject

/* Prepare */
//-(NSString *) massageHTMLString:(NSString *) htmlString;

@end
