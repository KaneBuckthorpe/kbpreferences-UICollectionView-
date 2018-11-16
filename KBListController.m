//
//  KBListController.m
//  ReordableUICollectionView
//
//  Created by kane buckthorpe on 30/09/2018.
//  Copyright © 2018 kane buckthorpe. All rights reserved.
//

#import "KBListController.h"
#import "cells/KBCollectionCell.h"
#import "supplementaryViews/KBFooterView.h"
#import "supplementaryViews/KBHeaderView.h"
#import <Preferences/PSSpecifier.h>
#import <UIKit/UIKit.h>
#import <objc/runtime.h>

@interface PSSpecifierDataSource : NSObject
+ (id)sharedInstance;
+ (id)loadSpecifiersFromPlist:(id)arg1
                     inBundle:(id)arg2
                       target:(id)arg3
                 stringsTable:(id)arg4;
@end

@interface UIImage (IndieDev)
+ (UIImage *)_applicationIconImageForBundleIdentifier:
                 (NSString *)bundleIdentifier
                                               format:(int)format
                                                scale:(CGFloat)scale;
@end

@interface KBListController ()
@property(nonatomic, retain) UICollectionView *collectionView;
- (NSInteger)numberOfGroups;
- (NSArray *)specifiersInGroup:(NSInteger)group;
- (NSInteger)rowsForGroup:(NSInteger)group;
@end

@implementation KBListController {
    NSMutableArray *_groups;
    NSMutableOrderedSet *cellReuseIdentifiers;
}
- (NSArray *)loadSpecifiersFromPlistName:(NSString *)plistName
                                inBundle:(NSBundle *)bundle {

    NSArray *specifiers =
        (NSArray *)[PSSpecifierDataSource loadSpecifiersFromPlist:plistName
                                                         inBundle:bundle
                                                           target:self
                                                     stringsTable:nil];

    if (![[(PSSpecifier *)[specifiers firstObject] propertyForKey:@"cell"]
            isEqualToString:@"KBGroupCell"]) {

        NSMutableArray *tempArray = [specifiers mutableCopy];
        PSSpecifier *KBGroupSpecifier = [PSSpecifier emptyGroupSpecifier];
        KBGroupSpecifier.cellType = -1;
        KBGroupSpecifier.properties[@"cell"] = @"KBGroupCell";
        [tempArray insertObject:KBGroupSpecifier atIndex:0];
        specifiers = [tempArray copy];
    }

    return specifiers;
}

- (NSArray *)loadSpecifiersFromPlistName:(NSString *)plistName {

    NSArray *specifiers = (NSArray *)[self
        loadSpecifiersFromPlistName:plistName
                           inBundle:[NSBundle bundleForClass:[self class]]];

    return specifiers;
}

- (NSArray *)specifiers {
    NSArray *specifiers = [self
        loadSpecifiersFromPlistName:@"KBTest"
                           inBundle:[NSBundle bundleForClass:[self class]]];
    return specifiers;
}

- (NSInteger)numberOfGroups {
    return _groups.count;
}

- (NSArray *)specifiersInGroup:(NSInteger)group {
    int currentGroup = [[_groups objectAtIndex:group] intValue];
    int nextGroup = ((_groups.count - 2) >= group)
                        ? [[_groups objectAtIndex:group + 1] intValue]
                        : self.specifiers.count;
    int length = nextGroup - currentGroup;

    return
        [self.specifiers subarrayWithRange:NSMakeRange(currentGroup, length)];
}

- (NSInteger)rowsForGroup:(NSInteger)group {
    return [self specifiersInGroup:group].count - 1;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;

    cellReuseIdentifiers = [NSMutableOrderedSet new];

    _groups = [NSMutableArray new];
    NSUInteger index = 0;
    for (PSSpecifier *specifier in self.specifiers) {
        if ([(NSString *)[specifier propertyForKey:@"cell"]
                isEqualToString:@"KBGroupCell"]) {
            [_groups addObject:[NSNumber numberWithInteger:index]];
        } else {
            [cellReuseIdentifiers
                addObject:[specifier propertyForKey:@"cellClass"]
                              ? [specifier propertyForKey:@"cellClass"]
                              : [specifier propertyForKey:@"cell"]];
            NSLog(@"reuseIdentifiers:.%@.",
                  [specifier propertyForKey:@"cellClass"]
                      ? [specifier propertyForKey:@"cellClass"]
                      : [specifier propertyForKey:@"cell"]);
        }
        index++;
    }
    ////Navigation Bar
    UIBarButtonItem *button =
        [[UIBarButtonItem alloc] initWithTitle:@"Button"
                                         style:UIBarButtonItemStylePlain
                                        target:self
                                        action:@selector(buttonAction:)];

    self.navigationItem.rightBarButtonItems =
        [NSArray arrayWithObjects:button, nil];
}

