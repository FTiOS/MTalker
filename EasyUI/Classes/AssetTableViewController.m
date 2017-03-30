//
//  AssetTableViewController.m
//  FSImageViewer
//
//  Created by hexiayu on 15/3/17.
//  Copyright (c) 2015年 Felix Schulze. All rights reserved.
//

#import "AssetTableViewController.h"
#import "GPImageHelper.h"
#import "AssetsViewController.h"
#import "NSBundle+EasyUI.h"
@interface AssetTableViewController ()<GPImageHelperDelegate>
{
    NSString *name;
}
@property (nonatomic,strong)NSArray *groups;
@end

@implementation AssetTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.groups=[GPImageHelper sharedGPImageHelper].assetGroups;
    UIBarButtonItem *cancel=[[UIBarButtonItem alloc]initWithTitle:@"CancelText" style:UIBarButtonItemStylePlain target:self action:@selector(doCancel)];
    self.navigationItem.leftBarButtonItem=cancel;
    
    [GPImageHelper sharedGPImageHelper].delegate=self;
    [[GPImageHelper sharedGPImageHelper]getGroupList];
    
    
}

- (void)doCancel{
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)viewDidAppear:(BOOL)animated{
     [GPImageHelper sharedGPImageHelper].delegate=self;
}

#pragma mark - Table view data source

#pragma mark - UITableView DataSource
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    NSDictionary *dic=[[GPImageHelper sharedGPImageHelper]getGroupInfo:indexPath.row];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    cell.imageView.image=[dic objectForKey:@"thumbnail"];
    cell.textLabel.text=[dic objectForKey:@"name"];
    cell.detailTextLabel.text=[[dic objectForKey:@"count"] stringValue];
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.groups.count;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self openGalleryAtIndex:indexPath.row];
}
-(void)openGalleryAtIndex:(NSInteger)index{
     name=[[[GPImageHelper sharedGPImageHelper]getGroupInfo:index] objectForKey:@"name"];
    [[GPImageHelper sharedGPImageHelper]getPhotoListOfGroupByIndex:index];
}

#pragma mark -assert choose delegate
-(void)didFinishGetGroupList:(NSArray *)groupsArray{
     self.groups=groupsArray;
    [self.tableView reloadData];
}
-(void)didFinishGetImages:(NSArray *)imagesArray{
    AssetsViewController *VC=[[AssetsViewController alloc]initWithNibName:@"AssetsViewController" bundle:[NSBundle my_easyUIBundle]];
    VC.dataSourceArray=imagesArray;
    VC.maxSelectCount = self.maxSelectCount;
    [self.navigationController pushViewController:VC animated:YES];
    VC.title=name;
}
@end
