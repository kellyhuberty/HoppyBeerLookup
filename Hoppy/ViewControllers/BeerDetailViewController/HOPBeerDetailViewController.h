//
//  BeerDetailTableViewController.h
//  Hoppy
//
//  Created by Kelly Huberty on 12/15/18.
//  Copyright © 2018 Kelly Huberty. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol BeerFullDisplayable;
@protocol BeerShortDisplayable;
@class BeerUpdater;



NS_ASSUME_NONNULL_BEGIN

/**
 HOPBeerDetailViewController is used to display the in-detail content of a beer. To retrieve the full beer data, a `BeerUpdater` is used to
 update the beer to a `BeerFullDisplayable`.

 Because the use of a beer updater is required this is required by initialization. Because of this, `initWithUpdater:` is the designated
 initailizer and all other init methods are marked as unavailable.
 
 */
NS_SWIFT_NAME(BeerDetailViewController)
@interface HOPBeerDetailViewController : UIViewController

///The beer retrieved from the beer updater, once the update process is complete.
@property (nonatomic, nullable, readonly)id<BeerFullDisplayable> fullBeerDisplayable;

///The beer updater injected.
@property (nonatomic, strong)BeerUpdater * updater;


-(instancetype)initWithUpdater:(nonnull BeerUpdater *)updater NS_DESIGNATED_INITIALIZER NS_SWIFT_NAME(init(updater:));

/**
 Marking all other init methods as unavailable as this view controller needs to be injected with a BeerUpdater
 */
-(instancetype)init NS_UNAVAILABLE;
-(instancetype)initWithNibName:(nullable NSString *)nibNameOrNil bundle:(nullable NSBundle *)nibBundleOrNil NS_UNAVAILABLE;
-(instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