- (void)viewWillAppear:(BOOL)arg1 {
    [super viewWillAppear:arg1];
    UICollectionViewFlowLayout *layout =
        [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.itemSize = CGSizeMake((self.view.bounds.size.width - 20), 40);
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 1;
    layout.headerReferenceSize = CGSizeMake(self.view.bounds.size.width, 60);
    layout.footerReferenceSize = CGSizeMake(self.view.bounds.size.width, 40);
    layout.sectionHeadersPinToVisibleBounds = NO;

    ////CollectionView
    self.collectionView = [[UICollectionView alloc]
               initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width,
                                        self.view.bounds.size.height)
        collectionViewLayout:layout];
    self.collectionView.autoresizingMask =
        (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    self.collectionView.pagingEnabled = NO;
    self.collectionView.backgroundColor = UIColor.clearColor;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.allowsSelection = NO;
    [self.view addSubview:self.collectionView];

    for (NSString *string in cellReuseIdentifiers) {
        Class cellClass = objc_getClass([string UTF8String]);
        [self.collectionView registerClass:cellClass ? cellClass
                                                     : [KBCollectionCell class]
                forCellWithReuseIdentifier:string];
    }
    [self.collectionView registerClass:[KBHeaderView class]
            forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                   withReuseIdentifier:@"header"];
    [self.collectionView registerClass:[KBFooterView class]
            forSupplementaryViewOfKind:UICollectionElementKindSectionFooter
                   withReuseIdentifier:@"footer"];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}

////NavButton Methods

- (void)buttonAction:(UIBarButtonItem *)barButton {
}

////UICollectionView Delegates

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath {
    PSSpecifier *specifier =
        [[self specifiersInGroup:indexPath.section] firstObject];
    UICollectionReusableView *reusableview = nil;

    if (kind == UICollectionElementKindSectionHeader) {
        KBHeaderView *headerView =
            [collectionView dequeueReusableSupplementaryViewOfKind:
                                UICollectionElementKindSectionHeader
                                               withReuseIdentifier:@"header"
                                                      forIndexPath:indexPath];
        headerView.label.text = specifier.name;
        reusableview = headerView;
    }

    if (kind == UICollectionElementKindSectionFooter) {
        KBFooterView *footerview =
            [collectionView dequeueReusableSupplementaryViewOfKind:
                                UICollectionElementKindSectionFooter
                                               withReuseIdentifier:@"footer"
                                                      forIndexPath:indexPath];
        footerview.label.text = [specifier propertyForKey:@"footerText"];
        footerview.label.textAlignment =
            [[specifier propertyForKey:@"footerAlignment"] intValue];
        reusableview = footerview;
    }

    return reusableview;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                             layout:(UICollectionViewFlowLayout *)
                                        collectionViewLayout
    referenceSizeForFooterInSection:(NSInteger)section {

    PSSpecifier *specifier = [[self specifiersInGroup:section] firstObject];

    if ([specifier propertyForKey:@"footerText"]) {
        return collectionViewLayout.footerReferenceSize;
    } else {
        return CGSizeMake(collectionViewLayout.footerReferenceSize.width, 0);
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                             layout:(UICollectionViewFlowLayout *)
                                        collectionViewLayout
    referenceSizeForHeaderInSection:(NSInteger)section {

    PSSpecifier *specifier = [[self specifiersInGroup:section] firstObject];

    if (specifier.name) {
        return [specifier propertyForKey:@"height"]
                   ? CGSizeMake(collectionViewLayout.headerReferenceSize.width,
                                [[specifier propertyForKey:@"height"] intValue])
                   : collectionViewLayout.headerReferenceSize;
    } else {
        return CGSizeMake(collectionViewLayout.headerReferenceSize.width, 0);
    }

    return collectionViewLayout.headerReferenceSize;
}

- (NSInteger)numberOfSectionsInCollectionView:
    (UICollectionView *)collectionView {

    return [self numberOfGroups];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    return [self rowsForGroup:section];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    KBCollectionCell *cell = [collectionView
        dequeueReusableCellWithReuseIdentifier:@"KBCollectionCell"
                                  forIndexPath:indexPath];
    cell.label.text = @"test";
    [cell.label sizeToFit];
    cell.label.center = CGPointMake((cell.label.bounds.size.width / 2) + 15,
                                    cell.contentView.center.y);

    UIBezierPath *maskPath;

    if ([self rowsForGroup:indexPath.section] == 1) {
        maskPath = [UIBezierPath
            bezierPathWithRoundedRect:cell.bounds
                    byRoundingCorners:UIRectCornerTopLeft |
                                      UIRectCornerTopRight |
                                      UIRectCornerBottomLeft |
                                      UIRectCornerBottomRight
                          cornerRadii:CGSizeMake(cell.bounds.size.height / 2,
                                                 cell.bounds.size.height / 2)];

    } else if (indexPath.row == 0) {
        maskPath = [UIBezierPath
            bezierPathWithRoundedRect:cell.bounds
                    byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight
                          cornerRadii:CGSizeMake(cell.bounds.size.height / 2,
                                                 cell.bounds.size.height / 2)];
    } else if (indexPath.row == [self rowsForGroup:indexPath.section] - 1) {
        maskPath = [UIBezierPath
            bezierPathWithRoundedRect:cell.bounds
                    byRoundingCorners:UIRectCornerBottomLeft |
                                      UIRectCornerBottomRight
                          cornerRadii:CGSizeMake(cell.bounds.size.height / 2,
                                                 cell.bounds.size.height / 2)];
    } else {
        maskPath =
            [UIBezierPath bezierPathWithRoundedRect:cell.bounds
                                  byRoundingCorners:UIRectCornerTopLeft |
                                                    UIRectCornerTopRight |
                                                    UIRectCornerBottomLeft |
                                                    UIRectCornerBottomRight
                                        cornerRadii:CGSizeMake(0, 0)];
    }

    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = cell.bounds;
    maskLayer.path = maskPath.CGPath;
    cell.contentView.layer.mask = maskLayer;

    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView
                    layout:(UICollectionViewFlowLayout *)collectionViewLayout
    sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return collectionViewLayout.itemSize;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                        layout:
                            (UICollectionViewFlowLayout *)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section {

    return UIEdgeInsetsMake(10, 10, 10, 10);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end