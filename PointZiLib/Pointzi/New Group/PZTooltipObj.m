//
//  PZTooltipObj.m
//  Pointzi
//
//  Created by Mahipal Kummari on 23/05/19.
//  Copyright © 2019 Mahipal Kummari. All rights reserved.
//

#import "PZTooltipObj.h"

@implementation PZTooltipObj
@synthesize nameTitle,firstName,lastName,profileURL,tooltipImgURL,tooltipMessage;

- (void) initWithJsonDict:(NSDictionary *) dict
{    
    NSDictionary * ownerDict = [dict objectForKey:@"owner"];
    
    self.tooltipImgURL  =  [dict objectForKey:@"image"];
    self.tooltipMessage =  [dict objectForKey:@"message"];
    
     self.nameTitle =  [ownerDict objectForKey:@"nameTitle"];
     self.firstName =  [ownerDict objectForKey:@"firstName"];
     self.lastName =   [ownerDict objectForKey:@"lasttName"];
     self.profileURL = [ownerDict objectForKey:@"image"];
}
@end
