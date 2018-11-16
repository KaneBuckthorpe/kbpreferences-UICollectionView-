//
//  KBCollectionCell.h
//  ReordableUICollectionView
//
//  Created by kane buckthorpe on 30/09/2018.
//  Copyright © 2018 kane buckthorpe. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Preferences/PSSpecifier.h>
#import "KBCollectionCell.h"

@interface KBCollectionCell : UICollectionViewCell
@property (nonatomic,retain) PSSpecifier * specifier;
@property(nonatomic, retain) UILabel *label;
@end