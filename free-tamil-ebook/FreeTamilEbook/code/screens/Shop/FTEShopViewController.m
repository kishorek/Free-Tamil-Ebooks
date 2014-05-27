//
//  FTEShopViewController.m
//  FreeTamilEbook
//
//  Created by Kishore on 22/1/14.
//  Copyright (c) 2014 KishoreK. All rights reserved.
//

#import "FTEShopViewController.h"
#import "FTEBookMeta.h"
#import "FTEBookMetaCell.h"
#import "XMLDictionary.h"
#import "AFNetworking.h"

static NSString * const xmlDBPath = @"https://raw.githubusercontent.com/kishorek/Free-Tamil-Ebooks/master/booksdb.xml";

@interface FTEShopViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIAlertViewDelegate>

@property(nonatomic, strong) NSMutableArray *availableBooks;
@property(nonatomic, strong) FTEBookMeta *chosenBook;

@end

@implementation FTEShopViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.availableBooks = appDelegate.booksDB.availableBooks;
    [self.collectionView reloadData];
    
    [self loadAvailableBooks];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (isNightModeOn()) {
        self.collectionView.backgroundColor = [UIColor blackColor];
    } else {
        self.collectionView.backgroundColor = [UIColor whiteColor];
    }
    
    [self.collectionView reloadData];
}

#pragma mark - CollectionView Datasource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.availableBooks.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    FTEBookMetaCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BookMetaCell" forIndexPath:indexPath];
    [cell setBookMetaInfo:self.availableBooks[indexPath.row]];
    if ([appDelegate.booksDB.downloadedBooks containsObject:self.availableBooks[indexPath.row]]) {
        cell.downloadIndicator.hidden = YES;
    } else {
        cell.downloadIndicator.hidden = YES;
    }
    return cell;
}

#pragma mark - CollectionView Flow Layout Delegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (isiPad()) {
        return CGSizeMake(150, 225);
    } else {
        return CGSizeMake(145, 180);
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    if (isiPad()) {
        return UIEdgeInsetsMake(15, 10, 10, 10);
    } else {
        return UIEdgeInsetsMake(10, 5, 10, 10);
    }
}

#pragma mark - CollectionView Delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (![appDelegate.booksDB.downloadedBooks containsObject:self.availableBooks[indexPath.row]]) {
        self.chosenBook =self.availableBooks[indexPath.row];
        //[self downloadBook:self.availableBooks[indexPath.row]];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"%@\n%@",self.chosenBook.title,self.chosenBook.author] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Download",nil];
        [alert show];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"This book is already downloaded!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    
}

#pragma mark - Action 
- (IBAction)closeTapped:(id)sender {
    if (self.action) {
        self.action();
    }
}
#pragma mark - UIAlertview
-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        [self downloadBook:self.chosenBook];
    }
}

#pragma mark - Custom
-(void) downloadBook:(FTEBookMeta *) book{
    //Download Stuff
    if (isNotNull(book.epubLink)) {
        NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:book.epubLink]];
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:req];
        NSString *downloadPath = [booksDownloadTempPath() stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.epub",book.bookId]];
        NSOutputStream *outputstream = [NSOutputStream outputStreamToFileAtPath:downloadPath append:YES];
        [operation setOutputStream:outputstream];
        [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
            float progress = (float) totalBytesRead/totalBytesExpectedToRead;
            if (progress > 0) {
                [SVProgressHUD showProgress:progress status:[NSString stringWithFormat:@"Downloading \n %0.2f%%",progress*100] maskType:SVProgressHUDMaskTypeBlack];
            } else {
                [SVProgressHUD showProgress:progress status:@"Downloading..." maskType:SVProgressHUDMaskTypeBlack];
            }
        }];
        
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            if ([operation.response statusCode] == 200) {
                [self moveBook:downloadPath withBookId:book.bookId];
                unzipEbook([NSString stringWithFormat:@"%@.epub",book.bookId]);
                addBookToDB(book);
                [self.collectionView reloadData];
                [SVProgressHUD showSuccessWithStatus:@"Book Downloaded!"];
            } else {
                [SVProgressHUD showErrorWithStatus:@"Some error occurred :( \n Try again Later!"];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"Some error occurred :( \n Try again Later!"];
        }];
        
        [SVProgressHUD showProgress:0 status:@"Downloading..." maskType:SVProgressHUDMaskTypeBlack];
        [operation start];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Free Tamil Ebooks" message:@"This book is not available for download at this moment. \nTry again later!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

-(void) moveBook:(NSString *) filePath withBookId:(NSString *) bookId{
    NSString *libPath = [booksDownloadPath() stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.epub",bookId]];;
    NSFileManager *fm = [NSFileManager defaultManager];
    NSError *error;
    [fm moveItemAtPath:filePath toPath:libPath error:&error];
    //[fm addSkipBackupAttributeToItemAtURL:[NSURL fileURLWithPath:filePath isDirectory:NO]];
}

-(void) loadAvailableBooks{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *URL = [NSURL URLWithString:xmlDBPath];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL cachePolicy:NSURLCacheStorageNotAllowed timeoutInterval:10.0];
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        NSURL *documentsDirectoryPath = [NSURL fileURLWithPath:[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]];
        return [documentsDirectoryPath URLByAppendingPathComponent:@"booksdb.xml"];//[response suggestedFilename]];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        [SVProgressHUD dismiss];
        
        NSURL *documentsDirectoryPath = [NSURL fileURLWithPath:[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]];
        [[NSFileManager defaultManager] addSkipBackupAttributeToItemAtURL:[documentsDirectoryPath URLByAppendingPathComponent:@"booksdb.xml"]];
        
        [self reloadDownladedBooksList];
    }];
    [downloadTask resume];
}

-(void) reloadDownladedBooksList{
    loadAvailableBooks();
    [self.collectionView reloadData];
}

@end