//
//  FTEBookViewController.m
//  FreeTamilEbook
//
//  Created by Kishore on 21/1/14.
//  Copyright (c) 2014 KishoreK. All rights reserved.
//

#import "FTEBookViewController.h"
#import "XMLDictionary.h"
#import "FTESettingsViewController.h"

@interface FTEBookViewController ()<UIWebViewDelegate,UIGestureRecognizerDelegate, UIScrollViewDelegate,UIDocumentInteractionControllerDelegate>

@property(nonatomic, assign) NSInteger currentPage;
@property(nonatomic, assign) CGPoint lastLocation;
@property(nonatomic, strong) UIButton *nextBtn;
@property(nonatomic, strong) UITapGestureRecognizer *tap;
@property(nonatomic, strong) UIActivityIndicatorView *spinner;

@property (nonatomic, strong) UIDocumentInteractionController *docInteractionController;

- (IBAction)actionsTapped:(id)sender;

@end

@implementation FTEBookViewController

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
    
    self.bookView.delegate = self;
    self.bookView.scrollView.delegate = self;
    //self.automaticallyAdjustsScrollViewInsets = NO;
    
    if (appDelegate.booksDB.currentBook.currentPage > 0) {
        self.currentPage = appDelegate.booksDB.currentBook.currentPage;
        self.lastLocation = CGPointFromString(appDelegate.booksDB.currentBook.currentLocation);
        
    } else {
        self.currentPage = 0;
    }
    self.title = appDelegate.booksDB.currentBook.title;
    [self loadPage];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
    tap.delegate = self;
    tap.numberOfTapsRequired = 1;
    [self.bookView addGestureRecognizer:tap];
    self.tap = tap;
    
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapped:)];
    tap2.delegate = self;
    [tap requireGestureRecognizerToFail:tap2];
    tap2.numberOfTapsRequired = 2;
    [self.bookView addGestureRecognizer:tap2];
    
    UILongPressGestureRecognizer *tap3 = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapped:)];
    tap2.delegate = self;
    [tap3 requireGestureRecognizerToFail:tap];
    [self.bookView addGestureRecognizer:tap3];
    
    if (isNightModeOn()) {
        self.bookView.backgroundColor = [UIColor blackColor];
    } else {
        self.bookView.backgroundColor = [UIColor whiteColor];
    }
    
    [self setupExtraButtons];
}

- (void)setupDocumentControllerWithURL:(NSURL *)url
{
    if (self.docInteractionController == nil)
    {
        self.docInteractionController = [UIDocumentInteractionController interactionControllerWithURL:url];
        self.docInteractionController.delegate = self;
    }
    else
    {
        self.docInteractionController.URL = url;
    }
}

-(void) setupExtraButtons{
    self.nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.nextBtn setBackgroundColor:[UIColor redColor]];
    self.nextBtn.frame = CGRectMake(0, self.view.frame.size.height-40, self.view.frame.size.width, 40);
    
    [self.nextBtn setImage:[UIImage imageNamed:@"next"] forState:UIControlStateNormal];
    [self.nextBtn setBackgroundColor:[UIColor colorWithWhite:0.500 alpha:0.520]];
    [self.nextBtn setHidden:YES];
    [self.nextBtn addTarget:self action:@selector(loadNextPage) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.nextBtn];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setToolbarHidden:NO];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setToolbarHidden:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"BookViewToSettings"]) {
        UINavigationController *navC = [segue destinationViewController];
        FTESettingsViewController *vc = navC.viewControllers[0];
        vc.hideResetOption = YES;
        vc.action = ^{
            [self dismissViewControllerAnimated:YES completion:^{
                setNightModeForNavigationController(self.navigationController);
                [self prepareNightMode];
            }];
        };
    }
}

#pragma mark - Custom
-(void) initGestures{
    UISwipeGestureRecognizer *swipeLeftGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeft:)];
    swipeLeftGesture.delegate = self;
    [swipeLeftGesture setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self.bookView addGestureRecognizer:swipeLeftGesture];
    
    UISwipeGestureRecognizer *swipeRightGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRight:)];
    swipeRightGesture.delegate = self;
    [swipeRightGesture setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.bookView addGestureRecognizer:swipeRightGesture];
}

-(void) loadPage {
    appDelegate.booksDB.currentBook.currentPage = self.currentPage;
    
    NSString *firstContent = [appDelegate.booksDB.currentBook.toc objectAtIndex:self.currentPage];
    NSString *firstPath = [appDelegate.booksDB.currentBook.availablePages objectForKey:firstContent];
    [self.bookView loadRequest:pageRequest(appDelegate.booksDB.currentBook.bookId, firstPath)];
}

-(void) retrieveFromCache{
    self.currentPage = appDelegate.booksDB.currentBook.currentPage;
    [self loadPage];
    
    self.lastLocation = CGPointFromString(appDelegate.booksDB.currentBook.currentLocation);
}

-(void) loadNextPage {
    if (self.currentPage < appDelegate.booksDB.currentBook.toc.count-1) {
        self.currentPage++;
        [self loadPage];
    }
}

