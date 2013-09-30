//
//  NTProcessViewController.h
//  NghiemTuc
//
//  Created by Gia on 9/8/13.
//  Copyright (c) 2013 gravity. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NTProcessViewController : UIViewController

- (id)initWithImage:(UIImage *)image;
- (id)initWithPhoto:(Photo *)photo;

- (void)nghiemTucHoa;
- (void)randomSwap;
- (void)photoBomb;
- (void)save;
- (void)saveAndPop;

@end
