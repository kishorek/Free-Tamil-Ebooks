//
//  FTEUtilities.m
//  FreeTamilEbook
//
//  Created by Kishore on 21/1/14.
//  Copyright (c) 2014 KishoreK. All rights reserved.
//

#import "FTEUtilities.h"
#import "SSZipArchive.h"
#import "XMLDictionary.h"
#import "NSFileManager+DoNotBackup.h"

NSString *booksDownloadPath(){
    NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths firstObject];
    NSString *downloadPath = [documentsDirectory stringByAppendingPathComponent:@"/eBooks/Downloaded/"];
    NSFileManager *manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:downloadPath]) {
        NSError *error = nil;
        [manager createDirectoryAtPath:downloadPath withIntermediateDirectories:NO attributes:nil error:&error];
        //[manager addSkipBackupAttributeToItemAtURL:[NSURL fileURLWithPath:downloadPath isDirectory:YES]];
    }
    return downloadPath;
}

NSString *booksDownloadTempPath(){
    NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths firstObject];
    NSString *downloadPath = [documentsDirectory stringByAppendingPathComponent:@"/eBooks/Downloaded/temp/"];
    NSFileManager *manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:downloadPath]) {
        booksDownloadPath();
        NSError *error = nil;
        [manager createDirectoryAtPath:downloadPath withIntermediateDirectories:NO attributes:nil error:&error];
        //[manager addSkipBackupAttributeToItemAtURL:[NSURL fileURLWithPath:downloadPath isDirectory:YES]];
    }
    return downloadPath;
}

NSString *booksBasePath(){
    NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths firstObject];
    NSString *booksPath = [documentsDirectory stringByAppendingPathComponent:@"/eBooks/"];
    NSFileManager *manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:booksPath]) {
        NSError *error = nil;
        [manager createDirectoryAtPath:booksPath withIntermediateDirectories:NO attributes:nil error:&error];
        [manager addSkipBackupAttributeToItemAtURL:[NSURL fileURLWithPath:booksPath isDirectory:YES]];
    }
    return booksPath;
}

NSString *booksPath(){
    NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths firstObject];
    NSString *booksPath = [documentsDirectory stringByAppendingPathComponent:@"/eBooks/Parsed/"];
    NSFileManager *manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:booksPath]) {
        booksBasePath();
        NSError *error = nil;
        [manager createDirectoryAtPath:booksPath withIntermediateDirectories:NO attributes:nil error:&error];
        //[manager addSkipBackupAttributeToItemAtURL:[NSURL fileURLWithPath:booksPath isDirectory:YES]];
    }
    return booksPath;
}

