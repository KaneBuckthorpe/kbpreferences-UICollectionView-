//
//  KBCollectionCell.m
//  ReordableUICollectionView
//
//  Created by kane buckthorpe on 30/09/2018.
//  Copyright © 2018 kane buckthorpe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KBCollectionCell.h"


@implementation KBCollectionCell
- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = UIColor.clearColor;
        self.contentView.backgroundColor = UIColor.whiteColor;
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOffset = CGSizeMake(0, 0);
        self.layer.shadowRadius = 2.0f;
        self.layer.shadowOpacity = 1.0f;
        self.layer.masksToBounds = NO;
        self.contentView.layer.masksToBounds = YES;
        
        ////Setting up main label
self.label = [[UILabel alloc]
            initWithFrame:CGRectMake(15, 0, frame.size.width - 30,
                                     frame.size.height)];
self.label.adjustsFontSizeToFitWidth = YES;
        self.label.minimumScaleFactor = 0;
        self.label.numberOfLines = 0;
        [self.label setFont:[UIFont fontWithName:@".SFUIDisplay-Bold" size:100]];
        self.label.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);

        [self.contentView addSubview:self.label];
    }
    return self;
}
@end