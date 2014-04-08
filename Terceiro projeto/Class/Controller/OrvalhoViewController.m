//
//  OrvalhoViewController.m
//  RNFrostedSidebar
//
//  Created by Ezequiel Franca dos Santos on 28/03/14.
//  Copyright (c) 2014 Ryan Nystrom. All rights reserved.
//

#import "OrvalhoViewController.h"
#import "PNChart.h"
#import "SDbar.h"
#import "ArduinoWebservice.h"
#import <math.h>

@interface OrvalhoViewController ()

@end


@implementation OrvalhoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.arduino = [[ArduinoWebservice alloc]init];
        self.plotaGrafico.enabled = FALSE;
        self.plotaGrafico.alpha = 0;
        self.single = [[Single alloc]init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.time = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(atualizadorLabel) userInfo:nil repeats:YES];
    
    //gesto para abrir a barra lateral
    UISwipeGestureRecognizer *gestoPorra = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(abrirMenu)];
    [gestoPorra setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.view addGestureRecognizer:gestoPorra];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidDisappear:(BOOL)animated
{
    [self.time invalidate];
    self.time = nil;
}

- (IBAction)FinishButton:(id)sender
{
    self.temperaturaFinal = [self.arduino returnData:@"temperatura"];
    self.finalLabel.text = [NSString stringWithFormat:@"%2f C" , self.temperaturaFinal];
    self.plotaGrafico.enabled = TRUE;
    self.plotaGrafico.alpha = 1;
}

- (IBAction)BeginButton:(id)sender
{
    self.temperaturaInicial = [self.arduino returnData:@"temperatura"];
    self.inicialLabel.text = [NSString stringWithFormat:@"%2f C" , self.temperaturaInicial];
}

- (IBAction)plotaGrafico:(id)sender {
   
    Temperatura temp = self.single.temperatura;
    temp.temperaturaAtual = self.temperaturaAtual;
    temp.TemperaturaFinal = self.temperaturaFinal;
    temp.temperaturaInicial = self.temperaturaInicial;
    
    self.single.temperatura = temp;
    
     [SDbar changeController:6 :self ];
}

-(void)atualizadorLabel{
    
    float temp;
    [self.arduino reloadData];
    temp = [self.arduino returnData:@"temperatura"];
    self.temperaturaAtual = temp;
    _atualLabel.text = [NSString stringWithFormat:@"%2f C", temp];
    NSLog(@"%f", temp);
    
}

#pragma mark sidebarManager

-(void)abrirMenu
{
    [SDbar showSideBar:self];
}

- (void)sidebar:(RNFrostedSidebar *)sidebar didTapItemAtIndex:(NSUInteger)index {
    
    [SDbar changeController: index :self ];
}


- (IBAction)btn:(id)sender {
    [self abrirMenu];
}

@end
