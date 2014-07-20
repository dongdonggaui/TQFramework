//
//  HLYViewController.m
//  MyWeChat
//
//  Created by 黄露洋 on 13-11-7.
//  Copyright (c) 2013年 黄露洋. All rights reserved.
//

#import "HLYViewController.h"
#import "UIView+Frame.h"

const NSString *kNotificationControllerDidPushed = @"kNotificationControllerDidPushed";

@interface HLYViewController ()

@end

@implementation HLYViewController

- (void)dealloc
{
    self.passValue = nil;
    self.hlyLeftBarButtonItem = nil;
    self.hlyRightBarButtonItem = nil;
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
	// Do any additional setup after loading the view.
    [self setupViews];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.navigationController != nil && [self.navigationController.viewControllers objectAtIndex:0] != self) {
        [[NSNotificationCenter defaultCenter] postNotificationName:(NSString *)kNotificationControllerDidPushed object:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO], @"isRoot", nil]];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:(NSString *)kNotificationControllerDidPushed object:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], @"isRoot", nil]];
    }
    
    // analytics
//    [MobClick beginLogPageView:NSStringFromClass(self.class)];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
//    [self.topIndicateView showMessage:@"服务器错误，请稍候再试"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // analytics
//    [MobClick endLogPageView:NSStringFromClass(self.class)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - setters & getters
- (UIBarButtonItem *)hlyLeftBarButtonItem
{
    if (_hlyLeftBarButtonItem == nil) {
        UIImage *image = [UIImage imageNamed:@"nav_item_back"];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.width = image.size.width;
        button.height = image.size.height;
        [button setBackgroundImage:image forState:UIControlStateNormal];
        [button addTarget:self action:@selector(hlyLeftItemDidTapped:) forControlEvents:UIControlEventTouchUpInside];
        
        _hlyLeftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    }
    
    return _hlyLeftBarButtonItem;
}

- (UIBarButtonItem *)hlyRightBarButtonItem
{
    if (_hlyRightBarButtonItem == nil) {
        UIImage *image = [UIImage imageNamed:@"nav_item_done"];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.width = image.size.width;
        button.height = image.size.height;
        [button setBackgroundImage:image forState:UIControlStateNormal];
        [button addTarget:self action:@selector(hlyRightItemDidTapped:) forControlEvents:UIControlEventTouchUpInside];
        
        _hlyRightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    }
    
    return _hlyRightBarButtonItem;
}

- (HLYAppDelegate *)appDelegate {
    return (HLYAppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (NSUserDefaults *)userDefaults
{
    return [NSUserDefaults standardUserDefaults];
}

- (CGFloat)viewTopOffset
{
    CGFloat offset = 0;
    if ([self respondsToSelector:@selector(topLayoutGuide)]) {
        offset = [self.topLayoutGuide length];
    }
    
    return offset;
}

- (void)setupViews
{
//    if (HLYSystemVersion >= 7) {
//        self.edgesForExtendedLayout = UIRectEdgeNone;
//    }
    self.view.backgroundColor = [UIColor whiteColor];
    if ([self needCustomLeftItem]) {
        self.navigationItem.leftBarButtonItem = self.hlyLeftBarButtonItem;
    }
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"返回", @"") style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backItem;
}

- (void)hlyLeftItemDidTapped:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)hlyRightItemDidTapped:(id)sender
{
    
}

- (BOOL)needCustomLeftItem
{
    return NO;
//    return self.navigationController != nil && [self.navigationController.viewControllers indexOfObject:self] != 0;
}

- (void)presentLoginViewCompleted:(void (^)(void))completed
{
    UIStoryboard *loginStoryboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    UIViewController *vc = [loginStoryboard instantiateInitialViewController];
    [self presentViewController:vc animated:YES completion:^{
        if (completed != nil) {
            completed();
        }
    }];
}

@end
