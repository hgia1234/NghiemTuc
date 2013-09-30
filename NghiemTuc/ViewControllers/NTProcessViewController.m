//
//  NTProcessViewController.m
//  NghiemTuc
//
//  Created by Gia on 9/8/13.
//  Copyright (c) 2013 gravity. All rights reserved.
//

#import "NTProcessViewController.h"


static CGContextRef CreateCGBitmapContextForSize(CGSize size)
{
    CGContextRef    context = NULL;
    CGColorSpaceRef colorSpace;
    int             bitmapBytesPerRow;
	
    bitmapBytesPerRow = (size.width * 4);
	
    colorSpace = CGColorSpaceCreateDeviceRGB();
    context = CGBitmapContextCreate (NULL,
									 size.width,
									 size.height,
									 8,      // bits per component
									 bitmapBytesPerRow,
									 colorSpace,
									 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
	CGContextSetAllowsAntialiasing(context, NO);
    CGColorSpaceRelease( colorSpace );
    return context;
}

typedef enum {
    NTProcessViewControllerTypePhotoBomb,
    NTProcessViewControllerTypeSwap,
    NTProcessViewControllerTypeNT
}NTProcessViewControllerType;

@interface NTProcessViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIImage *image;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *actionBtn;
@property (nonatomic) int index;
@property (nonatomic) NTProcessViewControllerType type;
@property (nonatomic, strong) NSString *rawURL;
@property (nonatomic, strong) Photo *photo;

@end

@implementation NTProcessViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithImage:(UIImage *)image{
    self = [super init];
    if (self) {
        _image = image;
    }
    return self;
}

- (id)initWithPhoto:(Photo *)photo{
    self = [super init];
    if (self) {
        self.photo = photo;
        self.image = [UIImage imageWithContentsOfFile:photo.raw];
        self.rawURL = photo.raw;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"Tools" style:UIBarButtonItemStyleBordered target:self action:@selector(toolsPressed:)];
    self.navigationItem.rightBarButtonItem = item;
    
    self.imageView.image = self.image;
    if (self.photo) {
        self.imageView.image = [UIImage imageWithContentsOfFile:self.photo.image];
    }
    self.scrollView.contentSize = self.image.size;
    self.scrollView.bouncesZoom = YES;
    self.scrollView.maximumZoomScale = 5;
    self.scrollView.minimumZoomScale = 1;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.alwaysBounceHorizontal = YES;
    self.scrollView.alwaysBounceVertical = YES;
    self.scrollView.zoomScale = 1;
    self.scrollView.delegate = self;
    self.scrollView.clipsToBounds = NO;
    
    
    self.index = -1;
    
    self.type = NTProcessViewControllerTypeSwap;
    [self.actionBtn setTitle:@"Swap again" forState:UIControlStateNormal];
    
}



- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

- (NSArray *)facesArrayFromImage{
    NSDictionary *detectorOptions = [[NSDictionary alloc] initWithObjectsAndKeys:CIDetectorAccuracyLow, CIDetectorAccuracy, nil];
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeFace
                                              context:nil
                                              options:detectorOptions];
    NSArray *faceArray = [detector featuresInImage:[[CIImage alloc] initWithCGImage:self.image.CGImage options:nil] options:nil];
    // Create a green circle to cover the rects that are returned.
    
    
    for (CIFaceFeature *f in faceArray){
        NSLog(@"%@",NSStringFromCGRect(f.bounds));
    }
    return faceArray;
}

- (void)nghiemTucHoa{
    self.type = NTProcessViewControllerTypeNT;
    self.actionBtn.hidden = YES;
    if ([self facesArrayFromImage].count<1) {
        return;
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSArray *facesArray = [self facesArrayFromImage];
        
        CGImageRef returnImage = NULL;
        CGRect backgroundImageRect = CGRectMake(0., 0., CGImageGetWidth(self.image.CGImage), CGImageGetHeight(self.image.CGImage));
        CGContextRef bitmapContext = CreateCGBitmapContextForSize(backgroundImageRect.size);
        CGContextClearRect(bitmapContext, backgroundImageRect);
        CGContextDrawImage(bitmapContext, backgroundImageRect, self.image.CGImage);
        
        
        
        // features found by the face detector
        for ( CIFaceFeature *ff in facesArray ) {
            CGRect faceRect = [ff bounds];
            CGContextDrawImage(bitmapContext, CGRectInset(faceRect, -faceRect.size.width/10, -faceRect.size.height/10), [UIImage imageNamed:@"d81.png"].CGImage);
        }
        returnImage = CGBitmapContextCreateImage(bitmapContext);
        CGContextRelease (bitmapContext);
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            self.imageView.image = [UIImage imageWithCGImage:returnImage];
        });
    });
}