-(void) loadPreviousPage {
    if (self.currentPage > 0) {
        self.currentPage--;
        [self loadPage];
    }
}

-(void) prepareNightMode{
    if (isNightModeOn()) {
        [self.bookView stringByEvaluatingJavaScriptFromString:@"document.body.style.background = '#000';"];
        [self.bookView stringByEvaluatingJavaScriptFromString:@"document.body.style.color = '#fff';"];
        self.bookView.backgroundColor = [UIColor blackColor];
    } else {
        [self.bookView stringByEvaluatingJavaScriptFromString:@"document.body.style.background = '#fff';"];
        [self.bookView stringByEvaluatingJavaScriptFromString:@"document.body.style.color = '#000';"];
        self.bookView.backgroundColor = [UIColor whiteColor];
    }
}

#pragma mark - WebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView{
    if (isNightModeOn()) {
        self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    } else {
        self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    }
    
    self.spinner.center = self.view.center;
    [self.spinner startAnimating];
    [self.view addSubview:self.spinner];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
 //   [webView stringByEvaluatingJavaScriptFromString:@"var images = document.getElementsByTagName('img'); for(i=0;i<images.length;i++){var imgs = images[i]; alert(imgs.style.width); imgs.style.width = '80%'; };"];
    
    [webView stringByEvaluatingJavaScriptFromString:@"var images = document.images; for(i=0;i<images.length;i++){var imgs = images[i]; if(imgs.width > 300) { imgs.setAttribute('width','80%');} };"];
    //[webView stringByEvaluatingJavaScriptFromString:@"document.body.style.fontSize = '20px'"];
    
    if (self.lastLocation.y!=0) {
        webView.scrollView.contentOffset = self.lastLocation;
    }
    if (isNightModeOn()) {
        [webView stringByEvaluatingJavaScriptFromString:@"document.body.style.background = '#000';"];
        [webView stringByEvaluatingJavaScriptFromString:@"document.body.style.color = '#fff';"];
    }
    
    [self.spinner stopAnimating];
    [self.spinner removeFromSuperview];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    //NSLog(@"failed %@",error);
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if (navigationType == UIWebViewNavigationTypeOther) {
        return YES;
    }
    return NO;
}

#pragma mark - ScrollView
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    appDelegate.booksDB.currentBook.currentLocation = NSStringFromCGPoint(scrollView.contentOffset);
    [self performSelector:@selector(enableGesture) withObject:nil afterDelay:0.5];
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    self.tap.enabled = NO;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    
    CGFloat topInset = -scrollView.contentInset.top;
    
    CGFloat scrollViewHeight = scrollView.bounds.size.height;
    CGFloat scrollContentSizeHeight = scrollView.contentSize.height;
    CGFloat bottomInset = scrollView.contentInset.bottom;
    CGFloat scrollViewBottomOffset = scrollContentSizeHeight + bottomInset - scrollViewHeight;
    if ((scrollView.contentOffset.y >= scrollViewBottomOffset)) {
        //NSLog(@"At bottom");
        self.nextBtn.hidden = NO;
    } else {
        self.nextBtn.hidden = YES;
    }
    
    if ((scrollView.contentOffset.y <= topInset)) {
        //NSLog(@"At top");
        //self.tap.enabled = YES;
    } else {
        //self.tap.enabled = NO;
    }
}

-(void) enableGesture{
    self.tap.enabled = YES;
}

#pragma mark - Gestures
-(void) swipeLeft:(UIGestureRecognizer *) gesture{
    [self loadNextPage];
}

-(void) swipeRight:(UIGestureRecognizer *) gesture{
    [self loadPreviousPage];
}

-(void) tapped:(UIGestureRecognizer *) gesture{
    [self.navigationController setToolbarHidden:!self.navigationController.toolbarHidden animated:YES];
    [self.navigationController setNavigationBarHidden:self.navigationController.toolbarHidden animated:YES];
    
    if (self.navigationController.toolbarHidden) {
        [UIView animateWithDuration:0.33 animations:^{
            [self setNeedsStatusBarAppearanceUpdate];
        }];
    }
}

-(void) doubleTapped:(UIGestureRecognizer *) gesture{
    //NSLog(@"double");
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}


- (BOOL)prefersStatusBarHidden {
    return self.navigationController.navigationBarHidden;
}

- (IBAction)previousPageTapped:(id)sender {
    [self loadPreviousPage];
}

- (IBAction)nextPageTapped:(id)sender {
    [self loadNextPage];
}
- (IBAction)actionsTapped:(id)sender {
    NSURL *fileURL = [NSURL fileURLWithPath:booksDownloadPathForId(appDelegate.booksDB.currentBook.bookId)];
    [self setupDocumentControllerWithURL:fileURL];
    [self.docInteractionController presentOptionsMenuFromRect:CGRectMake(100, 100, 500, 500)
     inView:self.view
     animated:YES];
    
    //[self.docInteractionController presentOpenInMenuFromRect:CGRectMake(100, 100, 500, 500) inView:self.view animated:YES];
}
@end
