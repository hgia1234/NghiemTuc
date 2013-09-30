//
//  NTToolsSideMenuViewController.m
//  NghiemTuc
//
//  Created by Gia on 9/27/13.
//  Copyright (c) 2013 gravity. All rights reserved.
//

#import "NTToolsSideMenuViewController.h"
#import "NTProcessViewController.h"

@interface NTToolsSideMenuViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation NTToolsSideMenuViewController

- (id)initWithProcessViewController:(NTProcessViewController *)processView{
    self = [super init];
    if (self) {
        self.processView = processView;
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"Random Swap";
            break;
        case 1:
            cell.textLabel.text = @"Photo Bomb";
            break;
        case 2:
            cell.textLabel.text = @"Nghiem Tuc";
            break;
        case 3:
            cell.textLabel.text = @"Save and continues";
            break;
        case 4:
            cell.textLabel.text = @"Save and go to gallery";
            break;
            
        default:
            break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.menuContainerViewController toggleRightSideMenuCompletion:nil];
    switch (indexPath.row) {
        case 0:
            [self.processView randomSwap];
            break;
        case 1:
            [self.processView photoBomb];
            break;
        case 2:
            [self.processView nghiemTucHoa];
            break;
        case 3:
            [self.processView save];
            break;
        case 4:
            [self.processView saveAndPop];
            break;
            
        default:
            break;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
