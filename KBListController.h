//
//  KBListController.h
//
//  Created by kane buckthorpe on 30/09/2018.
//  Copyright © 2018 kane buckthorpe. All rights reserved.
//
#import <Preferences/PSViewController.h>

@interface KBListController : PSViewController <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
-(NSArray *)loadSpecifiersFromPlistName:(NSString*)plistName inBundle:(NSBundle*)bundle;
-(NSArray *)loadSpecifiersFromPlistName:(NSString*)plistName;
- (NSArray *)specifiers;
@end

