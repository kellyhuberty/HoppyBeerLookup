//
//  HOPBeerDetailView.m
//  Hoppy
//
//  Created by Kelly Huberty on 12/18/18.
//  Copyright © 2018 Kelly Huberty. All rights reserved.
//

#import "HOPBeerDetailView.h"

#import "Hoppy-Swift.h"


#pragma mark - interface
@interface HOPBeerDetailView () {
//main stack view
    UIStackView * _stackView;

//other layout components
    UIImageView * _imageView;
    UILabel * _titleLabel;
    UILabel * _subtitleLabel;
    UILabel * _descriptionLabel;

// stats
    UIStackView * _statsStackView;
    UILabel * _ibuLabel;
    UILabel * _abvLabel;

// The loaded beer itself.
    id<BeerFullDisplayable> _beerDisplayable;
}



@end

@implementation HOPBeerDetailView

#pragma mark - init
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    [self setupLayout];
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    [self setupLayout];
    return self;
}

#pragma mark - public properties
-(nullable id<BeerFullDisplayable>)beerDisplayable{
    return _beerDisplayable;
}

#pragma mark - setup layout
/**
 Sets up the layout and view heiracy of the view.
 */
-(void)setupLayout{
    
    
// Layout stack view load
    _stackView = [[UIStackView alloc]init];
    _stackView.translatesAutoresizingMaskIntoConstraints = false;
    
    _stackView.alignment = UIStackViewAlignmentFill;
    _stackView.distribution = UIStackViewDistributionEqualSpacing;
    _stackView.axis = UILayoutConstraintAxisVertical;
    _stackView.spacing = 16;
    
//Stats stack view
    _statsStackView = [[UIStackView alloc]init];
    _statsStackView.translatesAutoresizingMaskIntoConstraints = false;
    
    _statsStackView.alignment = UIStackViewAlignmentFill;
    _statsStackView.distribution = UIStackViewDistributionFillEqually;
    _statsStackView.axis = UILayoutConstraintAxisHorizontal;
    
//imageView
    _imageView = [[UIImageView alloc]init];
    _imageView.translatesAutoresizingMaskIntoConstraints = false;
    _imageView.backgroundColor = [UIColor lightGrayColor];
    
    [self addSubview:_imageView];
    [self addSubview:_stackView];

//Adding layout constraints.
    [NSLayoutConstraint activateConstraints:@[
      //ImageViewConstraints
                                              
          [_imageView.topAnchor constraintEqualToAnchor:self.topAnchor],
          [_imageView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
          [_imageView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
          [_imageView.heightAnchor constraintEqualToConstant:240],

      //StackView layout
          [_stackView.topAnchor constraintEqualToAnchor:_imageView.bottomAnchor constant:10],
          [_stackView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor],
          [_stackView.leadingAnchor constraintEqualToAnchor:self.layoutMarginsGuide.leadingAnchor],
          [_stackView.trailingAnchor constraintEqualToAnchor:self.layoutMarginsGuide.trailingAnchor]
    ]];
    
    
    
    //subtitle
    _subtitleLabel = [[UILabel alloc]init];
    _subtitleLabel.font = [UIFont fontWithName:@"HoeflerText-BlackItalic" size:18];
    _subtitleLabel.translatesAutoresizingMaskIntoConstraints = false;
    [_stackView addArrangedSubview:_subtitleLabel];
    
    //title
    _titleLabel = [[UILabel alloc]init];
    _titleLabel.numberOfLines = 0;
    _titleLabel.font = [UIFont fontWithName:@"Superclarendon-Bold" size:36];
    _titleLabel.translatesAutoresizingMaskIntoConstraints = false;
    [_stackView addArrangedSubview:_titleLabel];
    

    //Stats
    [_stackView addArrangedSubview:_statsStackView];
    
    
    //Description
    _descriptionLabel = [[UILabel alloc]init];
    _descriptionLabel.font = [UIFont fontWithName:@"TimesNewRomanPSMT" size:16];
    _descriptionLabel.translatesAutoresizingMaskIntoConstraints = false;
    _descriptionLabel.numberOfLines = 0;
    [_stackView addArrangedSubview:_descriptionLabel];
    
    //Socail Media URL
    
    _socialMediaUrlButton = [[UIButton alloc]init];
    [_socialMediaUrlButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    _socialMediaUrlButton.translatesAutoresizingMaskIntoConstraints = false;
    [_stackView addArrangedSubview:_socialMediaUrlButton];
    
    
    //Stats Labels
    _ibuLabel = [[UILabel alloc]init];
    _ibuLabel.numberOfLines = 1;
    _ibuLabel.font = [UIFont fontWithName:@"Futura" size:18];
    _ibuLabel.translatesAutoresizingMaskIntoConstraints = false;
    _ibuLabel.textAlignment = NSTextAlignmentCenter;
    
    _abvLabel = [[UILabel alloc]init];
    _abvLabel.numberOfLines = 1;
    _abvLabel.font = [UIFont fontWithName:@"Futura" size:18];
    _abvLabel.translatesAutoresizingMaskIntoConstraints = false;
    _abvLabel.textAlignment = NSTextAlignmentCenter;

//Adding to stats stack view.
    [_statsStackView addArrangedSubview:_ibuLabel];
    [_statsStackView addArrangedSubview:_abvLabel];

}

#pragma mark - Public methods.

-(void)showError:(NSError *)error{
    [self clearAll];
    _subtitleLabel.text = NSLocalizedString(@"Error Loading Beer", @"Error loading beer title");
}

-(void)showLoading{
    [self clearAll];
    _subtitleLabel.text = NSLocalizedString(@"Loading...", @"Loading w/ ellipsis");
}

-(void)showFullBeer:(id<BeerFullDisplayable>)beer{
    
    [self clearAll];
    
    if( beer.largeIconURL != nil ) {
        [_imageView setImageFromURL:beer.largeIconURL];
    }else if ( beer.mediumIconURL != nil ) {
        [_imageView setImageFromURL:beer.mediumIconURL];
    }else if ( beer.iconURL != nil ) {
        [_imageView setImageFromURL:beer.iconURL];
    }
    
    _titleLabel.text = beer.name;
    _subtitleLabel.text = beer.breweryName;
    
    if ( beer.description.length > 0 ){
        _descriptionLabel.text = beer.description;
    }else{
        _descriptionLabel.text = NSLocalizedString(@"No Description Availiable", @"NO DESCRIPTION");
    }
    
    if ( beer.ibu.length > 0 ){
        _ibuLabel.text = [NSString stringWithFormat:@"%@ %@", beer.ibu, NSLocalizedString(@"IBU", @"IBU")];
    } else {
        _ibuLabel.text = NSLocalizedString(@"-- IBU", @"IBU N/A");
    }
    
    if ( beer.abv.length > 0 ){
        _abvLabel.text = [NSString stringWithFormat:@"%@ %@ %@", beer.abv, @"%" , NSLocalizedString(@"ABV", @"ABV")];
    } else {
        _abvLabel.text = NSLocalizedString(@"-- ABV", @"ABV N/A");
    }

    if ( beer.links.firstObject != nil){
        [_socialMediaUrlButton setTitle:beer.links.firstObject.urlString forState:UIControlStateNormal];
        _socialMediaUrlButton.hidden = false;
    }
    
}

#pragma mark - utility
///Clears all current data from the view set by the public messages.
-(void)clearAll{
    _beerDisplayable = nil;
    _imageView.image = nil;
    _titleLabel.text = nil;
    _subtitleLabel.text = nil;
    _descriptionLabel.text = nil;
    _ibuLabel.text = nil;
    _abvLabel.text = nil;
    [_socialMediaUrlButton setTitle:nil forState:UIControlStateNormal];
    _socialMediaUrlButton.hidden = true;
}

@end