NSString *booksPathForId(NSString *bookId){
    return [booksPath() stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.epub",bookId]];
}

NSString *booksDownloadPathForId(NSString *bookId){
    return [booksDownloadPath() stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.epub",bookId]];
}

NSString *booksDBPath(){
    NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths firstObject];
    NSString *booksDBPath = nil;
    if (booksBasePath()) {
        booksDBPath = [documentsDirectory stringByAppendingPathComponent:@"/eBooks/booksDB.plist"];
    }
    return booksDBPath;
}

NSMutableArray *downloadedBooks(){
    NSFileManager *fm = [NSFileManager defaultManager];
    NSError *error = nil;
    NSArray *files = [fm contentsOfDirectoryAtPath:booksPath() error:&error];
    if (files && !error) {
        NSMutableArray *downloadedBooks = [NSMutableArray array];
        for (NSString *file in files) {
            FTEBookMeta *meta = [[FTEBookMeta alloc] init];
            meta.bookId = [file substringToIndex:file.length-5];
            [downloadedBooks addObject:meta];
        }
        return downloadedBooks;
    }
    
    return nil;
}

BOOL isBooksDBCached(){
    NSFileManager *fm = [NSFileManager defaultManager];
    return [fm fileExistsAtPath:booksDBPath()];
}

NSString *cssPath(NSString *basePath){
    return nil;
}
    
NSString *imagePath(NSString *basePath){
    return nil;
}


BOOL unzipEbook(NSString *book){
    [SSZipArchive unzipFileAtPath:[booksDownloadPath() stringByAppendingPathComponent:book] toDestination:[booksPath() stringByAppendingPathComponent:book]];
    //[[NSFileManager defaultManager] addSkipBackupAttributeToItemAtURL:[NSURL fileURLWithPath:[booksPath() stringByAppendingPathComponent:book]]];
    return YES;
}

FTEBook *parseBook(NSString *bookId){
    NSString *bookPath = booksPathForId(bookId);
    NSString *containerPath = [bookPath stringByAppendingString:@"/META-INF/container.xml"];
    NSDictionary *containerDict = [NSDictionary dictionaryWithXMLFile:containerPath];
    NSString *opfPath = [[[containerDict objectForKey:@"rootfiles"] objectForKey:@"rootfile"] objectForKey:@"_full-path"];
    NSString *contentOpfPath = [bookPath stringByAppendingPathComponent:opfPath];
    
   /* NSString *contentOpfPath = [bookPath stringByAppendingPathComponent:@"OEBPS/content.opf"];
    
    NSFileManager *fm = [NSFileManager defaultManager];
    if (![fm fileExistsAtPath:contentOpfPath]) {
        contentOpfPath = [bookPath stringByAppendingPathComponent:@"book.opf"];
    }*/
    
    NSDictionary *contentDict = [NSDictionary dictionaryWithXMLFile:contentOpfPath];
    
    FTEBook *book = [[FTEBook alloc] initWithBookXML:contentDict];
    book.bookId = bookId;
    return book;
}

NSURLRequest *pageRequest(NSString *bookId,NSString *path){
    if ([path rangeOfString:@"OEBPS"].location == NSNotFound) {
        path = [NSString stringWithFormat:@"%@/OEBPS/%@",booksPathForId(bookId),path];
    } else {
        path = [NSString stringWithFormat:@"%@/%@",booksPathForId(bookId),path];
    }
    
    NSURL *url = [NSURL fileURLWithPath:path];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    return request;
}

NSString *pageContent(NSString *bookId,NSString *path){
    if ([path rangeOfString:@"OEBPS"].location == NSNotFound) {
        path = [NSString stringWithFormat:@"%@/OEBPS/%@",booksPathForId(bookId),path];
    } else {
        path = [NSString stringWithFormat:@"%@/%@",booksPathForId(bookId),path];
    }
    
    NSMutableString *htmlContent = [NSMutableString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    
    [htmlContent replaceOccurrencesOfString:@"src=\"../" withString:[NSString stringWithFormat:@"src=\"file://%@/OEBPS/",booksPathForId(bookId)] options:NSCaseInsensitiveSearch range:NSMakeRange(0, htmlContent.length)];
    [htmlContent replaceOccurrencesOfString:@"href=\"" withString:[NSString stringWithFormat:@"href=\"file://%@/OEBPS/",booksPathForId(bookId)] options:NSCaseInsensitiveSearch range:NSMakeRange(0, htmlContent.length)];
    [htmlContent replaceOccurrencesOfString:@"src=\"" withString:[NSString stringWithFormat:@"src=\"file://%@/OEBPS/",booksPathForId(bookId)] options:NSCaseInsensitiveSearch range:NSMakeRange(0, htmlContent.length)];
    return htmlContent;
}

BOOL isBookDownloaded(NSString *bookId){
    FTEBookMeta *book = [[FTEBookMeta alloc] init];
    return [appDelegate.booksDB.downloadedBooks containsObject:book];
}

void addBookToDB(FTEBookMeta *book){
    if (!isBookDownloaded(book.bookId)) {
        [appDelegate.booksDB.downloadedBooks addObject:book];
    }
}

void deleteBookFromDB(FTEBookMeta *book){
    if (isBookDownloaded(book.bookId)) {
        [appDelegate.booksDB.downloadedBooks removeObject:book];
    }
}

void resetCache(){
    NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths firstObject];
    NSString *downloadPath = [documentsDirectory stringByAppendingPathComponent:@"/eBooks/Downloaded/"];
    
    //NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //NSString *documentsDirectory = [paths firstObject];
    NSString *booksPath = [documentsDirectory stringByAppendingPathComponent:@"/eBooks/"];
    
    NSFileManager *fm = [NSFileManager defaultManager];
    [fm removeItemAtPath:downloadPath error:nil];
    [fm removeItemAtPath:booksPath error:nil];
}

void setNightModeForNavigationController(UINavigationController *navC){
    if (isNightModeOn()) {
        [navC.navigationBar setBarTintColor:[UIColor colorWithWhite:0.271 alpha:1.000]];
        [navC.navigationBar setTintColor:[UIColor whiteColor]];
        
        [navC.toolbar setBarTintColor:[UIColor colorWithWhite:0.271 alpha:1.000]];
        [navC.toolbar setTintColor:[UIColor whiteColor]];
        
        [navC.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    } else {
        [navC.navigationBar setBarTintColor:[UIColor whiteColor]];
        [navC.navigationBar setTintColor:[UIColor colorWithRed:0.045 green:0.422 blue:0.676 alpha:1.000]];
        
        [navC.toolbar setBarTintColor:[UIColor whiteColor]];
        [navC.toolbar setTintColor:[UIColor colorWithRed:0.045 green:0.422 blue:0.676 alpha:1.000]];
        
        [navC.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]}];
    }
}

