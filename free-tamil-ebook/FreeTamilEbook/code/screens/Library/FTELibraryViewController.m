//
//  FTELibraryViewController.m
//  FreeTamilEbook
//
//  Created by Kishore on 22/1/14.
//  Copyright (c) 2014 KishoreK. All rights reserved.
//

#import "FTELibraryViewController.h"
#import "FTEBookMetaCell.h"
#import "FTEShopViewController.h"
#import "FTESettingsViewController.h"

@interface FTELibraryViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property(nonatomic, strong) NSMutableArray *downloadedBooks;
@property(nonatomic, strong) FTEBookMeta *currentBook;

@property(nonatomic, assign) BOOL loadLastBook;

@end

@implementation FTELibraryViewController

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
    if (appDelegate.booksDB.currentBook != nil) {
        self.loadLastBook = YES;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (self.loadLastBook) {
        [self performSegueWithIdentifier:@"LibraryToBookView" sender:self];
    } else {
        //Reset the book
        appDelegate.booksDB.currentBook = nil;
    }
    [self loadBooks];
}

#pragma mark - Custom
-(void) loadBooks{
    appDelegate.booksDB.downloadedBooks = downloadedBooks();
    self.downloadedBooks = [NSMutableArray array];
    for (FTEBookMeta *meta in appDelegate.booksDB.downloadedBooks) {
        if ([appDelegate.booksDB.availableBooks containsObject:meta]) {
            NSInteger index = [appDelegate.booksDB.availableBooks indexOfObject:meta];
            FTEBookMeta *fullMeta = [appDelegate.booksDB.availableBooks objectAtIndex:index];
            [self.downloadedBooks addObject:fullMeta];
        }
    }
    
    if (isNightModeOn()) {
        self.collectionView.backgroundColor = [UIColor blackColor];
    } else {
        self.collectionView.backgroundColor = [UIColor whiteColor];
    }
    
    [self.collectionView reloadData];
    if (self.downloadedBooks.count == 0) {
        self.emptyTextLabel.hidden = NO;
        if (isNightModeOn()) {
            self.emptyTextLabel.textColor = [UIColor whiteColor];
        } else {
            self.emptyTextLabel.textColor = [UIColor blackColor];
        }
    } else {
        self.emptyTextLabel.hidden = YES;
    }
}

#pragma mark - CollectionView Datasource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.downloadedBooks.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    FTEBookMetaCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BookMetaCell" forIndexPath:indexPath];
    [cell setBookMetaInfo:self.downloadedBooks[indexPath.row]];
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
    //[self downloadBook:self.downloadedBooks[indexPath.row]];
    self.currentBook = self.downloadedBooks[indexPath.row];
    [self performSegueWithIdentifier:@"LibraryToBookView" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"LibraryToBookView"]) {
        if (appDelegate.booksDB.currentBook == nil) {
            appDelegate.booksDB.currentBook = parseBook(self.currentBook.bookId);
        }
        self.loadLastBook = NO;
    } else if([segue.identifier isEqualToString:@"LibraryToSettings" ]){
        UINavigationController *navC = [segue destinationViewController];
        FTESettingsViewController *vc = navC.viewControllers[0];
        vc.action = ^{
            [self dismissViewControllerAnimated:YES completion:^{
                [self loadBooks];
                setNightModeForNavigationController(self.navigationController);
            }];
        };
    }  else if([segue.identifier isEqualToString:@"LibraryToShop" ]){
        UINavigationController *navC = [segue destinationViewController];
        FTEShopViewController *vc = navC.viewControllers[0];
        vc.action = ^{
            [self dismissViewControllerAnimated:YES completion:^{
                [self loadBooks];
            }];
        };
    }
}

@end
