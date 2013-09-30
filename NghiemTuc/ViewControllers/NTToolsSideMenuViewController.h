//
//  NTToolsSideMenuViewController.h
//  NghiemTuc
//
//  Created by Gia on 9/27/13.
//  Copyright (c) 2013 gravity. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NTProcessViewController;

@interface NTToolsSideMenuViewController : UIViewController

@property (nonatomic, strong) NTProcessViewController *processView;

- (id)initWithProcessViewController:(NTProcessViewController *)processView;

@end
