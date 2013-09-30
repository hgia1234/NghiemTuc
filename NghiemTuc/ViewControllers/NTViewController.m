//
//  NTViewController.m
//  NghiemTuc
//
//  Created by Gia on 9/8/13.
//  Copyright (c) 2013 gravity. All rights reserved.
//

#import "NTViewController.h"
#import "NTProcessViewController.h"
#import "NTToolsSideMenuViewController.h"
#import "UIImage+Resize.h"
#import "UIImage+Orientation.h"
#import "NTImageCell.h"


@interface NTViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NSFetchedResultsController *results;
@property (nonatomic, strong) IBOutlet UICollectionView *collectionView;

@end

@implementation NTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")){
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    self.title = @"Gallery";
    self.results = [Photo MR_fetchAllGroupedBy:nil withPredicate:nil sortedBy:@"date" ascending:NO];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"Settings" style:UIBarButtonItemStyleBordered target:self action:@selector(settingsPressed:)];
    self.navigationItem.leftBarButtonItem = item;
    [self.collectionView registerClass:[NTImageCell class] forCellWithReuseIdentifier:@"Cell"];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.results performFetch:nil];
    [self.collectionView reloadData];
    [self.collectionView setContentOffset:CGPointZero animated:YES];
}

- (void)settingsPressed:(id)sender{
    [self.menuContainerViewController toggleLeftSideMenuCompletion:nil];
}

- (IBAction)cameraPressed:(id)sender{
    
    UIActionSheet *actionSheet= [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Camera",@"Photos", nil];
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    UIImagePickerController *vc = [[UIImagePickerController alloc] init];
    vc.allowsEditing = YES;
    vc.delegate = self;
    if (buttonIndex==0) {
        if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear]) {
            vc.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:vc animated:YES completion:nil];
        }
    }else if(buttonIndex == 1){
        vc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:vc animated:YES completion:nil];
    }else{
        //autodismiss
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [MBProgressHUD showHUDAddedTo:picker.view animated:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *image = [[info valueForKey:UIImagePickerControllerEditedImage] fixOrientation];
        if (!image) {
           image = [(UIImage *) [info objectForKey:
                          UIImagePickerControllerOriginalImage] fixOrientation];
        }
        
        UIImage *finalizeImage = nil;
        if (image.size.height==image.size.width&&
            image.size.width==640) {
            finalizeImage = image;
        }else{
            CGSize destSize = CGSizeZero;
            if (image.size.height>=image.size.width) {
                destSize = CGSizeMake(image.size.width*(640/image.size.width), image.size.height*(640/image.size.width));
            }else{
                destSize = CGSizeMake(image.size.width*(960/image.size.height), image.size.height*(960/image.size.height));
                
            }
            
            finalizeImage = [image resizedImage:destSize interpolationQuality:kCGInterpolationDefault];
        }
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideAllHUDsForView:picker.view animated:YES];
            NTProcessViewController *vc = [[NTProcessViewController alloc] initWithImage:finalizeImage];
            NTToolsSideMenuViewController *toolsVC = (NTToolsSideMenuViewController *)self.menuContainerViewController.rightMenuViewController;
            toolsVC.processView = vc;
            [self.navigationController pushViewController:vc animated:NO];
            [self dismissViewControllerAnimated:YES completion:nil];
            
        });
        
    });
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionView Datasource
// 1
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return [self.results.sections[0] numberOfObjects];
}
// 2
- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}
// 3
- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NTImageCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    Photo *photo = [self.results objectAtIndexPath:indexPath];
    UIImage *image = [UIImage imageWithContentsOfFile:photo.image];
    cell.imageView.image = image;
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    Photo *photo = [self.results objectAtIndexPath:indexPath];
    NTProcessViewController *vc = [[NTProcessViewController alloc] initWithPhoto:photo];
    NTToolsSideMenuViewController *toolsVC = (NTToolsSideMenuViewController *)self.menuContainerViewController.rightMenuViewController;
    toolsVC.processView = vc;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    // TODO: Deselect item
}

#pragma mark – UICollectionViewDelegateFlowLayout

// 1
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    Photo *photo = [self.results objectAtIndexPath:indexPath];
    UIImage *image = [UIImage imageWithContentsOfFile:photo.image];
    
    CGSize destSize = CGSizeZero;
    if (image.size.height>image.size.width) {
        destSize = CGSizeMake(image.size.width*(80/image.size.width), image.size.height*(80/image.size.width));
    }else{
        destSize = CGSizeMake(image.size.width*(120/image.size.height), image.size.height*(120/image.size.height));
    }
    return destSize;
}

// 3
- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(50, 20, 50, 20);
}

@end