void prepareNightModeSettings(){
    if (isNightModeOn()) {
        [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithWhite:0.271 alpha:1.000]];
        [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
        
        [[UIToolbar appearance] setBarTintColor:[UIColor colorWithWhite:0.271 alpha:1.000]];
        [[UIToolbar appearance] setTintColor:[UIColor whiteColor]];
        
        [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    } else {
        [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
        [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:0.045 green:0.422 blue:0.676 alpha:1.000]];
        
        [[UIToolbar appearance] setBarTintColor:[UIColor whiteColor]];
        [[UIToolbar appearance] setTintColor:[UIColor colorWithRed:0.045 green:0.422 blue:0.676 alpha:1.000]];
        
        [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]}];
    }
}

BOOL isNightModeOn(){
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL nightMode = NO;
    nightMode = [defaults boolForKey:@"fteNightMode"];
    return nightMode;
}

void turnNightModeOn(UINavigationController *navC){
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:YES forKey:@"fteNightMode"];
    [defaults synchronize];
    
    prepareNightModeSettings();
    setNightModeForNavigationController(navC);
}

void turnNightModeOff(UINavigationController *navC){
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:NO forKey:@"fteNightMode"];
    [defaults synchronize];
    
    prepareNightModeSettings();
    setNightModeForNavigationController(navC);
}

void loadAvailableBooks(){
    NSString *bookDBPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"/booksdb.xml"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:bookDBPath]) {
        NSDictionary *availableBooks = [NSDictionary dictionaryWithXMLFile:bookDBPath];
        NSArray *books = [availableBooks objectForKey:@"book"];
        [appDelegate.booksDB.availableBooks removeAllObjects];
        for (NSDictionary *dict in books) {
            FTEBookMeta *meta = [[FTEBookMeta alloc] initWithMetaData:dict];
            [appDelegate.booksDB.availableBooks addObject:meta];
        }
    }
}

BOOL isNotNull(id obj){
    if (obj!=[NSNull null] && obj!=nil) {
        return true;
    }
    
    return false;
}

BOOL isiPad(){
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        return YES; /* Device is iPad */
    }
    return NO;
}

@implementation FTEUtilities

@end
