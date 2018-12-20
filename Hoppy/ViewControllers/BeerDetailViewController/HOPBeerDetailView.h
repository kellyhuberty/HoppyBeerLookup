//
//  HOPBeerDetailView.h
//  Hoppy
//
//  Created by Kelly Huberty on 12/18/18.
//  Copyright © 2018 Kelly Huberty. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol BeerFullDisplayable;

NS_ASSUME_NONNULL_BEGIN
/**
 The `HOPBeerDetailView` contains the display logic of the `HOPBeerDetailViewController`, but also can
 be used stand alone if used outside of that view controller.
 */
@interface HOPBeerDetailView : UIView

@property(nonatomic, readonly, nullable)UIButton * socialMediaUrlButton;

///The beer being displayed, if any.
@property(nonatomic, readonly, nullable)id<BeerFullDisplayable> beerDisplayable;

///Displays an error to the user if found.
-(void)showError:(NSError *)error;

///Displays a loading message.
-(void)showLoading;

///loads the beer into the labels within the view.
-(void)showFullBeer:(id<BeerFullDisplayable>)beer;


@end

NS_ASSUME_NONNULL_END