- (void)randomSwap{
    self.type = NTProcessViewControllerTypeSwap;
    self.actionBtn.hidden = NO;
    [self.actionBtn setTitle:@"Swap again" forState:UIControlStateNormal];
    if ([self facesArrayFromImage].count<2) {
        return;
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSArray *facesArray = [self facesArrayFromImage];
        
        CGImageRef returnImage = NULL;
        CGRect backgroundImageRect = CGRectMake(0., 0., CGImageGetWidth(self.image.CGImage), CGImageGetHeight(self.image.CGImage));
        CGContextRef bitmapContext = CreateCGBitmapContextForSize(backgroundImageRect.size);
        CGContextClearRect(bitmapContext, backgroundImageRect);
        CGContextDrawImage(bitmapContext, backgroundImageRect, self.image.CGImage);
        
        
        // features found by the face detector
        int index = 0;
        NSMutableArray *swapFaces = [NSMutableArray arrayWithArray:facesArray];
        NSUInteger count = [swapFaces count];
        for (NSUInteger i = 0; i < count; ++i) {
            // Select a random element between i and end of array to swap with.
            NSInteger nElements = count - i;
            NSInteger n = (arc4random() % nElements) + i;
            [swapFaces exchangeObjectAtIndex:i withObjectAtIndex:n];
        }
        for ( CIFaceFeature *ff in facesArray ) {
            CGRect willSwapToRect = [swapFaces[index] bounds];
            CGRect faceRect = [ff bounds];
            CGContextDrawImage(bitmapContext, faceRect,
                               CGImageCreateWithImageInRect(self.image.CGImage,
                                CGRectMake(willSwapToRect.origin.x*self.image.scale,
                                           self.image.size.height-willSwapToRect.origin.y*self.image.scale-willSwapToRect.size.height,
                                           willSwapToRect.size.width*self.image.scale,
                                           willSwapToRect.size.height*self.image.scale)));
            //the coordinate start at bottom left (not top left), so adjust y
            index ++;
        }
        returnImage = CGBitmapContextCreateImage(bitmapContext);
        CGContextRelease (bitmapContext);
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            self.imageView.image = [UIImage imageWithCGImage:returnImage];
        });
    });
}

- (void)photoBomb{
    self.type = NTProcessViewControllerTypePhotoBomb;
    self.actionBtn.hidden = NO;
    [self.actionBtn setTitle:@"Another face" forState:UIControlStateNormal];
    if ([self facesArrayFromImage].count<1) {
        return;
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSArray *facesArray = [self facesArrayFromImage];
        
        CGImageRef returnImage = NULL;
        CGRect backgroundImageRect = CGRectMake(0., 0., CGImageGetWidth(self.image.CGImage), CGImageGetHeight(self.image.CGImage));
        CGContextRef bitmapContext = CreateCGBitmapContextForSize(backgroundImageRect.size);
        CGContextClearRect(bitmapContext, backgroundImageRect);
        CGContextDrawImage(bitmapContext, backgroundImageRect, self.image.CGImage);
        
        
        // features found by the face detector
        
        int random = arc4random()%facesArray.count;
        if (self.index != -1) {
            random = self.index;
        }
        CGRect willSwapToRect = [facesArray[random] bounds];
        for ( CIFaceFeature *ff in facesArray ) {
            
            CGRect faceRect = [ff bounds];
            CGContextDrawImage(bitmapContext, faceRect,
                               CGImageCreateWithImageInRect(self.image.CGImage,
                                                            CGRectMake(willSwapToRect.origin.x*self.image.scale,
                                                                       self.image.size.height-willSwapToRect.origin.y*self.image.scale-willSwapToRect.size.height,
                                                                       willSwapToRect.size.width*self.image.scale,
                                                                       willSwapToRect.size.height*self.image.scale)));
            //the coordinate start at bottom left (not top left), so adjust y
        }
        returnImage = CGBitmapContextCreateImage(bitmapContext);
        CGContextRelease (bitmapContext);
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            self.imageView.image = [UIImage imageWithCGImage:returnImage];
        });
    });
}

- (void)save{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (self.rawURL.length == 0) {
            self.rawURL = [GDUtils writeImageToDocumentFolder:self.image];
        }
        NSString *editedImgUrl = [GDUtils writeImageToDocumentFolder:self.imageView.image];
        Photo *photo = [Photo MR_createEntity];
        photo.raw = self.rawURL;
        photo.image = editedImgUrl;
        photo.date = [NSDate date];
        [photo.managedObjectContext MR_saveToPersistentStoreAndWait];
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        });
    });
    
}

- (void)saveAndPop{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (self.rawURL.length == 0) {
            self.rawURL = [GDUtils writeImageToDocumentFolder:self.image];
        }
        NSString *editedImgUrl = [GDUtils writeImageToDocumentFolder:self.imageView.image];
        Photo *photo = [Photo MR_createEntity];
        photo.raw = self.rawURL;
        photo.image = editedImgUrl;
        photo.date = [NSDate date];
        [photo.managedObjectContext MR_saveToPersistentStoreAndWait];
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [self.navigationController popViewControllerAnimated:YES];
        });
    });
}

- (IBAction)actionPressed:(id)sender{
    if (self.type == NTProcessViewControllerTypeSwap) {
        [self randomSwap];
    }else if(self.type == NTProcessViewControllerTypePhotoBomb){
        self.index++;
        if (self.index>= [self facesArrayFromImage].count) {
            self.index = 0;
        }
        [self photoBomb];
    }
}



- (void)toolsPressed:(id)sender{
    [self.menuContainerViewController toggleRightSideMenuCompletion:nil];
}

- (void)donePressed:(id)sender{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
