//
//  Photo.h
//  NghiemTuc
//
//  Created by Gia on 9/27/13.
//  Copyright (c) 2013 gravity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Photo : NSManagedObject

@property (nonatomic, retain) NSString * image;
@property (nonatomic, retain) NSString * raw;
@property (nonatomic, retain) NSDate * date;

@end
