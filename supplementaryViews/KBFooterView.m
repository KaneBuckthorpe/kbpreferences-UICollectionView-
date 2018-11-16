//
//  KBFooterView.m
//  ReordableUICollectionView
//
//  Created by kane buckthorpe on 30/09/2018.
//  Copyright © 2018 kane buckthorpe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KBFooterView.h"

@implementation KBFooterView
- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]){
	    self.backgroundColor=UIColor.clearColor;
        self.label = [[UILabel alloc] initWithFrame:CGRectMake(20,0,frame.size.width-40,frame.size.height)];
        self.label.textAlignment = NSTextAlignmentCenter;
        self.label.adjustsFontSizeToFitWidth = YES;
		self.label.minimumScaleFactor = 0;
		self.label.numberOfLines = 0;
		[self.label setFont:[UIFont fontWithName:@".SFUIDisplay-Bold" size:16]];
        [self addSubview:self.label];
        self.label.textColor=UIColor.blackColor;
        self.layer.masksToBounds = NO;
        self.layer.zPosition=1;
    }
    return self;
}
@end
