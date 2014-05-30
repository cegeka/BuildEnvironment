//
//  BEViewController.m
//  Example
//
//  Created by Sabbe Jan on 22/05/14.
//  Copyright (c) 2014 Cegeka. All rights reserved.
//

#import "BEViewController.h"

#import "BEConfig.h"

@interface BEViewController ()
@property (weak, nonatomic) IBOutlet UILabel *environmentIndependent;
@property (weak, nonatomic) IBOutlet UILabel *environmentDependent;

@end

@implementation BEViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	self.environmentIndependent.text = BEConfig.configuration[@"backend_url"];
	self.environmentDependent.text = BEConfig.configuration[@"support_email"];
}

@end
