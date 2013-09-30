//
//  NTImageCell.m
//  NghiemTuc
//
//  Created by Gia on 9/27/13.
//  Copyright (c) 2013 gravity. All rights reserved.
//

#import "NTImageCell.h"

@implementation NTImageCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        self.imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        self.contentView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        self.contentView.layer.borderWidth = 1;
        
        [self.contentView addSubview:self.imageView];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
