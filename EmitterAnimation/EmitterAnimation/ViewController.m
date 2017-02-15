//
//  ViewController.m
//  EmitterAnimation
//
//  Created by anyongxue on 2017/1/18.
//  Copyright © 2017年 cc. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    

}

- (IBAction)ButtonAnimation:(UIButton *)button {
    
    button.selected = !button.selected;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
