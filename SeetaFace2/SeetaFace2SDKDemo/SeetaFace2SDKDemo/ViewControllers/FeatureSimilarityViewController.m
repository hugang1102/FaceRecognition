//
//  FeatureSimilarityViewController.m
//  SeetaFace2SDKDemo
//
//  Created by 49you on 2019/12/25.
//  Copyright © 2019 nrh. All rights reserved.
//

#import "FeatureSimilarityViewController.h"
#import "LocalFeaturesTableViewController.h"
#import "Tools.h"
#import <SeetaFace2SDK/SeetaFace2SDK.h>

@interface FeatureSimilarityViewController (){
    NSArray *_firstFeature;
    NSArray *_secondFeature;
}

@property (weak, nonatomic) IBOutlet UIButton *firstItem;
@property (weak, nonatomic) IBOutlet UIButton *secondItem;

@end

@implementation FeatureSimilarityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)firstItemClick:(id)sender {
    UIStoryboard *board = [UIStoryboard storyboardWithName: @"Main" bundle:nil];
    __weak LocalFeaturesTableViewController *vc = [board instantiateViewControllerWithIdentifier:@"LocalFeaturesTableViewController"];
    vc.selected = ^(NSDictionary * _Nonnull feature) {
        self->_firstFeature = feature[@"features"];
        [self->_firstItem setTitle:feature[@"name"] forState:UIControlStateNormal];
        [vc dismissViewControllerAnimated:YES completion:nil];
    };
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}

- (IBAction)secondItemClick:(id)sender {
    UIStoryboard *board = [UIStoryboard storyboardWithName: @"Main" bundle:nil];
    __weak LocalFeaturesTableViewController *vc = [board instantiateViewControllerWithIdentifier:@"LocalFeaturesTableViewController"];
    vc.selected = ^(NSDictionary * _Nonnull feature) {
        self->_secondFeature = feature[@"features"];
        [self->_secondItem setTitle:feature[@"name"] forState:UIControlStateNormal];
        [vc dismissViewControllerAnimated:YES completion:nil];
    };
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}
- (IBAction)startButtonClick:(id)sender {
    float similarity = [SFTSDK similarityWithFeature1:_firstFeature andFeature2:_secondFeature];
    NSString *tip = [NSString stringWithFormat:@"相似度是：%.2f",similarity];
    [Tools showToastWithMessage:tip];
}

@end
