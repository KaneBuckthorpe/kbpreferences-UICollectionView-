//
//  KBHeaderView.m
//  ReordableUICollectionView
//
//  Created by kane buckthorpe on 30/09/2018.
//  Copyright © 2018 kane buckthorpe. All rights reserved.
//

#import "KBHeaderView.h"
#import <Foundation/Foundation.h>

@implementation KBHeaderView
- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = UIColor.whiteColor;
        self.label = [[UILabel alloc]
            initWithFrame:CGRectMake(20, 0, frame.size.width - 40,
                                     frame.size.height)];
        self.label.adjustsFontSizeToFitWidth = YES;
        self.label.minimumScaleFactor = 0;
        self.label.numberOfLines = 0;
        [self.label setFont:[UIFont fontWithName:@".SFUIDisplay-Bold" size:200]];
        self.label.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);

        [self addSubview:self.label];

        self.label.textColor = UIColor.blackColor;
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOffset = CGSizeMake(0.0f, 1.5f);
        self.layer.shadowRadius = 0.75f;
        self.layer.shadowOpacity = 1.0f;
        self.layer.masksToBounds = NO;
        self.layer.zPosition = 1;
    }
    return self;
}
@end