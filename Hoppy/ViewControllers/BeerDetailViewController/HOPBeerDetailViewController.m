//
//  BeerDetailTableViewController.m
//  Hoppy
//
//  Created by Kelly Huberty on 12/15/18.
//  Copyright © 2018 Kelly Huberty. All rights reserved.
//

#import "HOPBeerDetailViewController.h"
#import "HOPBeerDetailView.h"
#import "Hoppy-Swift.h"


@interface HOPBeerDetailViewController () <BeerUpdaterDelegate> {

    ///Scroll View used.
    UIScrollView * _scrollView;
    
    ///View embedded into the scroll view to display beer data.
    HOPBeerDetailView * _beerDetailView;
    
}
@end

@implementation HOPBeerDetailViewController

#pragma mark init
-(instancetype)initWithUpdater:(nonnull BeerUpdater *)updater{
    
    self = [super initWithNibName:nil bundle:nil];
    
    _updater = updater;
    updater.delegate = self;
    
    return self;
    
}

//just in case someone gets smart, trys to use a dynamic way to call this, I shut down all other inits here.
-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    NSAssert(NO, @"Subclasses must init with `initWithUpdater:`");
    return nil;
}

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    NSAssert(NO, @"Subclasses must init with `initWithUpdater:`");
    return nil;
}

#pragma mark lifecycle
-(void)loadView{
    _scrollView = [[UIScrollView alloc]init];
    _scrollView.backgroundColor = [UIColor whiteColor];
    
    self.view = _scrollView;
    
    _beerDetailView = [[HOPBeerDetailView alloc] init];
    
    _beerDetailView.translatesAutoresizingMaskIntoConstraints = false;
    
    [_scrollView addSubview:_beerDetailView];
    
    [NSLayoutConstraint activateConstraints:@[
                                              
        //Constrain UIScrollView
        [_scrollView.contentLayoutGuide.topAnchor constraintEqualToAnchor:_beerDetailView.topAnchor],
        [_scrollView.contentLayoutGuide.bottomAnchor constraintEqualToAnchor:_beerDetailView.bottomAnchor],
        [_scrollView.frameLayoutGuide.widthAnchor constraintEqualToAnchor:_beerDetailView.widthAnchor],
    ]];
    
    [_beerDetailView.socialMediaUrlButton addTarget:self action:@selector(socialMediaUrlButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    id<BeerFullDisplayable> updatedBeer = _updater.updatedBeer;
    
    if (updatedBeer != nil) {
        [_beerDetailView showFullBeer:updatedBeer];
    }
    
}

#pragma mark - HOPBeerUpdaterDelegate methods.

- (void)beerUpdater:(BeerUpdater * _Nonnull)beerUpdater finishedWith:(NSError * _Nonnull)error {
    [_beerDetailView showError:error];
}

- (void)beerUpdaterDidBegin:(BeerUpdater * _Nonnull)beerUpdater {
    [_beerDetailView showLoading];
}

- (void)beerUpdaterDidFinish:(BeerUpdater * _Nonnull)beerUpdater {
    [_beerDetailView showFullBeer:beerUpdater.updatedBeer];    
}


#pragma mark Button action method

/// performs the action of the socialMediaUrlButton
-(void)socialMediaUrlButtonAction:(UIButton *)sender{
    
    NSString * urlString = [sender titleForState:UIControlStateNormal];
    NSURL * url = [NSURL URLWithString:urlString];
    [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
    
}

@end
