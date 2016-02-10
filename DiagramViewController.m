//
//  DiagramViewController.m
//  iRescueMedic
//
//  Created by Nathan on 8/26/13.
//  Copyright (c) 2013 Emergidata. All rights reserved.
//

#import "DiagramViewController.h"
#import "global.h"
#import "DAO.h"
#import "ClsInjuryType.h"
#import "ClsTableKey.h"
#import "InjuryCell.h"
#import "DDPopoverBackgroundView.h"  // Mani
#import "Base64.h"
#import "ClsTicketAttachments.h"
#import "QAMessageViewController.h"

#define Child_Head_x1 573
#define Child_Head_x2 627
#define Child_Head_y1 140
#define Child_Head_y2 213
#define Child_Neck_x1 585
#define Child_Neck_x2 625
#define Child_Neck_y1 219
#define Child_Neck_y2 235

#define Child_RightChest_x1 560
#define Child_RightChest_x2 588
#define Child_RightChest_y1 237
#define Child_RightChest_y2 295

#define Child_LeftChest_x1 595
#define Child_LeftChest_x2 638
#define Child_LeftChest_y1 236
#define Child_LeftChest_y2 300

#define Child_Abdomen_x1 562
#define Child_Abdomen_x2 640
#define Child_Abdomen_y1 305
#define Child_Abdomen_y2 360

#define Child_FrontRightUpperLeg_x1 558
#define Child_FrontRightUpperLeg_x2 592
#define Child_FrontRightUpperLeg_y1 375
#define Child_FrontRightUpperLeg_y2 445

#define Child_FrontLeftUpperLeg_x1 604
#define Child_FrontLeftUpperLeg_x2 640
#define Child_FrontLeftUpperLeg_y1 384
#define Child_FrontLeftUpperLeg_y2 445

#define Child_FrontRightKnee_x1 566
#define Child_FrontRightKnee_x2 591
#define Child_FrontRightKnee_y1 451
#define Child_FrontRightKnee_y2 475

#define Child_FrontLeftKnee_x1 613
#define Child_FrontLeftKnee_x2 641
#define Child_FrontLeftKnee_y1 453
#define Child_FrontLeftKnee_y2 468


#define Child_FrontRightLowerLeg_x1 565
#define Child_FrontRightLowerLeg_x2 592
#define Child_FrontRightLowerLeg_y1 475
#define Child_FrontRightLowerLeg_y2 532

#define Child_FrontLeftLowerLeg_x1 620
#define Child_FrontLeftLowerLeg_x2 642
#define Child_FrontLeftLowerLeg_y1 474
#define Child_FrontLeftLowerLeg_y2 542

#define Child_FrontRightFoot_x1 550
#define Child_FrontRightFoot_x2 588
#define Child_FrontRightFoot_y1 550
#define Child_FrontRightFoot_y2 567

#define Child_FrontLeftFoot_x1 613
#define Child_FrontLeftFoot_x2 642
#define Child_FrontLeftFoot_y1 551
#define Child_FrontLeftFoot_y2 576


#define Child_FrontRightUpperArm_x1 517
#define Child_FrontRightUpperArm_x2 558
#define Child_FrontRightUpperArm_y1 248
#define Child_FrontRightUpperArm_y2 268

#define Child_FrontRightLowerArm_x1 449
#define Child_FrontRightLowerArm_x2 497
#define Child_FrontRightLowerArm_y1 252
#define Child_FrontRightLowerArm_y2 268

#define Child_FrontRightHand_x1 402
#define Child_FrontRightHand_x2 448
#define Child_FrontRightHand_y1 247
#define Child_FrontRightHand_y2 271

#define Child_FrontLeftUpperArm_x1 650
#define Child_FrontLeftUpperArm_x2 693
#define Child_FrontLeftUpperArm_y1 236
#define Child_FrontLeftUpperArm_y2 263

#define Child_FrontLeftLowerArm_x1 710
#define Child_FrontLeftLowerArm_x2 750
#define Child_FrontLeftLowerArm_y1 239
#define Child_FrontLeftLowerArm_y2 253

#define Child_FrontLeftHand_x1 754
#define Child_FrontLeftHand_x2 795
#define Child_FrontLeftHand_y1 236
#define Child_FrontLeftHand_y2 264







#define Child_BackHead_x1 545
#define Child_BackHead_x2 603
#define Child_BackHead_y1 140
#define Child_BackHead_y2 203

#define Child_BackNeck_x1 553
#define Child_BackNeck_x2 588
#define Child_BackNeck_y1 209
#define Child_BackNeck_y2 221

#define Child_LeftUpperBack_x1 535
#define Child_LeftUpperBack_x2 562
#define Child_LeftUpperBack_y1 237
#define Child_LeftUpperBack_y2 304

#define Child_RightUpperBack_x1 576
#define Child_RightUpperBack_x2 615
#define Child_RightUpperBack_y1 233
#define Child_RightUpperBack_y2 304

#define Child_LeftLowerBack_x1 536
#define Child_LeftLowerBack_x2 564
#define Child_LeftLowerBack_y1 306
#define Child_LeftLowerBack_y2 350

#define Child_RightLowerBack_x1 569
#define Child_RightLowerBack_x2 613
#define Child_RightLowerBack_y1 306
#define Child_RightLowerBack_y2 350

#define Child_BackLeftUpperArm_x1 482
#define Child_BackLeftUpperArm_x2 524
#define Child_BackLeftUpperArm_y1 246
#define Child_BackLeftUpperArm_y2 260

#define Child_BackRightUpperArm_x1 618
#define Child_BackRightUpperArm_x2 675
#define Child_BackRightUpperArm_y1 233
#define Child_BackRightUpperArm_y2 260

#define Child_BackLeftLowerArm_x1 454
#define Child_BackLeftLowerArm_x2 486
#define Child_BackLeftLowerArm_y1 246
#define Child_BackLeftLowerArm_y2 266

#define Child_BackRightLowerArm_x1 687
#define Child_BackRightLowerArm_x2 740
#define Child_BackRightLowerArm_y1 239
#define Child_BackRightLowerArm_y2 256

#define Child_BackLeftHand_x1 420
#define Child_BackLeftHand_x2 447
#define Child_BackLeftHand_y1 253
#define Child_BackLeftHand_y2 268

#define Child_BackRightHand_x1 743
#define Child_BackRightHand_x2 788
#define Child_BackRightHand_y1 244
#define Child_BackRightHand_y2 268

#define Child_LeftButtock_x1 537
#define Child_LeftButtock_x2 565
#define Child_LeftButtock_y1 360
#define Child_LeftButtock_y2 390

#define Child_RightButtock_x1 567
#define Child_RightButtock_x2 618
#define Child_RightButtock_y1 357
#define Child_RightButtock_y2 387

#define Child_BackLeftUpperLeg_x1 535
#define Child_BackLeftUpperLeg_x2 570
#define Child_BackLeftUpperLeg_y1 395
#define Child_BackLeftUpperLeg_y2 452

#define Child_BackRightUpperLeg_x1 581
#define Child_BackRightUpperLeg_x2 616
#define Child_BackRightUpperLeg_y1 399
#define Child_BackRightUpperLeg_y2 450

#define Child_BackLeftKnee_x1 541
#define Child_BackLeftKnee_x2 563
#define Child_BackLeftKnee_y1 454
#define Child_BackLeftKnee_y2 478

#define Child_BackRightKnee_x1 589
#define Child_BackRightKnee_x2 614
#define Child_BackRightKnee_y1 461
#define Child_BackRightKnee_y2 479

#define Child_BackLeftLowerLeg_x1 535
#define Child_BackLeftLowerLeg_x2 560
#define Child_BackLeftLowerLeg_y1 480
#define Child_BackLeftLowerLeg_y2 534

#define Child_BackRightLowerLeg_x1 587
#define Child_BackRightLowerLeg_x2 612
#define Child_BackRightLowerLeg_y1 484
#define Child_BackRightLowerLeg_y2 535

#define Child_BackLeftFoot_x1 538
#define Child_BackLeftFoot_x2 568
#define Child_BackLeftFoot_y1 546
#define Child_BackLeftFoot_y2 562

#define Child_BackRightFoot_x1 589
#define Child_BackRightFoot_x2 625
#define Child_BackRightFoot_y1 551
#define Child_BackRightFoot_y2 565


#define FeMale_Head_x1 575
#define FeMale_Head_x2 621
#define FeMale_Head_y1 99
#define FeMale_Head_y2 152
#define FeMale_Neck_x1 589
#define FeMale_Neck_x2 624
#define FeMale_Neck_y1 165
#define FeMale_Neck_y2 177

#define FeMale_RightChest_x1 556
#define FeMale_RightChest_x2 578
#define FeMale_RightChest_y1 189
#define FeMale_RightChest_y2 263

#define FeMale_LeftChest_x1 594
#define FeMale_LeftChest_x2 624
#define FeMale_LeftChest_y1 181
#define FeMale_LeftChest_y2 263

#define FeMale_Abdomen_x1 561
#define FeMale_Abdomen_x2 631
#define FeMale_Abdomen_y1 276
#define FeMale_Abdomen_y2 342

#define FeMale_Genitals_x1 575
#define FeMale_Genitals_x2 598
#define FeMale_Genitals_y1 349
#define FeMale_Genitals_y2 367

#define FeMale_RightUpperLeg_x1 547
#define FeMale_RightUpperLeg_x2 591
#define FeMale_RightUpperLeg_y1 369
#define FeMale_RightUpperLeg_y2 465

#define FeMale_LeftUpperLeg_x1 599
#define FeMale_LeftUpperLeg_x2 640
#define FeMale_LeftUpperLeg_y1 370
#define FeMale_LeftUpperLeg_y2 465

#define FeMale_FrontRightKnee_x1 561
#define FeMale_FrontRightKnee_x2 591
#define FeMale_FrontRightKnee_y1 470
#define FeMale_FrontRightKnee_y2 504

#define FeMale_FrontLeftKnee_x1 608
#define FeMale_FrontLeftKnee_x2 641
#define FeMale_FrontLeftKnee_y1 473
#define FeMale_FrontLeftKnee_y2 500

#define FeMale_RightLowerLeg_x1 562
#define FeMale_RightLowerLeg_x2 588
#define FeMale_RightLowerLeg_y1 509
#define FeMale_RightLowerLeg_y2 590

#define FeMale_LeftLowerLeg_x1 615
#define FeMale_LeftLowerLeg_x2 642
#define FeMale_LeftLowerLeg_y1 505
#define FeMale_LeftLowerLeg_y2 604

#define FeMale_FrontRightFoot_x1 537
#define FeMale_FrontRightFoot_x2 586
#define FeMale_FrontRightFoot_y1 615
#define FeMale_FrontRightFoot_y2 633

#define FeMale_FrontLeftFoot_x1 607
#define FeMale_FrontLeftFoot_x2 640
#define FeMale_FrontLeftFoot_y1 618
#define FeMale_FrontLeftFoot_y2 645

#define FeMale_RightUpperArm_x1 510
#define FeMale_RightUpperArm_x2 552
#define FeMale_RightUpperArm_y1 189
#define FeMale_RightUpperArm_y2 212

#define FeMale_RightLowerArm_x1 434
#define FeMale_RightLowerArm_x2 503
#define FeMale_RightLowerArm_y1 197
#define FeMale_RightLowerArm_y2 216

#define FeMale_RightHand_x1 387
#define FeMale_RightHand_x2 432
#define FeMale_RightHand_y1 201
#define FeMale_RightHand_y2 211

#define FeMale_LeftUpperArm_x1 650
#define FeMale_LeftUpperArm_x2 706
#define FeMale_LeftUpperArm_y1 182
#define FeMale_LeftUpperArm_y2 198

#define FeMale_LeftLowerArm_x1 710
#define FeMale_LeftLowerArm_x2 758
#define FeMale_LeftLowerArm_y1 176
#define FeMale_LeftLowerArm_y2 189

#define FeMale_LeftHand_x1 761
#define FeMale_LeftHand_x2 809
#define FeMale_LeftHand_y1 168
#define FeMale_LeftHand_y2 186



#define FeMale_BackHead_x1 540
#define FeMale_BackHead_x2 591
#define FeMale_BackHead_y1 90
#define FeMale_BackHead_y2 141

#define FeMale_BackNeck_x1 547
#define FeMale_BackNeck_x2 573
#define FeMale_BackNeck_y1 151
#define FeMale_BackNeck_y2 169

#define FeMale_LeftUpperBack_x1 515
#define FeMale_LeftUpperBack_x2 554
#define FeMale_LeftUpperBack_y1 183
#define FeMale_LeftUpperBack_y2 240

#define FeMale_RightUpperBack_x1 558
#define FeMale_RightUpperBack_x2 594
#define FeMale_RightUpperBack_y1 181
#define FeMale_RightUpperBack_y2 248

#define FeMale_LeftLowerBack_x1 531
#define FeMale_LeftLowerBack_x2 558
#define FeMale_LeftLowerBack_y1 247
#define FeMale_LeftLowerBack_y2 297

#define FeMale_RightLowerBack_x1 558
#define FeMale_RightLowerBack_x2 605
#define FeMale_RightLowerBack_y1 253
#define FeMale_RightLowerBack_y2 304

#define FeMale_LeftButtock_x1 515
#define FeMale_LeftButtock_x2 560
#define FeMale_LeftButtock_y1 331
#define FeMale_LeftButtock_y2 374

#define FeMale_RightButtock_x1 561
#define FeMale_RightButtock_x2 620
#define FeMale_RightButtock_y1 328
#define FeMale_RightButtock_y2 373

#define FeMale_LeftBackUpperLeg_x1 518
#define FeMale_LeftBackUpperLeg_x2 555
#define FeMale_LeftBackUpperLeg_y1 380
#define FeMale_LeftBackUpperLeg_y2 468

#define FeMale_RightBackUpperLeg_x1 575
#define FeMale_RightBackUpperLeg_x2 604
#define FeMale_RightBackUpperLeg_y1 383
#define FeMale_RightBackUpperLeg_y2 476

#define FeMale_BackLeftKnee_x1 528
#define FeMale_BackLeftKnee_x2 547
#define FeMale_BackLeftKnee_y1 475
#define FeMale_BackLeftKnee_y2 518

#define FeMale_BackRightKnee_x1 580
#define FeMale_BackRightKnee_x2 606
#define FeMale_BackRightKnee_y1 480
#define FeMale_BackRightKnee_y2 521

#define FeMale_BackLeftLowerLeg_x1 523
#define FeMale_BackLeftLowerLeg_x2 544
#define FeMale_BackLeftLowerLeg_y1 502
#define FeMale_BackLeftLowerLeg_y2 600

#define FeMale_BackRightLowerLeg_x1 578
#define FeMale_BackRightLowerLeg_x2 604
#define FeMale_BackRightLowerLeg_y1 513
#define FeMale_BackRightLowerLeg_y2 605

#define FeMale_BackLeftFoot_x1 524
#define FeMale_BackLeftFoot_x2 552
#define FeMale_BackLeftFoot_y1 610
#define FeMale_BackLeftFoot_y2 628

#define FeMale_BackRightFoot_x1 583
#define FeMale_BackRightFoot_x2 628
#define FeMale_BackRightFoot_y1 613
#define FeMale_BackRightFoot_y2 637

#define FeMale_BackLeftUpperArm_x1 467
#define FeMale_BackLeftUpperArm_x2 511
#define FeMale_BackLeftUpperArm_y1 196
#define FeMale_BackLeftUpperArm_y2 209

#define FeMale_BackLeftLowerArm_x1 418
#define FeMale_BackLeftLowerArm_x2 451
#define FeMale_BackLeftLowerArm_y1 195
#define FeMale_BackLeftLowerArm_y2 212

#define FeMale_BackLeftHand_x1 383
#define FeMale_BackLeftHand_x2 412
#define FeMale_BackLeftHand_y1 206
#define FeMale_BackLeftHand_y2 218

#define FeMale_BackRightUpperArm_x1 608
#define FeMale_BackRightUpperArm_x2 677
#define FeMale_BackRightUpperArm_y1 181
#define FeMale_BackRightUpperArm_y2 201

#define FeMale_BackRightLowerArm_x1 682
#define FeMale_BackRightLowerArm_x2 761
#define FeMale_BackRightLowerArm_y1 183
#define FeMale_BackRightLowerArm_y2 196

#define FeMale_BackRightHand_x1 766
#define FeMale_BackRightHand_x2 809
#define FeMale_BackRightHand_y1 187
#define FeMale_BackRightHand_y2 203


#define Male_Head_x1 573
#define Male_Head_x2 618
#define Male_Head_y1 108
#define Male_Head_y2 163
#define Male_Neck_x1 585
#define Male_Neck_x2 621
#define Male_Neck_y1 170
#define Male_Neck_y2 183

#define Male_RightChest_x1 552
#define Male_RightChest_x2 576
#define Male_RightChest_y1 193
#define Male_RightChest_y2 251

#define Male_LeftChest_x1 598
#define Male_LeftChest_x2 636
#define Male_LeftChest_y1 189
#define Male_LeftChest_y2 263

#define Male_Abdomen_x1 557
#define Male_Abdomen_x2 628
#define Male_Abdomen_y1 268
#define Male_Abdomen_y2 339

#define Male_Genitals_x1 565
#define Male_Genitals_x2 594
#define Male_Genitals_y1 351
#define Male_Genitals_y2 375

#define Male_RightUpperLeg_x1 549
#define Male_RightUpperLeg_x2 592
#define Male_RightUpperLeg_y1 379
#define Male_RightUpperLeg_y2 460

#define Male_LeftUpperLeg_x1 591
#define Male_LeftUpperLeg_x2 636
#define Male_LeftUpperLeg_y1 376
#define Male_LeftUpperLeg_y2 463

#define Male_FrontRightKnee_x1 557
#define Male_FrontRightKnee_x2 588
#define Male_FrontRightKnee_y1 466
#define Male_FrontRightKnee_y2 501

#define Male_FrontLeftKnee_x1 602
#define Male_FrontLeftKnee_x2 639
#define Male_FrontLeftKnee_y1 475
#define Male_FrontLeftKnee_y2 506


#define Male_RightLowerLeg_x1 558
#define Male_RightLowerLeg_x2 585
#define Male_RightLowerLeg_y1 503
#define Male_RightLowerLeg_y2 585

#define Male_LeftLowerLeg_x1 614
#define Male_LeftLowerLeg_x2 638
#define Male_LeftLowerLeg_y1 512
#define Male_LeftLowerLeg_y2 598

#define Male_FrontRightFoot_x1 526
#define Male_FrontRightFoot_x2 585
#define Male_FrontRightFoot_y1 608
#define Male_FrontRightFoot_y2 629

#define Male_FrontLeftFoot_x1 595
#define Male_FrontLeftFoot_x2 637
#define Male_FrontLeftFoot_y1 613
#define Male_FrontLeftFoot_y2 645


#define Male_RightUpperArm_x1 500
#define Male_RightUpperArm_x2 549
#define Male_RightUpperArm_y1 203
#define Male_RightUpperArm_y2 227

#define Male_RightLowerArm_x1 435
#define Male_RightLowerArm_x2 496
#define Male_RightLowerArm_y1 208
#define Male_RightLowerArm_y2 227

#define Male_RightHand_x1 383
#define Male_RightHand_x2 432
#define Male_RightHand_y1 208
#define Male_RightHand_y2 229

#define Male_LeftUpperArm_x1 654
#define Male_LeftUpperArm_x2 707
#define Male_LeftUpperArm_y1 182
#define Male_LeftUpperArm_y2 213

#define Male_LeftLowerArm_x1 710
#define Male_LeftLowerArm_x2 761
#define Male_LeftLowerArm_y1 183
#define Male_LeftLowerArm_y2 202

#define Male_LeftHand_x1 758
#define Male_LeftHand_x2 811
#define Male_LeftHand_y1 176
#define Male_LeftHand_y2 199

#define Male_BackHead_x1 548
#define Male_BackHead_x2 595
#define Male_BackHead_y1 117
#define Male_BackHead_y2 160

#define Male_BackNeck_x1 552
#define Male_BackNeck_x2 581
#define Male_BackNeck_y1 165
#define Male_BackNeck_y2 181

#define Male_LeftUpperBack_x1 520
#define Male_LeftUpperBack_x2 558
#define Male_LeftUpperBack_y1 192
#define Male_LeftUpperBack_y2 245

#define Male_RightUpperBack_x1 570
#define Male_RightUpperBack_x2 616
#define Male_RightUpperBack_y1 191
#define Male_RightUpperBack_y2 265

#define Male_LeftLowerBack_x1 530
#define Male_LeftLowerBack_x2 561
#define Male_LeftLowerBack_y1 258
#define Male_LeftLowerBack_y2 332

#define Male_RightLowerBack_x1 556
#define Male_RightLowerBack_x2 611
#define Male_RightLowerBack_y1 251
#define Male_RightLowerBack_y2 327

#define Male_LeftButtock_x1 538
#define Male_LeftButtock_x2 568
#define Male_LeftButtock_y1 338
#define Male_LeftButtock_y2 386

#define Male_RightButtock_x1 570
#define Male_RightButtock_x2 622
#define Male_RightButtock_y1 329
#define Male_RightButtock_y2 386

#define Male_LeftBackUpperLeg_x1 533
#define Male_LeftBackUpperLeg_x2 570
#define Male_LeftBackUpperLeg_y1 388
#define Male_LeftBackUpperLeg_y2 461

#define Male_RightBackUpperLeg_x1 575
#define Male_RightBackUpperLeg_x2 621
#define Male_RightBackUpperLeg_y1 389
#define Male_RightBackUpperLeg_y2 463

#define Male_BackLeftKnee_x1 536
#define Male_BackLeftKnee_x2 560
#define Male_BackLeftKnee_y1 468
#define Male_BackLeftKnee_y2 496

#define Male_BackRightKnee_x1 586
#define Male_BackRightKnee_x2 613
#define Male_BackRightKnee_y1 463
#define Male_BackRightKnee_y2 496

#define Male_BackLeftLowerLeg_x1 522
#define Male_BackLeftLowerLeg_x2 553
#define Male_BackLeftLowerLeg_y1 494
#define Male_BackLeftLowerLeg_y2 587

#define Male_BackRightLowerLeg_x1 583
#define Male_BackRightLowerLeg_x2 614
#define Male_BackRightLowerLeg_y1 497
#define Male_BackRightLowerLeg_y2 589

#define Male_BackLeftFoot_x1 530
#define Male_BackLeftFoot_x2 561
#define Male_BackLeftFoot_y1 592
#define Male_BackLeftFoot_y2 613

#define Male_BackRightFoot_x1 592
#define Male_BackRightFoot_x2 636
#define Male_BackRightFoot_y1 595
#define Male_BackRightFoot_y2 621

#define Male_BackLeftUpperArm_x1 467
#define Male_BackLeftUpperArm_x2 508
#define Male_BackLeftUpperArm_y1 197
#define Male_BackLeftUpperArm_y2 224

#define Male_BackLeftLowerArm_x1 416
#define Male_BackLeftLowerArm_x2 450
#define Male_BackLeftLowerArm_y1 207
#define Male_BackLeftLowerArm_y2 235

#define Male_BackLeftHand_x1 381
#define Male_BackLeftHand_x2 408
#define Male_BackLeftHand_y1 218
#define Male_BackLeftHand_y2 233

#define Male_BackRightUpperArm_x1 620
#define Male_BackRightUpperArm_x2 688
#define Male_BackRightUpperArm_y1 191
#define Male_BackRightUpperArm_y2 220

#define Male_BackRightLowerArm_x1 692
#define Male_BackRightLowerArm_x2 765
#define Male_BackRightLowerArm_y1 196
#define Male_BackRightLowerArm_y2 220

#define Male_BackRightHand_x1 768
#define Male_BackRightHand_x2 818
#define Male_BackRightHand_y1 203
#define Male_BackRightHand_y2 224

@interface DiagramViewController ()
{
    bool needSave;
    NSString* ticketID;
}
@end

@implementation DiagramViewController
@synthesize imageView;
@synthesize popover;
@synthesize injuryArray;
@synthesize tvInjury;
@synthesize injurySelected;
@synthesize location;
@synthesize currentImage;
@synthesize delegate;
@synthesize btnNameLabel;
@synthesize btnClear;
@synthesize btnFreeDrawing;
@synthesize btnShowBack;
@synthesize injurySelectedBack;
@synthesize currentImageBack;
@synthesize currentImageDraw;
@synthesize currentImageDrawBack;
@synthesize defaultImage;
@synthesize defaultImageBack;
@synthesize injurySelectedAll;
@synthesize btnQAMessage;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    needSave = false;
    NSString* patientName;

    @synchronized(g_SYNCDATADB)
    {
        patientName =  [DAO getPatientName:ticketID db:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue]];
    }
    btnNameLabel.title = patientName;
    [btnNameLabel setTintColor:[UIColor whiteColor]];
    
    
    self.injurySelected = [[NSMutableArray alloc] init];
    self.injurySelectedBack = [[NSMutableArray alloc] init];
    self.injurySelectedAll = [[NSMutableArray alloc] init];
    [self setAge];
    
    if (age < 13)
    {
        self.defaultImage = [UIImage imageNamed:@"ChildFront.JPG"];
        self.defaultImageBack = [UIImage imageNamed:@"ChildBack.JPG"];
        self.currentImage = [UIImage imageNamed:@"ChildFront.JPG"];
        self.currentImageBack = [UIImage imageNamed:@"ChildBack.JPG"];
        self.currentImageDraw = [UIImage imageNamed:@"ChildFront.JPG"];
        self.currentImageDrawBack = [UIImage imageNamed:@"ChildBack.JPG"];
        [imageView setImage:currentImage];
        ageSex = 1;
    }
    else
    {
        if ([sex isEqualToString:@"Female"])
        {
            self.defaultImage = [UIImage imageNamed:@"FemaleFront.JPG"];
            self.defaultImageBack = [UIImage imageNamed:@"FemaleBack.JPG"];
            self.currentImage = [UIImage imageNamed:@"FemaleFront.JPG"];
            self.currentImageBack = [UIImage imageNamed:@"FemaleBack.JPG"];
            self.currentImageDraw = [UIImage imageNamed:@"FemaleFront.JPG"];
            self.currentImageDrawBack = [UIImage imageNamed:@"FemaleBack.JPG"];
            [imageView setImage:currentImage];
            ageSex = 2;
        }
        else
        {
            self.defaultImage = [UIImage imageNamed:@"MaleFront.JPG"];
            self.defaultImageBack = [UIImage imageNamed:@"MaleBack.JPG"];
            self.currentImage = [UIImage imageNamed:@"MaleFront.JPG"];
            self.currentImageBack = [UIImage imageNamed:@"MaleBack.JPG"];
            self.currentImageDraw = [UIImage imageNamed:@"MaleFront.JPG"];
            self.currentImageDrawBack = [UIImage imageNamed:@"MaleBack.JPG"];
            [imageView setImage:currentImage];
            ageSex = 3;
        }
        
    }
    [self loadData];
    NSString* ticketStatus = [g_SETTINGS objectForKey:@"TicketStatus"];
    if ([ticketStatus intValue] != 3)
    {
        self.btnQAMessage.hidden = true;
    }
}

- (void) loadData
{

    NSString* sql = [NSString stringWithFormat:@"Select T.LocalTicketID, T.TicketID, T.TicketGUID, T.TicketCrew, T.TicketIncidentNumber, T.TicketDesc,  T.TicketDOS, T.TicketPractice, TI.* from Tickets T inner join TicketInputs TI on T.TicketID = TI.TicketID where T.TicketID = %@ and ti.inputID in (9001, 9002)", ticketID ];
    NSMutableDictionary* ticketInputData;
    @synchronized(g_SYNCDATADB)
    {
        ticketInputData = [DAO executeSelectTicketInputsData:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sql];
    }
    
    if ([[ticketInputData objectForKey:@"9002:0:1"] length] > 0 && ([[ticketInputData objectForKey:@"9002:0:1"] rangeOfString:@"(null)"].location == NSNotFound))
    {
        NSString* data = [ticketInputData objectForKey:@"9002:0:1"];
        if ([data isEqualToString:@"Male"])
        {
            if (age < 13 || ageSex != 3)
            {
                return;
            }
        }
        else if ([data isEqualToString:@"Female"])
        {
            if (age < 13 || ageSex != 2)
            {
                return;
            }
            
        }
        else if ([data isEqualToString:@"Infant"])
        {
            if (age > 12 || ageSex != 1)
            {
                return;
            }
            
        }
    }
    else
    {
        return;
    }
    
    if ([[ticketInputData objectForKey:@"9001:0:1"] length] > 0 && ([[ticketInputData objectForKey:@"9001:0:1"] rangeOfString:@"(null)"].location == NSNotFound))
    {
       NSString* data = [ticketInputData objectForKey:@"9001:0:1"];
        NSArray* dataArray = [data componentsSeparatedByString:@"|"];
        for (int i = 0; i < [dataArray count]-1; i++)
        {
            @try {
                ClsInjuryType* type = [[ClsInjuryType alloc] init];
                NSString* item = [dataArray objectAtIndex:i];
                NSRange range = [item rangeOfString:@":"];
                type.area = [item substringToIndex:range.location];
                NSString* remainder = [item substringFromIndex:range.location+2];
                NSArray* remainderArray = [remainder componentsSeparatedByString:@","];
                float x = 0;
                float y = 0;
                for (int j = 0; j < [remainderArray count]; j ++)
                {
                    if (j == 0)
                    {
                        type.type = [remainderArray objectAtIndex:j];
                    }
                    else if (j == 1)
                    {
                        NSString* viewPos = [remainderArray objectAtIndex:j];
                        if ([viewPos rangeOfString:@"F"].location == NSNotFound)
                        {
                            type.front = 1;
                        }
                        else
                        {
                            type.front = 0;
                        }
                    }
                    else if (j == 2)
                    {
                        x = [[remainderArray objectAtIndex:j] floatValue];
                    }
                    else if (j == 3)
                    {
                        y = [[remainderArray objectAtIndex:j] floatValue];
                        CGPoint point = CGPointMake(x, y);
                        type.location = point;
                    }
                }
                [injurySelectedAll addObject:type];
            }
            @catch (NSException *exception) {

            }
            
        }
    }
    
    if ([[ticketInputData objectForKey:@"9002:0:1"] length] > 0 && ([[ticketInputData objectForKey:@"9002:0:1"] rangeOfString:@"(null)"].location == NSNotFound))
    {
        sql = [NSString stringWithFormat:@"Select * from TicketAttachments where TicketID = %@ and AttachmentId = 2", ticketID ];
        NSMutableArray* frontImageArray;
        @synchronized(g_SYNCBLOBSDB)
        {
            frontImageArray = [DAO executeSelectTicketAttachments:[[g_SETTINGS objectForKey:@"blobsDB"] pointerValue] Sql:sql];

        }
        if ([frontImageArray count] > 0)
        {
            ClsTicketAttachments* attachment = [frontImageArray objectAtIndex:0];
            NSString* fileStr = attachment.fileStr;
            NSData* data = [Base64 decode:fileStr];
            self.currentImage = [UIImage imageWithData:data];
            self.currentImageDraw = currentImage;
        }

        sql = [NSString stringWithFormat:@"Select * from TicketAttachments where TicketID = %@ and AttachmentID = 4", ticketID ];
        NSMutableArray* backImageArray;
        @synchronized(g_SYNCBLOBSDB)
        {
            backImageArray = [DAO executeSelectTicketAttachments:[[g_SETTINGS objectForKey:@"blobsDB"] pointerValue] Sql:sql];
            
        }
        if ([backImageArray count] > 0)
        {
            ClsTicketAttachments* attachment = [backImageArray objectAtIndex:0];
            NSString* fileStr = attachment.fileStr;
            NSData* data = [Base64 decode:fileStr];
            self.currentImageBack = [UIImage imageWithData:data];
            self.currentImageDrawBack = currentImageBack;
        }
        
        
       NSString* data = [ticketInputData objectForKey:@"9002:0:1"];
       if ([data isEqualToString:@"Male"])
       {
           self.defaultImage = [UIImage imageNamed:@"MaleFront.JPG"];
           self.defaultImageBack = [UIImage imageNamed:@"MaleBack.JPG"];
          // self.currentImageBack = [UIImage imageNamed:@"MaleBack.JPG"];

           [imageView setImage:currentImage];
           ageSex = 3;
       }
        else if ([data isEqualToString:@"Female"])
        {
            self.defaultImage = [UIImage imageNamed:@"FemaleFront.JPG"];
            self.defaultImageBack = [UIImage imageNamed:@"FemaleBack.JPG"];
          //  self.currentImageBack = [UIImage imageNamed:@"FemaleBack.JPG"];

            [imageView setImage:currentImage];
            ageSex = 2;
        }
        else
        {
            self.defaultImage = [UIImage imageNamed:@"ChildFront.JPG"];
            self.defaultImageBack = [UIImage imageNamed:@"ChildBack.JPG"];
           // self.currentImageBack = [UIImage imageNamed:@"ChildBack.JPG"];
 
            [imageView setImage:currentImage];
            ageSex = 1;
        }
        
    }
    [self loadFrontView];
    [tvInjury reloadData];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    ticketID = [g_SETTINGS objectForKey:@"currentTicketID"];
    UIImage *toolBarIMG = [UIImage imageNamed:@"navigation_bar_bkg.png"];
    [self.toolBar setBackgroundImage:toolBarIMG forToolbarPosition:0 barMetrics:0];
    toolBarIMG = nil;
    
    NSString* ticketStatus = [g_SETTINGS objectForKey:@"TicketStatus"];
    if ([ticketStatus intValue] != 3)
    {
        self.btnQAMessage.hidden = true;
    }
    frontView = true;
    isDrawing = false;
    btnClear.enabled = false;
    rowSelected = -1;
    frontDraw = false;
    backDraw = false;
    frontImageTouch = false;
    backImageTouch = false;
    
	//[self.navigationController setNavigationBarHidden:TRUE];
    
   // [self setViewUI];
    
}


- (void) setAge
{
    
    NSString* sql = [NSString stringWithFormat:@"Select T.LocalTicketID, T.TicketID, T.TicketGUID, T.TicketCrew, T.TicketIncidentNumber, T.TicketDesc,  T.TicketDOS, T.TicketPractice, TI.* from Tickets T inner join TicketInputs TI on T.TicketID = TI.TicketID where T.TicketID = %@ and InputID in (1119, 1105, 1134)", ticketID ];
    NSMutableDictionary* ticketInputData;
    @synchronized(g_SYNCDATADB)
    {
        ticketInputData = [DAO executeSelectTicketInputsData:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sql];
    }
    
    NSString* ageUnit;
    if ([[ticketInputData objectForKey:@"1134:0:1"] length] > 0 && ([[ticketInputData objectForKey:@"1134:0:1"] rangeOfString:@"(null)"].location == NSNotFound))
    {
        ageUnit = [ticketInputData objectForKey:@"1134:0:1"];
    }
    
    if ([[ticketInputData objectForKey:@"1119:0:1"] length] > 0 && ([[ticketInputData objectForKey:@"1119:0:1"] rangeOfString:@"(null)"].location == NSNotFound))
    {
        if (ageUnit == nil || ageUnit.length < 1 || [ageUnit isEqualToString:@"Years"])
        {
            age = [[ticketInputData objectForKey:@"1119:0:1"] integerValue];
        }
        else if ([ageUnit isEqualToString:@"Months"])
        {
            age = floor([[ticketInputData objectForKey:@"1119:0:1"] integerValue]/12);
        }
        else if ([ageUnit isEqualToString:@"Days"])
        {
            age = floor([[ticketInputData objectForKey:@"1119:0:1"] integerValue]/365);
        }
        else if ([ageUnit isEqualToString:@"Hours"])
        {
            age = floor([[ticketInputData objectForKey:@"1119:0:1"] integerValue]/8760);
        }
        else if ([ageUnit isEqualToString:@"Minutes"])
        {
            age = floor([[ticketInputData objectForKey:@"1119:0:1"] integerValue]/525600);
        }
        
        
    }
    else
    {
        age = 20;
    }
    if ([[ticketInputData objectForKey:@"1105:0:1"] length] > 0 && ([[ticketInputData objectForKey:@"1105:0:1"] rangeOfString:@"(null)"].location == NSNotFound))
    {
        sex = [ticketInputData objectForKey:@"1105:0:1"];
    }
    

}


- (void) doneSelected
{
    PopupInjuryTypeViewController *p = (PopupInjuryTypeViewController *) popover.contentViewController;
    bool found = false;
    
    ClsInjuryType* selected = [[ClsInjuryType alloc] init];
    selected.area = p.area;
    ClsTableKey* key = [injuryArray objectAtIndex:p.rowSelected];
    if (p.rowSelected == 9)
    {
        selected.type = [NSString stringWithFormat:@"%@ %@", key.desc, p.burnDegree];
    }
    else
    {
        selected.type = key.desc;
    }
    selected.location = self.location;
    
    for (int i = 0; i< [injurySelectedAll count]; i++)
    {
        ClsInjuryType* injury = [injurySelectedAll objectAtIndex:i];
        if ([p.area isEqualToString:injury.area] && [key.desc isEqualToString:injury.type])
        {
            found = true;
        }
    }
    if (!found)
    {
        needSave = true;
        if (frontView)
        {
            selected.front = 0;
            [injurySelectedAll addObject:selected];
            [self.popover dismissPopoverAnimated:YES];
            self.popover = nil;
            [tvInjury reloadData];
            
            UIImage* backgroundImage = currentImageDraw;
            CGSize size = CGSizeMake(479, 610);
            UIGraphicsBeginImageContext(size);
            [backgroundImage drawInRect:CGRectMake(0, 0, 479, 610)];
            for (int i = 0; i< [injurySelectedAll count]; i++)
            {
                ClsInjuryType* current = [injurySelectedAll objectAtIndex:i];
                if (current.front == 0)
                {
                    UIImage* watermarkImage = [UIImage imageNamed:[NSString stringWithFormat:@"Mark%d.gif", i + 1]];
                    ClsInjuryType* temp = [injurySelectedAll objectAtIndex:i];
                    [watermarkImage drawInRect:CGRectMake(temp.location.x - 375, temp.location.y - 70, watermarkImage.size.width, watermarkImage.size.height)];
                }
                
            }
            UIImage* result = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            self.currentImage = result;
            [imageView setImage:currentImage];
        }
        else
        {
            selected.front = 1;
            [injurySelectedAll addObject:selected];
            [self.popover dismissPopoverAnimated:YES];
            self.popover = nil;
            [tvInjury reloadData];
            
            UIImage* backgroundImage = currentImageDrawBack;
            CGSize size = CGSizeMake(479, 610);
            UIGraphicsBeginImageContext(size);
            [backgroundImage drawInRect:CGRectMake(0, 0, 479, 610)];
            for (int i = 0; i< [injurySelectedAll count]; i++)
            {
                ClsInjuryType* current = [injurySelectedAll objectAtIndex:i];
                if (current.front == 1)
                {
                    UIImage* watermarkImage = [UIImage imageNamed:[NSString stringWithFormat:@"Mark%d.gif", i + 1]];
                    ClsInjuryType* temp = [injurySelectedAll objectAtIndex:i];
                    [watermarkImage drawInRect:CGRectMake(temp.location.x - 375, temp.location.y - 70, watermarkImage.size.width, watermarkImage.size.height)];
                }
                
            }
            UIImage* result = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            self.currentImageBack = result;
            [imageView setImage:currentImageBack];
        }
    }
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if (isDrawing)
    {
        if (frontView)
        {
            self.imageView.image = currentImageDraw;
        }
        else
        {
            self.imageView.image = currentImageDrawBack;
        }
        UITouch *touch = [touches anyObject];
        self.location = [touch locationInView:self.imageView];
    }
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    if (isDrawing)
    {
        UITouch *touch = [touches anyObject];
        CGPoint currentLocation = [touch locationInView:self.imageView];
        
        UIGraphicsBeginImageContext(self.imageView.frame.size);
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        [self.imageView.image drawInRect:CGRectMake(0, 0, self.imageView.frame.size.width, self.imageView.frame.size.height)];
        CGContextSetLineCap(ctx, kCGLineCapRound);
        CGContextSetLineWidth(ctx, 5.0);
        CGContextSetRGBStrokeColor(ctx, 1.0, 0.0, 0.0, 1.0);
        CGContextBeginPath(ctx);
        CGContextMoveToPoint(ctx, location.x, location.y);
        CGContextAddLineToPoint(ctx, currentLocation.x, currentLocation.y);
        CGContextStrokePath(ctx);
        self.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        location = currentLocation;
    }
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (isDrawing)
    {

        UITouch *touch = [touches anyObject];
        CGPoint currentLocation = [touch locationInView:self.imageView];
        
        UIGraphicsBeginImageContext(self.imageView.frame.size);
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        [self.imageView.image drawInRect:CGRectMake(0, 0, self.imageView.frame.size.width, self.imageView.frame.size.height)];

        CGContextSetLineCap(ctx, kCGLineCapRound);
        CGContextSetLineWidth(ctx, 5.0);
        CGContextSetRGBStrokeColor(ctx, 1.0, 0.0, 0.0, 1.0);
        CGContextBeginPath(ctx);
        CGContextMoveToPoint(ctx, location.x, location.y);
        CGContextAddLineToPoint(ctx, currentLocation.x, currentLocation.y);
        CGContextStrokePath(ctx);
        self.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
        if (frontView)
        {
            self.currentImageDraw = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            frontImageTouch = true;
            
            UIImage* backgroundImage = currentImageDraw;
            CGSize size = CGSizeMake(479, 610);
            UIGraphicsBeginImageContext(size);
            [backgroundImage drawInRect:CGRectMake(0, 0, 479, 610)];
            for (int i = 0; i< [injurySelectedAll count]; i++)
            {
                ClsInjuryType* current = [injurySelectedAll objectAtIndex:i];
                if (current.front == 0)
                {
                    UIImage* watermarkImage = [UIImage imageNamed:[NSString stringWithFormat:@"Mark%d.gif", i + 1]];
                    ClsInjuryType* temp = [injurySelectedAll objectAtIndex:i];
                    [watermarkImage drawInRect:CGRectMake(temp.location.x - 375, temp.location.y - 70, watermarkImage.size.width, watermarkImage.size.height)];
                }
                
            }
            UIImage* result = UIGraphicsGetImageFromCurrentImageContext();
            
            self.currentImage = result;
            [imageView setImage:currentImage];
            frontDraw = true;
        }
        else
        {
            self.currentImageDrawBack = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            backImageTouch = true;
            UIImage* backgroundImage = currentImageDrawBack;
            CGSize size = CGSizeMake(479, 610);
            UIGraphicsBeginImageContext(size);
            [backgroundImage drawInRect:CGRectMake(0, 0, 479, 610)];
            for (int i = 0; i< [injurySelectedAll count]; i++)
            {
                ClsInjuryType* current = [injurySelectedAll objectAtIndex:i];
                if (current.front == 1)
                {
                    UIImage* watermarkImage = [UIImage imageNamed:[NSString stringWithFormat:@"Mark%d.gif", i + 1]];
                    ClsInjuryType* temp = [injurySelectedAll objectAtIndex:i];
                    [watermarkImage drawInRect:CGRectMake(temp.location.x - 375, temp.location.y - 70, watermarkImage.size.width, watermarkImage.size.height)];
                }
                
            }
            UIImage* result = UIGraphicsGetImageFromCurrentImageContext();
            
            self.currentImageBack = result;
            [imageView setImage:currentImageBack];
            backDraw = true;
            UIGraphicsEndImageContext();
        }

        
        location = currentLocation;
    }
    else
    {
        UITouch* touch  = [[event allTouches] anyObject];
        
        self.location = [touch locationInView:self.view];
        NSLog(@"%f, %f", location.x, location.y);
        
        if (ageSex == 1)
        {
            if (frontView)
            {
                if ( (location.x > Child_FrontLeftHand_x1) && (location.x < Child_FrontLeftHand_x2) && (location.y>Child_FrontLeftHand_y1) && (location.y < Child_FrontLeftHand_y2) )
                {
                    if ([injuryArray count] < 1)
                    {
                        NSString* querySql = @"select InjuryID, 'InjuryType' , Type from InjuryType";
                        
                        @synchronized(g_SYNCLOOKUPDB)
                        {
                            self.injuryArray = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:querySql WithExtraInfo:NO];
                        }
                    }
                    
                    PopupInjuryTypeViewController* popoverView =[[PopupInjuryTypeViewController alloc] initWithNibName:@"PopupInjuryTypeViewController" bundle:nil];
                    
                    popoverView.area = @"Front Left Hand";
                    popoverView.array = self.injuryArray;
                    popoverView.view.backgroundColor = [UIColor whiteColor];//mani
                    self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
                    self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
                    self.popover.popoverContentSize = CGSizeMake(350, 400);
                    popoverView.delegate = self;
                    
                    CGRect frame = CGRectMake(self.location.x - 15, self.location.y - 200, 350, 400);

                    [self.popover presentPopoverFromRect:frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
                }
                
                else if ( (location.x > Child_FrontLeftLowerArm_x1) && (location.x < Child_FrontLeftLowerArm_x2) && (location.y>Child_FrontLeftLowerArm_y1) && (location.y < Child_FrontLeftLowerArm_y2) )
                {
                    if ([injuryArray count] < 1)
                    {
                        NSString* querySql = @"select InjuryID, 'InjuryType' , Type from InjuryType";
                        
                        @synchronized(g_SYNCLOOKUPDB)
                        {
                            self.injuryArray = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:querySql WithExtraInfo:NO];
                        }
                    }
                    
                    PopupInjuryTypeViewController* popoverView =[[PopupInjuryTypeViewController alloc] initWithNibName:@"PopupInjuryTypeViewController" bundle:nil];
                    
                    popoverView.area = @"Front Left Lower Arm";
                    popoverView.array = self.injuryArray;
                    popoverView.view.backgroundColor = [UIColor whiteColor];//mani
                    self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
                    self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
                    self.popover.popoverContentSize = CGSizeMake(350, 400);
                    popoverView.delegate = self;
                    
                    CGRect frame = CGRectMake(self.location.x - 15, self.location.y - 200, 350, 400);
                    
                    [self.popover presentPopoverFromRect:frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
                }
                
                else if ( (location.x > Child_FrontLeftUpperArm_x1) && (location.x < Child_FrontLeftUpperArm_x2) && (location.y>Child_FrontLeftUpperArm_y1) && (location.y < Child_FrontLeftUpperArm_y2) )
                {
                    if ([injuryArray count] < 1)
                    {
                        NSString* querySql = @"select InjuryID, 'InjuryType' , Type from InjuryType";
                        
                        @synchronized(g_SYNCLOOKUPDB)
                        {
                            self.injuryArray = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:querySql WithExtraInfo:NO];
                        }
                    }
                    
                    PopupInjuryTypeViewController* popoverView =[[PopupInjuryTypeViewController alloc] initWithNibName:@"PopupInjuryTypeViewController" bundle:nil];
                    
                    popoverView.area = @"Front Left Upper Arm";
                    popoverView.array = self.injuryArray;
                    popoverView.view.backgroundColor = [UIColor whiteColor];//mani
                    self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
                    self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
                    self.popover.popoverContentSize = CGSizeMake(350, 400);
                    popoverView.delegate = self;
                    
                    CGRect frame = CGRectMake(self.location.x - 15, self.location.y - 200, 350, 400);
                    
                    [self.popover presentPopoverFromRect:frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
                }
                
                else if ( (location.x > Child_FrontRightHand_x1) && (location.x < Child_FrontRightHand_x2) && (location.y>Child_FrontRightHand_y1) && (location.y < Child_FrontRightHand_y2) )
                {
                    if ([injuryArray count] < 1)
                    {
                        NSString* querySql = @"select InjuryID, 'InjuryType' , Type from InjuryType";
                        
                        @synchronized(g_SYNCLOOKUPDB)
                        {
                            self.injuryArray = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:querySql WithExtraInfo:NO];
                        }
                    }
                    
                    PopupInjuryTypeViewController* popoverView =[[PopupInjuryTypeViewController alloc] initWithNibName:@"PopupInjuryTypeViewController" bundle:nil];
                    popoverView.area = @"Front Right Hand";
                    popoverView.array = self.injuryArray;
                    popoverView.view.backgroundColor = [UIColor whiteColor];//mani
                    
                    self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
                    self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
                    self.popover.popoverContentSize = CGSizeMake(350, 400);
                    popoverView.delegate = self;
                    
                    CGRect frame = CGRectMake(self.location.x - 15, self.location.y - 200, 350, 400);
                    
                    [self.popover presentPopoverFromRect:frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
                }
                
                
                else if ( (location.x > Child_FrontRightLowerArm_x1) && (location.x < Child_FrontRightLowerArm_x2) && (location.y>Child_FrontRightLowerArm_y1) && (location.y < Child_FrontRightLowerArm_y2) )
                {
                    if ([injuryArray count] < 1)
                    {
                        NSString* querySql = @"select InjuryID, 'InjuryType' , Type from InjuryType";
                        
                        @synchronized(g_SYNCLOOKUPDB)
                        {
                            self.injuryArray = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:querySql WithExtraInfo:NO];
                        }
                    }
                    
                    PopupInjuryTypeViewController* popoverView =[[PopupInjuryTypeViewController alloc] initWithNibName:@"PopupInjuryTypeViewController" bundle:nil];
                    popoverView.area = @"Front Right Lower Arm";
                    popoverView.array = self.injuryArray;
                    popoverView.view.backgroundColor = [UIColor whiteColor];//mani
                    
                    self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
                    self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
                    self.popover.popoverContentSize = CGSizeMake(350, 400);
                    popoverView.delegate = self;
                    
                    CGRect frame = CGRectMake(self.location.x - 15, self.location.y - 200, 350, 400);
                    
                    [self.popover presentPopoverFromRect:frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
                }
                
                
                else if ( (location.x > Child_FrontRightUpperArm_x1) && (location.x < Child_FrontRightUpperArm_x2) && (location.y> Child_FrontRightUpperArm_y1) && (location.y < Child_FrontRightUpperArm_y2) )
                {
                    if ([injuryArray count] < 1)
                    {
                        NSString* querySql = @"select InjuryID, 'InjuryType' , Type from InjuryType";
                        
                        @synchronized(g_SYNCLOOKUPDB)
                        {
                            self.injuryArray = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:querySql WithExtraInfo:NO];
                        }
                    }
                    
                    PopupInjuryTypeViewController* popoverView =[[PopupInjuryTypeViewController alloc] initWithNibName:@"PopupInjuryTypeViewController" bundle:nil];
                    popoverView.area = @"Front Right Upper Arm";
                    popoverView.array = self.injuryArray;
                    popoverView.view.backgroundColor = [UIColor whiteColor];//mani
                    
                    self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
                    self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
                    self.popover.popoverContentSize = CGSizeMake(350, 400);
                    popoverView.delegate = self;
                    
                    CGRect frame = CGRectMake(self.location.x - 15, self.location.y - 200, 350, 400);
                    
                    [self.popover presentPopoverFromRect:frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
                }
                
                else if ( (location.x > Child_FrontRightFoot_x1) && (location.x < Child_FrontRightFoot_x2) && (location.y>Child_FrontRightFoot_y1) && (location.y < Child_FrontRightFoot_y2) )
                {
                    if ([injuryArray count] < 1)
                    {
                        NSString* querySql = @"select InjuryID, 'InjuryType' , Type from InjuryType";
                        
                        @synchronized(g_SYNCLOOKUPDB)
                        {
                            self.injuryArray = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:querySql WithExtraInfo:NO];
                        }
                    }
                    
                    PopupInjuryTypeViewController* popoverView =[[PopupInjuryTypeViewController alloc] initWithNibName:@"PopupInjuryTypeViewController" bundle:nil];
                    popoverView.area = @"Front Right Foot";
                    popoverView.array = self.injuryArray;
                    popoverView.view.backgroundColor = [UIColor whiteColor];//mani
                    
                    self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
                    self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
                    self.popover.popoverContentSize = CGSizeMake(350, 400);
                    popoverView.delegate = self;
                    
                    CGRect frame = CGRectMake(self.location.x - 15, self.location.y - 200, 350, 400);
                    
                    [self.popover presentPopoverFromRect:frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
                }
                
                else if ( (location.x > Child_FrontLeftFoot_x1) && (location.x < Child_FrontLeftFoot_x2) && (location.y>Child_FrontLeftFoot_y1) && (location.y < Child_FrontLeftFoot_y2) )
                {
                    if ([injuryArray count] < 1)
                    {
                        NSString* querySql = @"select InjuryID, 'InjuryType' , Type from InjuryType";
                        
                        @synchronized(g_SYNCLOOKUPDB)
                        {
                            self.injuryArray = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:querySql WithExtraInfo:NO];
                        }
                    }
                    
                    PopupInjuryTypeViewController* popoverView =[[PopupInjuryTypeViewController alloc] initWithNibName:@"PopupInjuryTypeViewController" bundle:nil];
                    popoverView.area = @"Front Left Foot";
                    popoverView.array = self.injuryArray;
                    popoverView.view.backgroundColor = [UIColor whiteColor];//mani
                    
                    self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
                    self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
                    self.popover.popoverContentSize = CGSizeMake(350, 400);
                    popoverView.delegate = self;
                    
                    CGRect frame = CGRectMake(self.location.x - 15, self.location.y - 200, 350, 400);
                    
                    [self.popover presentPopoverFromRect:frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
                }
                
                else if ( (location.x > Child_FrontRightLowerLeg_x1) && (location.x < Child_FrontRightLowerLeg_x2) && (location.y>Child_FrontRightLowerLeg_y1) && (location.y < Child_FrontRightLowerLeg_y2) )
                {
                    if ([injuryArray count] < 1)
                    {
                        NSString* querySql = @"select InjuryID, 'InjuryType' , Type from InjuryType";
                        
                        @synchronized(g_SYNCLOOKUPDB)
                        {
                            self.injuryArray = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:querySql WithExtraInfo:NO];
                        }
                    }
                    
                    PopupInjuryTypeViewController* popoverView =[[PopupInjuryTypeViewController alloc] initWithNibName:@"PopupInjuryTypeViewController" bundle:nil];
                    popoverView.area = @"Front Right Lower Leg";
                    popoverView.array = self.injuryArray;
                    popoverView.view.backgroundColor = [UIColor whiteColor];//mani
                    
                    self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
                    self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
                    self.popover.popoverContentSize = CGSizeMake(350, 400);
                    popoverView.delegate = self;
                    
                    CGRect frame = CGRectMake(self.location.x - 15, self.location.y - 200, 350, 400);
                    
                    [self.popover presentPopoverFromRect:frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
                }
                
                else if ( (location.x > Child_FrontLeftLowerLeg_x1) && (location.x < Child_FrontLeftLowerLeg_x2) && (location.y>Child_FrontLeftLowerLeg_y1) && (location.y < Child_FrontLeftLowerLeg_y2) )
                {
                    if ([injuryArray count] < 1)
                    {
                        NSString* querySql = @"select InjuryID, 'InjuryType' , Type from InjuryType";
                        
                        @synchronized(g_SYNCLOOKUPDB)
                        {
                            self.injuryArray = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:querySql WithExtraInfo:NO];
                        }
                    }
                    
                    PopupInjuryTypeViewController* popoverView =[[PopupInjuryTypeViewController alloc] initWithNibName:@"PopupInjuryTypeViewController" bundle:nil];
                    popoverView.area = @"Front Left Lower Leg";
                    popoverView.array = self.injuryArray;
                    popoverView.view.backgroundColor = [UIColor whiteColor];//mani
                    
                    self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
                    self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
                    self.popover.popoverContentSize = CGSizeMake(350, 400);
                    popoverView.delegate = self;
                    
                    CGRect frame = CGRectMake(self.location.x - 15, self.location.y - 200, 350, 400);
                    
                    [self.popover presentPopoverFromRect:frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
                }

                else if ( (location.x > Child_FrontRightKnee_x1) && (location.x < Child_FrontRightKnee_x2) && (location.y>Child_FrontRightKnee_y1) && (location.y < Child_FrontRightKnee_y2) )
                {
                    if ([injuryArray count] < 1)
                    {
                        NSString* querySql = @"select InjuryID, 'InjuryType' , Type from InjuryType";
                        
                        @synchronized(g_SYNCLOOKUPDB)
                        {
                            self.injuryArray = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:querySql WithExtraInfo:NO];
                        }
                    }
                    
                    PopupInjuryTypeViewController* popoverView =[[PopupInjuryTypeViewController alloc] initWithNibName:@"PopupInjuryTypeViewController" bundle:nil];
                    popoverView.area = @"Front Right Knee";
                    popoverView.array = self.injuryArray;
                    popoverView.view.backgroundColor = [UIColor whiteColor];//mani
                    
                    self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
                    self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
                    self.popover.popoverContentSize = CGSizeMake(350, 400);
                    popoverView.delegate = self;
                    
                    CGRect frame = CGRectMake(self.location.x - 15, self.location.y - 200, 350, 400);
                    
                    [self.popover presentPopoverFromRect:frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
                }
                
                else if ( (location.x > Child_FrontLeftKnee_x1) && (location.x < Child_FrontLeftKnee_x2) && (location.y>Child_FrontLeftKnee_y1) && (location.y < Child_FrontLeftKnee_y2) )
                {
                    if ([injuryArray count] < 1)
                    {
                        NSString* querySql = @"select InjuryID, 'InjuryType' , Type from InjuryType";
                        
                        @synchronized(g_SYNCLOOKUPDB)
                        {
                            self.injuryArray = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:querySql WithExtraInfo:NO];
                        }
                    }
                    
                    PopupInjuryTypeViewController* popoverView =[[PopupInjuryTypeViewController alloc] initWithNibName:@"PopupInjuryTypeViewController" bundle:nil];
                    popoverView.area = @"Front Left Knee";
                    popoverView.array = self.injuryArray;
                    popoverView.view.backgroundColor = [UIColor whiteColor];//mani
                    
                    self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
                    self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
                    self.popover.popoverContentSize = CGSizeMake(350, 400);
                    popoverView.delegate = self;
                    
                    CGRect frame = CGRectMake(self.location.x - 15, self.location.y - 200, 350, 400);
                    
                    [self.popover presentPopoverFromRect:frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
                }
                
                
                else if ( (location.x > Child_FrontLeftUpperLeg_x1) && (location.x < Child_FrontLeftUpperLeg_x2) && (location.y>Child_FrontLeftUpperLeg_y1) && (location.y < Child_FrontLeftUpperLeg_y2) )
                {
                    if ([injuryArray count] < 1)
                    {
                        NSString* querySql = @"select InjuryID, 'InjuryType' , Type from InjuryType";
                        
                        @synchronized(g_SYNCLOOKUPDB)
                        {
                            self.injuryArray = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:querySql WithExtraInfo:NO];
                        }
                    }
                    
                    PopupInjuryTypeViewController* popoverView =[[PopupInjuryTypeViewController alloc] initWithNibName:@"PopupInjuryTypeViewController" bundle:nil];
                    popoverView.area = @"Front Left Upper Leg";
                    popoverView.array = self.injuryArray;
                    popoverView.view.backgroundColor = [UIColor whiteColor];//mani
                    
                    self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
                    self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
                    self.popover.popoverContentSize = CGSizeMake(350, 400);
                    popoverView.delegate = self;
                    
                    CGRect frame = CGRectMake(self.location.x - 15, self.location.y - 200, 350, 400);
                    
                    [self.popover presentPopoverFromRect:frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
                }
                
                else if ( (location.x > Child_FrontRightUpperLeg_x1) && (location.x < Child_FrontRightUpperLeg_x2) && (location.y>Child_FrontRightUpperLeg_y1) && (location.y < Child_FrontRightUpperLeg_y2) )
                {
                    if ([injuryArray count] < 1)
                    {
                        NSString* querySql = @"select InjuryID, 'InjuryType' , Type from InjuryType";
                        
                        @synchronized(g_SYNCLOOKUPDB)
                        {
                            self.injuryArray = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:querySql WithExtraInfo:NO];
                        }
                    }
                    
                    PopupInjuryTypeViewController* popoverView =[[PopupInjuryTypeViewController alloc] initWithNibName:@"PopupInjuryTypeViewController" bundle:nil];
                    popoverView.area = @"Front Right Upper Leg";
                    popoverView.array = self.injuryArray;
                    popoverView.view.backgroundColor = [UIColor whiteColor];//mani
                    
                    self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
                    self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
                    self.popover.popoverContentSize = CGSizeMake(350, 400);
                    popoverView.delegate = self;
                    
                    CGRect frame = CGRectMake(self.location.x - 15, self.location.y - 200, 350, 400);
                    
                    [self.popover presentPopoverFromRect:frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
                }

                else if ( (location.x > Child_Abdomen_x1) && (location.x < Child_Abdomen_x2) && (location.y>Child_Abdomen_y1) && (location.y < Child_Abdomen_y2) )
                {
                    if ([injuryArray count] < 1)
                    {
                        NSString* querySql = @"select InjuryID, 'InjuryType' , Type from InjuryType";
                        
                        @synchronized(g_SYNCLOOKUPDB)
                        {
                            self.injuryArray = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:querySql WithExtraInfo:NO];
                        }
                    }
                    
                    PopupInjuryTypeViewController* popoverView =[[PopupInjuryTypeViewController alloc] initWithNibName:@"PopupInjuryTypeViewController" bundle:nil];
                    popoverView.area = @"Abdomen";
                    popoverView.array = self.injuryArray;
                    popoverView.view.backgroundColor = [UIColor whiteColor];//mani
                    
                    self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
                    self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
                    self.popover.popoverContentSize = CGSizeMake(350, 400);
                    popoverView.delegate = self;
                    
                    CGRect frame = CGRectMake(self.location.x - 15, self.location.y - 200, 350, 400);
                    
                    [self.popover presentPopoverFromRect:frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
                }
                
                else if ( (location.x > Child_RightChest_x1) && (location.x < Child_RightChest_x2) && (location.y>Child_RightChest_y1) && (location.y < Child_RightChest_y2) )
                {
                    if ([injuryArray count] < 1)
                    {
                        NSString* querySql = @"select InjuryID, 'InjuryType' , Type from InjuryType";
                        
                        @synchronized(g_SYNCLOOKUPDB)
                        {
                            self.injuryArray = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:querySql WithExtraInfo:NO];
                        }
                    }
                    
                    PopupInjuryTypeViewController* popoverView =[[PopupInjuryTypeViewController alloc] initWithNibName:@"PopupInjuryTypeViewController" bundle:nil];
                    popoverView.area = @"Right Chest";
                    popoverView.array = self.injuryArray;
                    popoverView.view.backgroundColor = [UIColor whiteColor];//mani
                    
                    self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
                    self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
                    self.popover.popoverContentSize = CGSizeMake(350, 400);
                    popoverView.delegate = self;
                    
                    CGRect frame = CGRectMake(self.location.x - 15, self.location.y - 200, 350, 400);
                    
                    [self.popover presentPopoverFromRect:frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
                }
                else if ( (location.x > Child_LeftChest_x1) && (location.x < Child_LeftChest_x2) && (location.y>Child_LeftChest_y1) && (location.y < Child_LeftChest_y2) )
                {
                    if ([injuryArray count] < 1)
                    {
                        NSString* querySql = @"select InjuryID, 'InjuryType' , Type from InjuryType";
                        
                        @synchronized(g_SYNCLOOKUPDB)
                        {
                            self.injuryArray = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:querySql WithExtraInfo:NO];
                        }
                    }
                    
                    PopupInjuryTypeViewController* popoverView =[[PopupInjuryTypeViewController alloc] initWithNibName:@"PopupInjuryTypeViewController" bundle:nil];
                    popoverView.area = @"Left Chest";
                    popoverView.array = self.injuryArray;
                    popoverView.view.backgroundColor = [UIColor whiteColor];//mani
                    
                    self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
                    self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
                    self.popover.popoverContentSize = CGSizeMake(350, 400);
                    popoverView.delegate = self;
                    
                    CGRect frame = CGRectMake(self.location.x - 15, self.location.y - 200, 350, 400);
                    
                    [self.popover presentPopoverFromRect:frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
                }
                else if ( (location.x > Child_Neck_x1) && (location.x < Child_Neck_x2) && (location.y>Child_Neck_y1) && (location.y < Child_Neck_y2) )
                {
                    if ([injuryArray count] < 1)
                    {
                        NSString* querySql = @"select InjuryID, 'InjuryType' , Type from InjuryType";
                        
                        @synchronized(g_SYNCLOOKUPDB)
                        {
                            self.injuryArray = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:querySql WithExtraInfo:NO];
                        }
                    }
                    
                    PopupInjuryTypeViewController* popoverView =[[PopupInjuryTypeViewController alloc] initWithNibName:@"PopupInjuryTypeViewController" bundle:nil];
                    popoverView.area = @"Front Neck";
                    popoverView.array = self.injuryArray;
                    popoverView.view.backgroundColor = [UIColor whiteColor];//mani
                    
                    self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
                    self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
                    self.popover.popoverContentSize = CGSizeMake(350, 400);
                    popoverView.delegate = self;
                    
                    CGRect frame = CGRectMake(self.location.x - 15, self.location.y - 200, 350, 400);
                    
                    [self.popover presentPopoverFromRect:frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
                }
                
                else if ( (location.x > Child_Head_x1) && (location.x < Child_Head_x2) && (location.y>Child_Head_y1) && (location.y < Child_Head_y2) )
                {
                    if ([injuryArray count] < 1)
                    {
                        NSString* querySql = @"select InjuryID, 'InjuryType' , Type from InjuryType";
                        
                        @synchronized(g_SYNCLOOKUPDB)
                        {
                            self.injuryArray = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:querySql WithExtraInfo:NO];
                        }
                    }
                    
                    PopupInjuryTypeViewController* popoverView =[[PopupInjuryTypeViewController alloc] initWithNibName:@"PopupInjuryTypeViewController" bundle:nil];
                    popoverView.area = @"Front Head";
                    popoverView.array = self.injuryArray;
                    popoverView.view.backgroundColor = [UIColor whiteColor];//mani
                    
                    self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
                    self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
                    self.popover.popoverContentSize = CGSizeMake(350, 400);
                    popoverView.delegate = self;
                    
                    CGRect frame = CGRectMake(self.location.x - 15, self.location.y - 200, 350, 400);
                    
                    [self.popover presentPopoverFromRect:frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
                }
                
            }   // end if front view
            else
            {
                if ( (location.x > Child_BackHead_x1) && (location.x < Child_BackHead_x2) && (location.y>Child_BackHead_y1) && (location.y < Child_BackHead_y2) )
                {
                    if ([injuryArray count] < 1)
                    {
                        NSString* querySql = @"select InjuryID, 'InjuryType' , Type from InjuryType";
                        
                        @synchronized(g_SYNCLOOKUPDB)
                        {
                            self.injuryArray = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:querySql WithExtraInfo:NO];
                        }
                    }
                    
                    PopupInjuryTypeViewController* popoverView =[[PopupInjuryTypeViewController alloc] initWithNibName:@"PopupInjuryTypeViewController" bundle:nil];
                    
                    popoverView.area = @"Back Head";
                    popoverView.array = self.injuryArray;
                    popoverView.view.backgroundColor = [UIColor whiteColor];//mani
                    self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
                    self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
                    self.popover.popoverContentSize = CGSizeMake(350, 400);
                    popoverView.delegate = self;
                    
                    CGRect frame = CGRectMake(self.location.x - 15, self.location.y - 200, 350, 400);
                    
                    [self.popover presentPopoverFromRect:frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
                }
                
                else if ( (location.x > Child_BackNeck_x1) && (location.x < Child_BackNeck_x2) && (location.y>Child_BackNeck_y1) && (location.y < Child_BackNeck_y2) )
                {
                    if ([injuryArray count] < 1)
                    {
                        NSString* querySql = @"select InjuryID, 'InjuryType' , Type from InjuryType";
                        
                        @synchronized(g_SYNCLOOKUPDB)
                        {
                            self.injuryArray = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:querySql WithExtraInfo:NO];
                        }
                    }
                    
                    PopupInjuryTypeViewController* popoverView =[[PopupInjuryTypeViewController alloc] initWithNibName:@"PopupInjuryTypeViewController" bundle:nil];
                    
                    popoverView.area = @"Back Neck";
                    popoverView.array = self.injuryArray;
                    popoverView.view.backgroundColor = [UIColor whiteColor];//mani
                    self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
                    self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
                    self.popover.popoverContentSize = CGSizeMake(350, 400);
                    popoverView.delegate = self;
                    
                    CGRect frame = CGRectMake(self.location.x - 15, self.location.y - 200, 350, 400);
                    
                    [self.popover presentPopoverFromRect:frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
                }
                
                else if ( (location.x > Child_LeftUpperBack_x1) && (location.x < Child_LeftUpperBack_x2) && (location.y>Child_LeftUpperBack_y1) && (location.y < Child_LeftUpperBack_y2) )
                {
                    if ([injuryArray count] < 1)
                    {
                        NSString* querySql = @"select InjuryID, 'InjuryType' , Type from InjuryType";
                        
                        @synchronized(g_SYNCLOOKUPDB)
                        {
                            self.injuryArray = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:querySql WithExtraInfo:NO];
                        }
                    }
                    
                    PopupInjuryTypeViewController* popoverView =[[PopupInjuryTypeViewController alloc] initWithNibName:@"PopupInjuryTypeViewController" bundle:nil];
                    
                    popoverView.area = @"Left Upper Back";
                    popoverView.array = self.injuryArray;
                    popoverView.view.backgroundColor = [UIColor whiteColor];//mani
                    self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
                    self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
                    self.popover.popoverContentSize = CGSizeMake(350, 400);
                    popoverView.delegate = self;
                    
                    CGRect frame = CGRectMake(self.location.x - 15, self.location.y - 200, 350, 400);
                    
                    [self.popover presentPopoverFromRect:frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
                }
                
                else if ( (location.x > Child_RightUpperBack_x1) && (location.x < Child_RightUpperBack_x2) && (location.y>Child_RightUpperBack_y1) && (location.y < Child_RightUpperBack_y2) )
                {
                    if ([injuryArray count] < 1)
                    {
                        NSString* querySql = @"select InjuryID, 'InjuryType' , Type from InjuryType";
                        
                        @synchronized(g_SYNCLOOKUPDB)
                        {
                            self.injuryArray = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:querySql WithExtraInfo:NO];
                        }
                    }
                    
                    PopupInjuryTypeViewController* popoverView =[[PopupInjuryTypeViewController alloc] initWithNibName:@"PopupInjuryTypeViewController" bundle:nil];
                    popoverView.area = @"Right Upper Back";
                    popoverView.array = self.injuryArray;
                    popoverView.view.backgroundColor = [UIColor whiteColor];//mani
                    
                    self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
                    self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
                    self.popover.popoverContentSize = CGSizeMake(350, 400);
                    popoverView.delegate = self;
                    
                    CGRect frame = CGRectMake(self.location.x - 15, self.location.y - 200, 350, 400);
                    
                    [self.popover presentPopoverFromRect:frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
                }
                
                
                else if ( (location.x > Child_LeftLowerBack_x1) && (location.x < Child_LeftLowerBack_x2) && (location.y>Child_LeftLowerBack_y1) && (location.y < Child_LeftLowerBack_y2) )
                {
                    if ([injuryArray count] < 1)
                    {
                        NSString* querySql = @"select InjuryID, 'InjuryType' , Type from InjuryType";
                        
                        @synchronized(g_SYNCLOOKUPDB)
                        {
                            self.injuryArray = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:querySql WithExtraInfo:NO];
                        }
                    }
                    
                    PopupInjuryTypeViewController* popoverView =[[PopupInjuryTypeViewController alloc] initWithNibName:@"PopupInjuryTypeViewController" bundle:nil];
                    popoverView.area = @"Left Lower Back";
                    popoverView.array = self.injuryArray;
                    popoverView.view.backgroundColor = [UIColor whiteColor];//mani
                    
                    self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
                    self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
                    self.popover.popoverContentSize = CGSizeMake(350, 400);
                    popoverView.delegate = self;
                    
                    CGRect frame = CGRectMake(self.location.x - 15, self.location.y - 200, 350, 400);
                    
                    [self.popover presentPopoverFromRect:frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
                }
                
                else if ( (location.x > Child_RightLowerBack_x1) && (location.x < Child_RightLowerBack_x2) && (location.y>Child_RightLowerBack_y1) && (location.y < Child_RightLowerBack_y2) )
                {
                    if ([injuryArray count] < 1)
                    {
                        NSString* querySql = @"select InjuryID, 'InjuryType' , Type from InjuryType";
                        
                        @synchronized(g_SYNCLOOKUPDB)
                        {
                            self.injuryArray = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:querySql WithExtraInfo:NO];
                        }
                    }
                    
                    PopupInjuryTypeViewController* popoverView =[[PopupInjuryTypeViewController alloc] initWithNibName:@"PopupInjuryTypeViewController" bundle:nil];
                    popoverView.area = @"Right Lower Back";
                    popoverView.array = self.injuryArray;
                    popoverView.view.backgroundColor = [UIColor whiteColor];//mani
                    
                    self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
                    self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
                    self.popover.popoverContentSize = CGSizeMake(350, 400);
                    popoverView.delegate = self;
                    
                    CGRect frame = CGRectMake(self.location.x - 15, self.location.y - 200, 350, 400);
                    
                    [self.popover presentPopoverFromRect:frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
                }
                
                else if ( (location.x > Child_BackLeftUpperArm_x1) && (location.x < Child_BackLeftUpperArm_x2) && (location.y>Child_BackLeftUpperArm_y1) && (location.y < Child_BackLeftUpperArm_y2) )
                {
                    if ([injuryArray count] < 1)
                    {
                        NSString* querySql = @"select InjuryID, 'InjuryType' , Type from InjuryType";
                        
                        @synchronized(g_SYNCLOOKUPDB)
                        {
                            self.injuryArray = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:querySql WithExtraInfo:NO];
                        }
                    }
                    
                    PopupInjuryTypeViewController* popoverView =[[PopupInjuryTypeViewController alloc] initWithNibName:@"PopupInjuryTypeViewController" bundle:nil];
                    popoverView.area = @"Left Upper Arm";
                    popoverView.array = self.injuryArray;
                    popoverView.view.backgroundColor = [UIColor whiteColor];//mani
                    
                    self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
                    self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
                    self.popover.popoverContentSize = CGSizeMake(350, 400);
                    popoverView.delegate = self;
                    
                    CGRect frame = CGRectMake(self.location.x - 15, self.location.y - 200, 350, 400);
                    
                    [self.popover presentPopoverFromRect:frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
                }
                
                else if ( (location.x > Child_BackRightUpperArm_x1) && (location.x < Child_BackRightUpperArm_x2) && (location.y>Child_BackRightUpperArm_y1) && (location.y < Child_BackRightUpperArm_y2) )
                {
                    if ([injuryArray count] < 1)
                    {
                        NSString* querySql = @"select InjuryID, 'InjuryType' , Type from InjuryType";
                        
                        @synchronized(g_SYNCLOOKUPDB)
                        {
                            self.injuryArray = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:querySql WithExtraInfo:NO];
                        }
                    }
                    
                    PopupInjuryTypeViewController* popoverView =[[PopupInjuryTypeViewController alloc] initWithNibName:@"PopupInjuryTypeViewController" bundle:nil];
                    popoverView.area = @"Right Upper Arm";
                    popoverView.array = self.injuryArray;
                    popoverView.view.backgroundColor = [UIColor whiteColor];//mani
                    
                    self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
                    self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
                    self.popover.popoverContentSize = CGSizeMake(350, 400);
                    popoverView.delegate = self;
                    
                    CGRect frame = CGRectMake(self.location.x - 15, self.location.y - 200, 350, 400);
                    
                    [self.popover presentPopoverFromRect:frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
                }
                
                else if ( (location.x > Child_BackLeftLowerArm_x1) && (location.x < Child_BackLeftLowerArm_x2) && (location.y>Child_BackLeftLowerArm_y1) && (location.y < Child_BackLeftLowerArm_y2) )
                {
                    if ([injuryArray count] < 1)
                    {
                        NSString* querySql = @"select InjuryID, 'InjuryType' , Type from InjuryType";
                        
                        @synchronized(g_SYNCLOOKUPDB)
                        {
                            self.injuryArray = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:querySql WithExtraInfo:NO];
                        }
                    }
                    
                    PopupInjuryTypeViewController* popoverView =[[PopupInjuryTypeViewController alloc] initWithNibName:@"PopupInjuryTypeViewController" bundle:nil];
                    popoverView.area = @"Left Lower Arm";
                    popoverView.array = self.injuryArray;
                    popoverView.view.backgroundColor = [UIColor whiteColor];//mani
                    
                    self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
                    self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
                    self.popover.popoverContentSize = CGSizeMake(350, 400);
                    popoverView.delegate = self;
                    
                    CGRect frame = CGRectMake(self.location.x - 15, self.location.y - 200, 350, 400);
                    
                    [self.popover presentPopoverFromRect:frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
                }
                
                else if ( (location.x > Child_BackRightLowerArm_x1) && (location.x < Child_BackRightLowerArm_x2) && (location.y>Child_BackRightLowerArm_y1) && (location.y < Child_BackRightLowerArm_y2) )
                {
                    if ([injuryArray count] < 1)
                    {
                        NSString* querySql = @"select InjuryID, 'InjuryType' , Type from InjuryType";
                        
                        @synchronized(g_SYNCLOOKUPDB)
                        {
                            self.injuryArray = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:querySql WithExtraInfo:NO];
                        }
                    }
                    
                    PopupInjuryTypeViewController* popoverView =[[PopupInjuryTypeViewController alloc] initWithNibName:@"PopupInjuryTypeViewController" bundle:nil];
                    popoverView.area = @"Right Lower Arm";
                    popoverView.array = self.injuryArray;
                    popoverView.view.backgroundColor = [UIColor whiteColor];//mani
                    
                    self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
                    self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
                    self.popover.popoverContentSize = CGSizeMake(350, 400);
                    popoverView.delegate = self;
                    
                    CGRect frame = CGRectMake(self.location.x - 15, self.location.y - 200, 350, 400);
                    
                    [self.popover presentPopoverFromRect:frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
                }
                
                else if ( (location.x > Child_BackLeftHand_x1) && (location.x < Child_BackLeftHand_x2) && (location.y>Child_BackLeftHand_y1) && (location.y < Child_BackLeftHand_y2) )
                {
                    if ([injuryArray count] < 1)
                    {
                        NSString* querySql = @"select InjuryID, 'InjuryType' , Type from InjuryType";
                        
                        @synchronized(g_SYNCLOOKUPDB)
                        {
                            self.injuryArray = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:querySql WithExtraInfo:NO];
                        }
                    }
                    
                    PopupInjuryTypeViewController* popoverView =[[PopupInjuryTypeViewController alloc] initWithNibName:@"PopupInjuryTypeViewController" bundle:nil];
                    popoverView.area = @"Back Left Hand";
                    popoverView.array = self.injuryArray;
                    popoverView.view.backgroundColor = [UIColor whiteColor];//mani
                    
                    self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
                    self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
                    self.popover.popoverContentSize = CGSizeMake(350, 400);
                    popoverView.delegate = self;
                    
                    CGRect frame = CGRectMake(self.location.x - 15, self.location.y - 200, 350, 400);
                    
                    [self.popover presentPopoverFromRect:frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
                }
                
                else if ( (location.x > Child_BackRightHand_x1) && (location.x < Child_BackRightHand_x2) && (location.y>Child_BackRightHand_y1) && (location.y < Child_BackRightHand_y2) )
                {
                    if ([injuryArray count] < 1)
                    {
                        NSString* querySql = @"select InjuryID, 'InjuryType' , Type from InjuryType";
                        
                        @synchronized(g_SYNCLOOKUPDB)
                        {
                            self.injuryArray = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:querySql WithExtraInfo:NO];
                        }
                    }
                    
                    PopupInjuryTypeViewController* popoverView =[[PopupInjuryTypeViewController alloc] initWithNibName:@"PopupInjuryTypeViewController" bundle:nil];
                    popoverView.area = @"Back Right Hand";
                    popoverView.array = self.injuryArray;
                    popoverView.view.backgroundColor = [UIColor whiteColor];//mani
                    
                    self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
                    self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
                    self.popover.popoverContentSize = CGSizeMake(350, 400);
                    popoverView.delegate = self;
                    
                    CGRect frame = CGRectMake(self.location.x - 15, self.location.y - 200, 350, 400);
                    
                    [self.popover presentPopoverFromRect:frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
                }
                
                else if ( (location.x > Child_LeftButtock_x1) && (location.x < Child_LeftButtock_x2) && (location.y>Child_LeftButtock_y1) && (location.y < Child_LeftButtock_y2) )
                {
                    if ([injuryArray count] < 1)
                    {
                        NSString* querySql = @"select InjuryID, 'InjuryType' , Type from InjuryType";
                        
                        @synchronized(g_SYNCLOOKUPDB)
                        {
                            self.injuryArray = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:querySql WithExtraInfo:NO];
                        }
                    }
                    
                    PopupInjuryTypeViewController* popoverView =[[PopupInjuryTypeViewController alloc] initWithNibName:@"PopupInjuryTypeViewController" bundle:nil];
                    popoverView.area = @"Left Buttock";
                    popoverView.array = self.injuryArray;
                    popoverView.view.backgroundColor = [UIColor whiteColor];//mani
                    
                    self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
                    self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
                    self.popover.popoverContentSize = CGSizeMake(350, 400);
                    popoverView.delegate = self;
                    
                    CGRect frame = CGRectMake(self.location.x - 15, self.location.y - 200, 350, 400);
                    
                    [self.popover presentPopoverFromRect:frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
                }
                
                
                else if ( (location.x > Child_RightButtock_x1) && (location.x < Child_RightButtock_x2) && (location.y>Child_RightButtock_y1) && (location.y < Child_RightButtock_y2) )
                {
                    if ([injuryArray count] < 1)
                    {
                        NSString* querySql = @"select InjuryID, 'InjuryType' , Type from InjuryType";
                        
                        @synchronized(g_SYNCLOOKUPDB)
                        {
                            self.injuryArray = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:querySql WithExtraInfo:NO];
                        }
                    }
                    
                    PopupInjuryTypeViewController* popoverView =[[PopupInjuryTypeViewController alloc] initWithNibName:@"PopupInjuryTypeViewController" bundle:nil];
                    popoverView.area = @"Right Buttock";
                    popoverView.array = self.injuryArray;
                    popoverView.view.backgroundColor = [UIColor whiteColor];//mani
                    
                    self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
                    self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
                    self.popover.popoverContentSize = CGSizeMake(350, 400);
                    popoverView.delegate = self;
                    
                    CGRect frame = CGRectMake(self.location.x - 15, self.location.y - 200, 350, 400);
                    
                    [self.popover presentPopoverFromRect:frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
                }
                
                else if ( (location.x > Child_BackLeftUpperLeg_x1) && (location.x < Child_BackLeftUpperLeg_x2) && (location.y>Child_BackLeftUpperLeg_y1) && (location.y < Child_BackLeftUpperLeg_y2) )
                {
                    if ([injuryArray count] < 1)
                    {
                        NSString* querySql = @"select InjuryID, 'InjuryType' , Type from InjuryType";
                        
                        @synchronized(g_SYNCLOOKUPDB)
                        {
                            self.injuryArray = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:querySql WithExtraInfo:NO];
                        }
                    }
                    
                    PopupInjuryTypeViewController* popoverView =[[PopupInjuryTypeViewController alloc] initWithNibName:@"PopupInjuryTypeViewController" bundle:nil];
                    popoverView.area = @"Left Upper Leg";
                    popoverView.array = self.injuryArray;
                    popoverView.view.backgroundColor = [UIColor whiteColor];//mani
                    
                    self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
                    self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
                    self.popover.popoverContentSize = CGSizeMake(350, 400);
                    popoverView.delegate = self;
                    
                    CGRect frame = CGRectMake(self.location.x - 15, self.location.y - 200, 350, 400);
                    
                    [self.popover presentPopoverFromRect:frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
                }
                
                else if ( (location.x > Child_BackRightUpperLeg_x1) && (location.x < Child_BackRightUpperLeg_x2) && (location.y>Child_BackRightUpperLeg_y1) && (location.y < Child_BackRightUpperLeg_y2) )
                {
                    if ([injuryArray count] < 1)
                    {
                        NSString* querySql = @"select InjuryID, 'InjuryType' , Type from InjuryType";
                        
                        @synchronized(g_SYNCLOOKUPDB)
                        {
                            self.injuryArray = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:querySql WithExtraInfo:NO];
                        }
                    }
                    
                    PopupInjuryTypeViewController* popoverView =[[PopupInjuryTypeViewController alloc] initWithNibName:@"PopupInjuryTypeViewController" bundle:nil];
                    popoverView.area = @"Right Upper Leg";
                    popoverView.array = self.injuryArray;
                    popoverView.view.backgroundColor = [UIColor whiteColor];//mani
                    
                    self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
                    self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
                    self.popover.popoverContentSize = CGSizeMake(350, 400);
                    popoverView.delegate = self;
                    
                    CGRect frame = CGRectMake(self.location.x - 15, self.location.y - 200, 350, 400);
                    
                    [self.popover presentPopoverFromRect:frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
                }
                
                else if ( (location.x > Child_BackLeftKnee_x1) && (location.x < Child_BackLeftKnee_x2) && (location.y>Child_BackLeftKnee_y1) && (location.y < Child_BackLeftKnee_y2) )
                {
                    if ([injuryArray count] < 1)
                    {
                        NSString* querySql = @"select InjuryID, 'InjuryType' , Type from InjuryType";
                        
                        @synchronized(g_SYNCLOOKUPDB)
                        {
                            self.injuryArray = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:querySql WithExtraInfo:NO];
                        }
                    }
                    
                    PopupInjuryTypeViewController* popoverView =[[PopupInjuryTypeViewController alloc] initWithNibName:@"PopupInjuryTypeViewController" bundle:nil];
                    popoverView.area = @"Back Left Knee";
                    popoverView.array = self.injuryArray;
                    popoverView.view.backgroundColor = [UIColor whiteColor];//mani
                    
                    self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
                    self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
                    self.popover.popoverContentSize = CGSizeMake(350, 400);
                    popoverView.delegate = self;
                    
                    CGRect frame = CGRectMake(self.location.x - 15, self.location.y - 200, 350, 400);
                    
                    [self.popover presentPopoverFromRect:frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
                }
                
                else if ( (location.x > Child_BackRightKnee_x1) && (location.x < Child_BackRightKnee_x2) && (location.y>Child_BackRightKnee_y1) && (location.y < Child_BackRightKnee_y2) )
                {
                    if ([injuryArray count] < 1)
                    {
                        NSString* querySql = @"select InjuryID, 'InjuryType' , Type from InjuryType";
                        
                        @synchronized(g_SYNCLOOKUPDB)
                        {
                            self.injuryArray = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:querySql WithExtraInfo:NO];
                        }
                    }
                    
                    PopupInjuryTypeViewController* popoverView =[[PopupInjuryTypeViewController alloc] initWithNibName:@"PopupInjuryTypeViewController" bundle:nil];
                    popoverView.area = @"Back Right Knee";
                    popoverView.array = self.injuryArray;
                    popoverView.view.backgroundColor = [UIColor whiteColor];//mani
                    
                    self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
                    self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
                    self.popover.popoverContentSize = CGSizeMake(350, 400);
                    popoverView.delegate = self;
                    
                    CGRect frame = CGRectMake(self.location.x - 15, self.location.y - 200, 350, 400);
                    
                    [self.popover presentPopoverFromRect:frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
                }
                
                else if ( (location.x > Child_BackLeftLowerLeg_x1) && (location.x < Child_BackLeftLowerLeg_x2) && (location.y>Child_BackLeftLowerLeg_y1) && (location.y < Child_BackLeftLowerLeg_y2) )
                {
                    if ([injuryArray count] < 1)
                    {
                        NSString* querySql = @"select InjuryID, 'InjuryType' , Type from InjuryType";
                        
                        @synchronized(g_SYNCLOOKUPDB)
                        {
                            self.injuryArray = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:querySql WithExtraInfo:NO];
                        }
                    }
                    
                    PopupInjuryTypeViewController* popoverView =[[PopupInjuryTypeViewController alloc] initWithNibName:@"PopupInjuryTypeViewController" bundle:nil];
                    popoverView.area = @"Left Lower Leg";
                    popoverView.array = self.injuryArray;
                    popoverView.view.backgroundColor = [UIColor whiteColor];//mani
                    
                    self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
                    self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
                    self.popover.popoverContentSize = CGSizeMake(350, 400);
                    popoverView.delegate = self;
                    
                    CGRect frame = CGRectMake(self.location.x - 15, self.location.y - 200, 350, 400);
                    
                    [self.popover presentPopoverFromRect:frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
                }
                
                else if ( (location.x > Child_BackRightLowerLeg_x1) && (location.x < Child_BackRightLowerLeg_x2) && (location.y>Child_BackRightLowerLeg_y1) && (location.y < Child_BackRightLowerLeg_y2) )
                {
                    if ([injuryArray count] < 1)
                    {
                        NSString* querySql = @"select InjuryID, 'InjuryType' , Type from InjuryType";
                        
                        @synchronized(g_SYNCLOOKUPDB)
                        {
                            self.injuryArray = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:querySql WithExtraInfo:NO];
                        }
                    }
                    
                    PopupInjuryTypeViewController* popoverView =[[PopupInjuryTypeViewController alloc] initWithNibName:@"PopupInjuryTypeViewController" bundle:nil];
                    popoverView.area = @"Right Lower Leg";
                    popoverView.array = self.injuryArray;
                    popoverView.view.backgroundColor = [UIColor whiteColor];//mani
                    
                    self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
                    self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
                    self.popover.popoverContentSize = CGSizeMake(350, 400);
                    popoverView.delegate = self;
                    
                    CGRect frame = CGRectMake(self.location.x - 15, self.location.y - 200, 350, 400);
                    
                    [self.popover presentPopoverFromRect:frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
                }
                
                else if ( (location.x > Child_BackLeftFoot_x1) && (location.x < Child_BackLeftFoot_x2) && (location.y>Child_BackLeftFoot_y1) && (location.y < Child_BackLeftFoot_y2) )
                {
                    if ([injuryArray count] < 1)
                    {
                        NSString* querySql = @"select InjuryID, 'InjuryType' , Type from InjuryType";
                        
                        @synchronized(g_SYNCLOOKUPDB)
                        {
                            self.injuryArray = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:querySql WithExtraInfo:NO];
                        }
                    }
                    
                    PopupInjuryTypeViewController* popoverView =[[PopupInjuryTypeViewController alloc] initWithNibName:@"PopupInjuryTypeViewController" bundle:nil];
                    popoverView.area = @"Left Foot";
                    popoverView.array = self.injuryArray;
                    popoverView.view.backgroundColor = [UIColor whiteColor];//mani
                    
                    self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
                    self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
                    self.popover.popoverContentSize = CGSizeMake(350, 400);
                    popoverView.delegate = self;
                    
                    CGRect frame = CGRectMake(self.location.x - 15, self.location.y - 200, 350, 400);
                    
                    [self.popover presentPopoverFromRect:frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
                }
                
               else if ( (location.x > Child_BackRightFoot_x1) && (location.x < Child_BackRightFoot_x2) && (location.y>Child_BackRightFoot_y1) && (location.y < Child_BackRightFoot_y2) )
                {
                    if ([injuryArray count] < 1)
                    {
                        NSString* querySql = @"select InjuryID, 'InjuryType' , Type from InjuryType";
                        
                        @synchronized(g_SYNCLOOKUPDB)
                        {
                            self.injuryArray = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:querySql WithExtraInfo:NO];
                        }
                    }
                    
                    PopupInjuryTypeViewController* popoverView =[[PopupInjuryTypeViewController alloc] initWithNibName:@"PopupInjuryTypeViewController" bundle:nil];
                    popoverView.area = @"Right Foot";
                    popoverView.array = self.injuryArray;
                    popoverView.view.backgroundColor = [UIColor whiteColor];//mani
                    
                    self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
                    self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
                    self.popover.popoverContentSize = CGSizeMake(350, 400);
                    popoverView.delegate = self;
                    
                    CGRect frame = CGRectMake(self.location.x - 15, self.location.y - 200, 350, 400);
                    
                    [self.popover presentPopoverFromRect:frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
                }
                
            } //end else if frontview
            
        } // end of agesex == 1 Child
        else if (ageSex == 2)
        {
            if (frontView)
            {
                if ( (location.x > FeMale_Head_x1) && (location.x < FeMale_Head_x2) && (location.y>FeMale_Head_y1) && (location.y < FeMale_Head_y2) )
                {
                    if ([injuryArray count] < 1)
                    {
                        NSString* querySql = @"select InjuryID, 'InjuryType' , Type from InjuryType";
                        
                        @synchronized(g_SYNCLOOKUPDB)
                        {
                            self.injuryArray = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:querySql WithExtraInfo:NO];
                        }
                    }
                    PopupInjuryTypeViewController* popoverView =[[PopupInjuryTypeViewController alloc] initWithNibName:@"PopupInjuryTypeViewController" bundle:nil];
                    
                    popoverView.area = @"Head";
                    popoverView.array = self.injuryArray;
                    popoverView.view.backgroundColor = [UIColor whiteColor];//mani
                    self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
                    self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
                    self.popover.popoverContentSize = CGSizeMake(350, 400);
                    popoverView.delegate = self;
                    
                    CGRect frame = CGRectMake(self.location.x - 15, self.location.y - 200, 350, 400);
                    [self.popover presentPopoverFromRect:frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
                }
                else if ( (location.x > FeMale_Neck_x1) && (location.x < FeMale_Neck_x2) && (location.y>FeMale_Neck_y1) && (location.y < FeMale_Neck_y2) )
                {
                    if ([injuryArray count] < 1)
                    {
                        NSString* querySql = @"select InjuryID, 'InjuryType' , Type from InjuryType";
                        
                        @synchronized(g_SYNCLOOKUPDB)
                        {
                            self.injuryArray = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:querySql WithExtraInfo:NO];
                        }
                    }
                    PopupInjuryTypeViewController* popoverView =[[PopupInjuryTypeViewController alloc] initWithNibName:@"PopupInjuryTypeViewController" bundle:nil];
                    
                    popoverView.area = @"Front Neck";
                    popoverView.array = self.injuryArray;
                    popoverView.view.backgroundColor = [UIColor whiteColor];//mani
                    self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
                    self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
                    self.popover.popoverContentSize = CGSizeMake(350, 400);
                    popoverView.delegate = self;
                    
                    CGRect frame = CGRectMake(self.location.x - 15, self.location.y - 200, 350, 400);
                    [self.popover presentPopoverFromRect:frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
                }
                else if ( (location.x > FeMale_RightChest_x1) && (location.x < FeMale_RightChest_x2) && (location.y>FeMale_RightChest_y1) && (location.y < FeMale_RightChest_y2) )
                {
                    if ([injuryArray count] < 1)
                    {
                        NSString* querySql = @"select InjuryID, 'InjuryType' , Type from InjuryType";
                        
                        @synchronized(g_SYNCLOOKUPDB)
                        {
                            self.injuryArray = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:querySql WithExtraInfo:NO];
                        }
                    }
                    PopupInjuryTypeViewController* popoverView =[[PopupInjuryTypeViewController alloc] initWithNibName:@"PopupInjuryTypeViewController" bundle:nil];
                    
                    popoverView.area = @"Right Chest";
                    popoverView.array = self.injuryArray;
                    popoverView.view.backgroundColor = [UIColor whiteColor];//mani
                    self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
                    self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
                    self.popover.popoverContentSize = CGSizeMake(350, 400);
                    popoverView.delegate = self;
                    
                    CGRect frame = CGRectMake(self.location.x - 15, self.location.y - 200, 350, 400);
                    [self.popover presentPopoverFromRect:frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
                }
                else if ( (location.x > FeMale_LeftChest_x1) && (location.x < FeMale_LeftChest_x2) && (location.y>FeMale_LeftChest_y1) && (location.y < FeMale_LeftChest_y2) )
                {
                    if ([injuryArray count] < 1)
                    {
                        NSString* querySql = @"select InjuryID, 'InjuryType' , Type from InjuryType";
                        
                        @synchronized(g_SYNCLOOKUPDB)
                        {
                            self.injuryArray = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:querySql WithExtraInfo:NO];
                        }
                    }
                    PopupInjuryTypeViewController* popoverView =[[PopupInjuryTypeViewController alloc] initWithNibName:@"PopupInjuryTypeViewController" bundle:nil];
                    
                    popoverView.area = @"Left Chest";
                    popoverView.array = self.injuryArray;
                    popoverView.view.backgroundColor = [UIColor whiteColor];//mani
                    self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
                    self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
                    self.popover.popoverContentSize = CGSizeMake(350, 400);
                    popoverView.delegate = self;
                    
                    CGRect frame = CGRectMake(self.location.x - 15, self.location.y - 200, 350, 400);
                    [self.popover presentPopoverFromRect:frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
                }
                else if ( (location.x > FeMale_Abdomen_x1) && (location.x < FeMale_Abdomen_x2) && (location.y>FeMale_Abdomen_y1) && (location.y < FeMale_Abdomen_y2) )
                {
                    if ([injuryArray count] < 1)
                    {
                        NSString* querySql = @"select InjuryID, 'InjuryType' , Type from InjuryType";
                        
                        @synchronized(g_SYNCLOOKUPDB)
                        {
                            self.injuryArray = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:querySql WithExtraInfo:NO];
                        }
                    }
                    PopupInjuryTypeViewController* popoverView =[[PopupInjuryTypeViewController alloc] initWithNibName:@"PopupInjuryTypeViewController" bundle:nil];
                    
                    popoverView.area = @"Abdomen";
                    popoverView.array = self.injuryArray;
                    popoverView.view.backgroundColor = [UIColor whiteColor];//mani
                    self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
                    self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
                    self.popover.popoverContentSize = CGSizeMake(350, 400);
                    popoverView.delegate = self;
                    
                    CGRect frame = CGRectMake(self.location.x - 15, self.location.y - 200, 350, 400);
                    [self.popover presentPopoverFromRect:frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
                }
                else if ( (location.x > FeMale_Genitals_x1) && (location.x < FeMale_Genitals_x2) && (location.y>FeMale_Genitals_y1) && (location.y < FeMale_Genitals_y2) )
                {
                    if ([injuryArray count] < 1)
                    {
                        NSString* querySql = @"select InjuryID, 'InjuryType' , Type from InjuryType";
                        
                        @synchronized(g_SYNCLOOKUPDB)
                        {
                            self.injuryArray = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:querySql WithExtraInfo:NO];
                        }
                    }
                    PopupInjuryTypeViewController* popoverView =[[PopupInjuryTypeViewController alloc] initWithNibName:@"PopupInjuryTypeViewController" bundle:nil];
                    
                    popoverView.area = @"Genitals";
                    popoverView.array = self.injuryArray;
                    popoverView.view.backgroundColor = [UIColor whiteColor];//mani
                    self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
                    self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
                    self.popover.popoverContentSize = CGSizeMake(350, 400);
                    popoverView.delegate = self;
                    
                    CGRect frame = CGRectMake(self.location.x - 15, self.location.y - 200, 350, 400);
                    [self.popover presentPopoverFromRect:frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
                }
                else if ( (location.x > FeMale_RightUpperLeg_x1) && (location.x < FeMale_RightUpperLeg_x2) && (location.y>FeMale_RightUpperLeg_y1) && (location.y < FeMale_RightUpperLeg_y2) )
                {
                    if ([injuryArray count] < 1)
                    {
                        NSString* querySql = @"select InjuryID, 'InjuryType' , Type from InjuryType";
                        
                        @synchronized(g_SYNCLOOKUPDB)
                        {
                            self.injuryArray = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:querySql WithExtraInfo:NO];
                        }
                    }
                    PopupInjuryTypeViewController* popoverView =[[PopupInjuryTypeViewController alloc] initWithNibName:@"PopupInjuryTypeViewController" bundle:nil];
                    
                    popoverView.area = @"Front Right Upper Leg";
                    popoverView.array = self.injuryArray;
                    popoverView.view.backgroundColor = [UIColor whiteColor];//mani
                    self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
                    self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
                    self.popover.popoverContentSize = CGSizeMake(350, 400);
                    popoverView.delegate = self;
                    
                    CGRect frame = CGRectMake(self.location.x - 15, self.location.y - 200, 350, 400);
                    [self.popover presentPopoverFromRect:frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
                }
                else if ( (location.x > FeMale_LeftUpperLeg_x1) && (location.x < FeMale_LeftUpperLeg_x2) && (location.y>FeMale_LeftUpperLeg_y1) && (location.y < FeMale_LeftUpperLeg_y2) )
                {
                    if ([injuryArray count] < 1)
                    {
                        NSString* querySql = @"select InjuryID, 'InjuryType' , Type from InjuryType";
                        
                        @synchronized(g_SYNCLOOKUPDB)
                        {
                            self.injuryArray = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:querySql WithExtraInfo:NO];
                        }
                    }
                    PopupInjuryTypeViewController* popoverView =[[PopupInjuryTypeViewController alloc] initWithNibName:@"PopupInjuryTypeViewController" bundle:nil];
                    
                    popoverView.area = @"Front Left Upper Leg";
                    popoverView.array = self.injuryArray;
                    popoverView.view.backgroundColor = [UIColor whiteColor];//mani
                    self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
                    self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
                    self.popover.popoverContentSize = CGSizeMake(350, 400);
                    popoverView.delegate = self;
                    
                    CGRect frame = CGRectMake(self.location.x - 15, self.location.y - 200, 350, 400);
                    [self.popover presentPopoverFromRect:frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
                }
                else if ( (location.x > FeMale_FrontRightKnee_x1) && (location.x < FeMale_FrontRightKnee_x2) && (location.y>FeMale_FrontRightKnee_y1) && (location.y < FeMale_FrontRightKnee_y2) )
                {
                    if ([injuryArray count] < 1)
                    {
                        NSString* querySql = @"select InjuryID, 'InjuryType' , Type from InjuryType";
                        
                        @synchronized(g_SYNCLOOKUPDB)
                        {
                            self.injuryArray = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:querySql WithExtraInfo:NO];
                        }
                    }
                    PopupInjuryTypeViewController* popoverView =[[PopupInjuryTypeViewController alloc] initWithNibName:@"PopupInjuryTypeViewController" bundle:nil];
                    
                    popoverView.area = @"Front Right Knee";
                    popoverView.array = self.injuryArray;
                    popoverView.view.backgroundColor = [UIColor whiteColor];//mani
                    self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
                    self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
                    self.popover.popoverContentSize = CGSizeMake(350, 400);
                    popoverView.delegate = self;
                    
                    CGRect frame = CGRectMake(self.location.x - 15, self.location.y - 200, 350, 400);
                    [self.popover presentPopoverFromRect:frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
                }
                else if ( (location.x > FeMale_FrontLeftKnee_x1) && (location.x < FeMale_FrontLeftKnee_x2) && (location.y>FeMale_FrontLeftKnee_y1) && (location.y < FeMale_FrontLeftKnee_y2) )
                {
                    if ([injuryArray count] < 1)
                    {
                        NSString* querySql = @"select InjuryID, 'InjuryType' , Type from InjuryType";
                        
                        @synchronized(g_SYNCLOOKUPDB)
                        {
                            self.injuryArray = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:querySql WithExtraInfo:NO];
                        }
                    }
                    PopupInjuryTypeViewController* popoverView =[[PopupInjuryTypeViewController alloc] initWithNibName:@"PopupInjuryTypeViewController" bundle:nil];
                    
                    popoverView.area = @"Front Left Knee";
                    popoverView.array = self.injuryArray;
                    popoverView.view.backgroundColor = [UIColor whiteColor];//mani
                    self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
                    self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
                    self.popover.popoverContentSize = CGSizeMake(350, 400);
                    popoverView.delegate = self;
                    
                    CGRect frame = CGRectMake(self.location.x - 15, self.location.y - 200, 350, 400);
                    [self.popover presentPopoverFromRect:frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
                }
                else if ( (location.x > FeMale_RightLowerLeg_x1) && (location.x < FeMale_RightLowerLeg_x2) && (location.y>FeMale_RightLowerLeg_y1) && (location.y < FeMale_RightLowerLeg_y2) )
                {
                    if ([injuryArray count] < 1)
                    {
                        NSString* querySql = @"select InjuryID, 'InjuryType' , Type from InjuryType";
                        
                        @synchronized(g_SYNCLOOKUPDB)
                        {
                            self.injuryArray = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:querySql WithExtraInfo:NO];
                        }
                    }
                    PopupInjuryTypeViewController* popoverView =[[PopupInjuryTypeViewController alloc] initWithNibName:@"PopupInjuryTypeViewController" bundle:nil];
                    
                    popoverView.area = @"Front Right Lower Leg";
                    popoverView.array = self.injuryArray;
                    popoverView.view.backgroundColor = [UIColor whiteColor];//mani
                    self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
                    self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
                    self.popover.popoverContentSize = CGSizeMake(350, 400);
                    popoverView.delegate = self;
                    
                    CGRect frame = CGRectMake(self.location.x - 15, self.location.y - 200, 350, 400);
                    [self.popover presentPopoverFromRect:frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
                }
                else if ( (location.x > FeMale_LeftLowerLeg_x1) && (location.x < FeMale_LeftLowerLeg_x2) && (location.y>FeMale_LeftLowerLeg_y1) && (location.y < FeMale_LeftLowerLeg_y2) )
                {
                    if ([injuryArray count] < 1)
                    {
                        NSString* querySql = @"select InjuryID, 'InjuryType' , Type from InjuryType";
                        
                        @synchronized(g_SYNCLOOKUPDB)
                        {
                            self.injuryArray = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:querySql WithExtraInfo:NO];
                        }
                    }
                    PopupInjuryTypeViewController* popoverView =[[PopupInjuryTypeViewController alloc] initWithNibName:@"PopupInjuryTypeViewController" bundle:nil];
                    
                    popoverView.area = @"Front Left Lower Leg";
                    popoverView.array = self.injuryArray;
                    popoverView.view.backgroundColor = [UIColor whiteColor];//mani
                    self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
                    self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
                    self.popover.popoverContentSize = CGSizeMake(350, 400);
                    popoverView.delegate = self;
                    
                    CGRect frame = CGRectMake(self.location.x - 15, self.location.y - 200, 350, 400);
                    [self.popover presentPopoverFromRect:frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
                }
                else if ( (location.x > FeMale_FrontRightFoot_x1) && (location.x < FeMale_FrontRightFoot_x2) && (location.y>FeMale_FrontRightFoot_y1) && (location.y < FeMale_FrontRightFoot_y2) )
                {
                    if ([injuryArray count] < 1)
                    {
                        NSString* querySql = @"select InjuryID, 'InjuryType' , Type from InjuryType";
                        
                        @synchronized(g_SYNCLOOKUPDB)
                        {
                            self.injuryArray = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:querySql WithExtraInfo:NO];
                        }
                    }
                    PopupInjuryTypeViewController* popoverView =[[PopupInjuryTypeViewController alloc] initWithNibName:@"PopupInjuryTypeViewController" bundle:nil];
                    
                    popoverView.area = @"Front Right Foot";
                    popoverView.array = self.injuryArray;
                    popoverView.view.backgroundColor = [UIColor whiteColor];//mani
                    self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
                    self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
                    self.popover.popoverContentSize = CGSizeMake(350, 400);
                    popoverView.delegate = self;
                    
                    CGRect frame = CGRectMake(self.location.x - 15, self.location.y - 200, 350, 400);
                    [self.popover presentPopoverFromRect:frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
                }
                else if ( (location.x > FeMale_FrontLeftFoot_x1) && (location.x < FeMale_FrontLeftFoot_x2) && (location.y>FeMale_FrontLeftFoot_y1) && (location.y < FeMale_FrontLeftFoot_y2) )
                {
                    if ([injuryArray count] < 1)
                    {
                        NSString* querySql = @"select InjuryID, 'InjuryType' , Type from InjuryType";
                        
                        @synchronized(g_SYNCLOOKUPDB)
                        {
                            self.injuryArray = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:querySql WithExtraInfo:NO];
                        }
                    }
                    PopupInjuryTypeViewController* popoverView =[[PopupInjuryTypeViewController alloc] initWithNibName:@"PopupInjuryTypeViewController" bundle:nil];
                    
                    popoverView.area = @"Front Left Foot";
                    popoverView.array = self.injuryArray;
                    popoverView.view.backgroundColor = [UIColor whiteColor];//mani
                    self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
                    self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
                    self.popover.popoverContentSize = CGSizeMake(350, 400);
                    popoverView.delegate = self;
                    
                    CGRect frame = CGRectMake(self.location.x - 15, self.location.y - 200, 350, 400);
                    [self.popover presentPopoverFromRect:frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
                }
                else if ( (location.x > FeMale_RightUpperArm_x1) && (location.x < FeMale_RightUpperArm_x2) && (location.y>FeMale_RightUpperArm_y1) && (location.y < FeMale_RightUpperArm_y2) )
                {
                    if ([injuryArray count] < 1)
                    {
                        NSString* querySql = @"select InjuryID, 'InjuryType' , Type from InjuryType";
                        
                        @synchronized(g_SYNCLOOKUPDB)
                        {
                            self.injuryArray = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:querySql WithExtraInfo:NO];
                        }
                    }
                    PopupInjuryTypeViewController* popoverView =[[PopupInjuryTypeViewController alloc] initWithNibName:@"PopupInjuryTypeViewController" bundle:nil];
                    
                    popoverView.area = @"Front Upper Right Arm";
                    popoverView.array = self.injuryArray;
                    popoverView.view.backgroundColor = [UIColor whiteColor];//mani
                    self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
                    self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
                    self.popover.popoverContentSize = CGSizeMake(350, 400);
                    popoverView.delegate = self;
                    
                    CGRect frame = CGRectMake(self.location.x - 15, self.location.y - 200, 350, 400);
                    [self.popover presentPopoverFromRect:frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
                }
                else if ( (location.x > FeMale_RightLowerArm_x1) && (location.x < FeMale_RightLowerArm_x2) && (location.y>FeMale_RightLowerArm_y1) && (location.y < FeMale_RightLowerArm_y2) )
                {
                    if ([injuryArray count] < 1)
                    {
                        NSString* querySql = @"select InjuryID, 'InjuryType' , Type from InjuryType";
                        
                        @synchronized(g_SYNCLOOKUPDB)
                        {
                            self.injuryArray = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:querySql WithExtraInfo:NO];
                        }
                    }
                    PopupInjuryTypeViewController* popoverView =[[PopupInjuryTypeViewController alloc] initWithNibName:@"PopupInjuryTypeViewController" bundle:nil];
                    
                    popoverView.area = @"Front Lower Right Arm";
                    popoverView.array = self.injuryArray;
                    popoverView.view.backgroundColor = [UIColor whiteColor];//mani
                    self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
                    self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
                    self.popover.popoverContentSize = CGSizeMake(350, 400);
                    popoverView.delegate = self;
                    
                    CGRect frame = CGRectMake(self.location.x - 15, self.location.y - 200, 350, 400);
                    [self.popover presentPopoverFromRect:frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
                }
                else if ( (location.x > FeMale_RightHand_x1) && (location.x < FeMale_RightHand_x2) && (location.y>FeMale_RightHand_y1) && (location.y < FeMale_RightHand_y2) )
                {
                    if ([injuryArray count] < 1)
                    {
                        NSString* querySql = @"select InjuryID, 'InjuryType' , Type from InjuryType";
                        
                        @synchronized(g_SYNCLOOKUPDB)
                        {
                            self.injuryArray = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:querySql WithExtraInfo:NO];
                        }
                    }
                    PopupInjuryTypeViewController* popoverView =[[PopupInjuryTypeViewController alloc] initWithNibName:@"PopupInjuryTypeViewController" bundle:nil];
                    
                    popoverView.area = @"Front Right Hand";
                    popoverView.array = self.injuryArray;
                    popoverView.view.backgroundColor = [UIColor whiteColor];//mani
                    self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
                    self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
                    self.popover.popoverContentSize = CGSizeMake(350, 400);
                    popoverView.delegate = self;
                    
                    CGRect frame = CGRectMake(self.location.x - 15, self.location.y - 200, 350, 400);
                    [self.popover presentPopoverFromRect:frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
                }
                else if ( (location.x > FeMale_LeftUpperArm_x1) && (location.x < FeMale_LeftUpperArm_x2) && (location.y>FeMale_LeftUpperArm_y1) && (location.y < FeMale_LeftUpperArm_y2) )
                {
                    if ([injuryArray count] < 1)
                    {
                        NSString* querySql = @"select InjuryID, 'InjuryType' , Type from InjuryType";
                        
                        @synchronized(g_SYNCLOOKUPDB)
                        {
                            self.injuryArray = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:querySql WithExtraInfo:NO];
                        }
                    }
                    PopupInjuryTypeViewController* popoverView =[[PopupInjuryTypeViewController alloc] initWithNibName:@"PopupInjuryTypeViewController" bundle:nil];
                    
                    popoverView.area = @"Front Left Upper Arm";
                    popoverView.array = self.injuryArray;
                    popoverView.view.backgroundColor = [UIColor whiteColor];//mani
                    self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
                    self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
                    self.popover.popoverContentSize = CGSizeMake(350, 400);
                    popoverView.delegate = self;
                    
                    CGRect frame = CGRectMake(self.location.x - 15, self.location.y - 200, 350, 400);
                    [self.popover presentPopoverFromRect:frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
                }
                else if ( (location.x > FeMale_LeftLowerArm_x1) && (location.x < FeMale_LeftLowerArm_x2) && (location.y>FeMale_LeftLowerArm_y1) && (location.y < FeMale_LeftLowerArm_y2) )
                {
                    if ([injuryArray count] < 1)
                    {
                        NSString* querySql = @"select InjuryID, 'InjuryType' , Type from InjuryType";
                        
                        @synchronized(g_SYNCLOOKUPDB)
                        {
                            self.injuryArray = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:querySql WithExtraInfo:NO];
                        }
                    }
                    PopupInjuryTypeViewController* popoverView =[[PopupInjuryTypeViewController alloc] initWithNibName:@"PopupInjuryTypeViewController" bundle:nil];
                    
                    popoverView.area = @"Front Left Lower Arm";
                    popoverView.array = self.injuryArray;
                    popoverView.view.backgroundColor = [UIColor whiteColor];//mani
                    self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
                    self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
                    self.popover.popoverContentSize = CGSizeMake(350, 400);
                    popoverView.delegate = self;
                    
                    CGRect frame = CGRectMake(self.location.x - 15, self.location.y - 200, 350, 400);
                    [self.popover presentPopoverFromRect:frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
                }
                
                else if ( (location.x > FeMale_LeftHand_x1) && (location.x < FeMale_LeftHand_x2) && (location.y>FeMale_LeftHand_y1) && (location.y < FeMale_LeftHand_y2) )
                {
                    if ([injuryArray count] < 1)
                    {
                        NSString* querySql = @"select InjuryID, 'InjuryType' , Type from InjuryType";
                        
                        @synchronized(g_SYNCLOOKUPDB)
                        {
                            self.injuryArray = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:querySql WithExtraInfo:NO];
                        }
                    }
                    PopupInjuryTypeViewController* popoverView =[[PopupInjuryTypeViewController alloc] initWithNibName:@"PopupInjuryTypeViewController" bundle:nil];
                    
                    popoverView.area = @"Front Left Hand";
                    popoverView.array = self.injuryArray;
                    popoverView.view.backgroundColor = [UIColor whiteColor];//mani
                    self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
                    self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
                    self.popover.popoverContentSize = CGSizeMake(350, 400);
                    popoverView.delegate = self;
                    
                    CGRect frame = CGRectMake(self.location.x - 15, self.location.y - 200, 350, 400);
                    [self.popover presentPopoverFromRect:frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
                }
                
                
            }
            else
            {
                if ( (location.x > FeMale_BackHead_x1) && (location.x < FeMale_BackHead_x2) && (location.y>FeMale_BackHead_y1) && (location.y < FeMale_BackHead_y2) )
                {
                    if ([injuryArray count] < 1)
                    {
                        NSString* querySql = @"select InjuryID, 'InjuryType' , Type from InjuryType";
                        
                        @synchronized(g_SYNCLOOKUPDB)
                        {
                            self.injuryArray = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:querySql WithExtraInfo:NO];
                        }
                    }
                    PopupInjuryTypeViewController* popoverView =[[PopupInjuryTypeViewController alloc] initWithNibName:@"PopupInjuryTypeViewController" bundle:nil];
                    
                    popoverView.area = @"Back Head";
                    popoverView.array = self.injuryArray;
                    popoverView.view.backgroundColor = [UIColor whiteColor];//mani
                    self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
                    self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
                    self.popover.popoverContentSize = CGSizeMake(350, 400);
                    popoverView.delegate = self;
                    
                    CGRect frame = CGRectMake(self.location.x - 15, self.location.y - 200, 350, 400);
                    [self.popover presentPopoverFromRect:frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
                }
                else if ( (location.x > FeMale_BackNeck_x1) && (location.x < FeMale_BackNeck_x2) && (location.y>FeMale_BackNeck_y1) && (location.y < FeMale_BackNeck_y2) )
                {
                    if ([injuryArray count] < 1)
                    {
                        NSString* querySql = @"select InjuryID, 'InjuryType' , Type from InjuryType";
                        
                        @synchronized(g_SYNCLOOKUPDB)
                        {
                            self.injuryArray = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:querySql WithExtraInfo:NO];
                        }
                    }
                    PopupInjuryTypeViewController* popoverView =[[PopupInjuryTypeViewController alloc] initWithNibName:@"PopupInjuryTypeViewController" bundle:nil];
                    
                    popoverView.area = @"Back Neck";
                    popoverView.array = self.injuryArray;
                    popoverView.view.backgroundColor = [UIColor whiteColor];//mani
                    self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
                    self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
                    self.popover.popoverContentSize = CGSizeMake(350, 400);
                    popoverView.delegate = self;
                    
                    CGRect frame = CGRectMake(self.location.x - 15, self.location.y - 200, 350, 400);
                    [self.popover presentPopoverFromRect:frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
                }
                else if ( (location.x > FeMale_LeftUpperBack_x1) && (location.x < FeMale_LeftUpperBack_x2) && (location.y>FeMale_LeftUpperBack_y1) && (location.y < FeMale_LeftUpperBack_y2) )
                {
                    if ([injuryArray count] < 1)
                    {
                        NSString* querySql = @"select InjuryID, 'InjuryType' , Type from InjuryType";
                        
                        @synchronized(g_SYNCLOOKUPDB)
                        {
                            self.injuryArray = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:querySql WithExtraInfo:NO];
                        }
                    }
                    PopupInjuryTypeViewController* popoverView =[[PopupInjuryTypeViewController alloc] initWithNibName:@"PopupInjuryTypeViewController" bundle:nil];
                    
                    popoverView.area = @"Left Upper Back";
                    popoverView.array = self.injuryArray;
                    popoverView.view.backgroundColor = [UIColor whiteColor];//mani
                    self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
                    self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
                    self.popover.popoverContentSize = CGSizeMake(350, 400);
                    popoverView.delegate = self;
                    
                    CGRect frame = CGRectMake(self.location.x - 15, self.location.y - 200, 350, 400);
                    [self.popover presentPopoverFromRect:frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
                }
                else if ( (location.x > FeMale_RightUpperBack_x1) && (location.x < FeMale_RightUpperBack_x2) && (location.y>FeMale_RightUpperBack_y1) && (location.y < FeMale_RightUpperBack_y2) )
                {
                    if ([injuryArray count] < 1)
                    {
                        NSString* querySql = @"select InjuryID, 'InjuryType' , Type from InjuryType";
                        
                        @synchronized(g_SYNCLOOKUPDB)
                        {
                            self.injuryArray = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:querySql WithExtraInfo:NO];
                        }
                    }
                    PopupInjuryTypeViewController* popoverView =[[PopupInjuryTypeViewController alloc] initWithNibName:@"PopupInjuryTypeViewController" bundle:nil];
                    
                    popoverView.area = @"Right Upper Back";
                    popoverView.array = self.injuryArray;
                    popoverView.view.backgroundColor = [UIColor whiteColor];//mani
                    self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
                    self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
                    self.popover.popoverContentSize = CGSizeMake(350, 400);
                    popoverView.delegate = self;
                    
                    CGRect frame = CGRectMake(self.location.x - 15, self.location.y - 200, 350, 400);
                    [self.popover presentPopoverFromRect:frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
                }
                else if ( (location.x > FeMale_LeftLowerBack_x1) && (location.x < FeMale_LeftLowerBack_x2) && (location.y>FeMale_LeftLowerBack_y1) && (location.y < FeMale_LeftLowerBack_y2) )
                {
                    if ([injuryArray count] < 1)
                    {
                        NSString* querySql = @"select InjuryID, 'InjuryType' , Type from InjuryType";
                        
                        @synchronized(g_SYNCLOOKUPDB)
                        {
                            self.injuryArray = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:querySql WithExtraInfo:NO];
                        }
                    }
                    PopupInjuryTypeViewController* popoverView =[[PopupInjuryTypeViewController alloc] initWithNibName:@"PopupInjuryTypeViewController" bundle:nil];
                    
                    popoverView.area = @"Left Lower Back";
                    popoverView.array = self.injuryArray;
                    popoverView.view.backgroundColor = [UIColor whiteColor];//mani
                    self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
                    self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
                    self.popover.popoverContentSize = CGSizeMake(350, 400);
                    popoverView.delegate = self;
                    
                    CGRect frame = CGRectMake(self.location.x - 15, self.location.y - 200, 350, 400);
                    [self.popover presentPopoverFromRect:frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
                }
                else if ( (location.x > FeMale_RightLowerBack_x1) && (location.x < FeMale_RightLowerBack_x2) && (location.y>FeMale_RightLowerBack_y1) && (location.y < FeMale_RightLowerBack_y2) )
                {
                    if ([injuryArray count] < 1)
                    {
                        NSString* querySql = @"select InjuryID, 'InjuryType' , Type from InjuryType";
                        
                        @synchronized(g_SYNCLOOKUPDB)
                        {
                            self.injuryArray = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:querySql WithExtraInfo:NO];
                        }
                    }
                    PopupInjuryTypeViewController* popoverView =[[PopupInjuryTypeViewController alloc] initWithNibName:@"PopupInjuryTypeViewController" bundle:nil];
                    
                    popoverView.area = @"Right Lower Back";
                    popoverView.array = self.injuryArray;
                    popoverView.view.backgroundColor = [UIColor whiteColor];//mani
                    self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
                    self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
                    self.popover.popoverContentSize = CGSizeMake(350, 400);
                    popoverView.delegate = self;
                    
                    CGRect frame = CGRectMake(self.location.x - 15, self.location.y - 200, 350, 400);
                    [self.popover presentPopoverFromRect:frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
                }
                else if ( (location.x > FeMale_LeftButtock_x1) && (location.x < FeMale_LeftButtock_x2) && (location.y>FeMale_LeftButtock_y1) && (location.y < FeMale_LeftButtock_y2) )
                {
                    if ([injuryArray count] < 1)
                    {
                        NSString* querySql = @"select InjuryID, 'InjuryType' , Type from InjuryType";
                        
                        @synchronized(g_SYNCLOOKUPDB)
                        {
                            self.injuryArray = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:querySql WithExtraInfo:NO];
                        }
                    }
                    PopupInjuryTypeViewController* popoverView =[[PopupInjuryTypeViewController alloc] initWithNibName:@"PopupInjuryTypeViewController" bundle:nil];
                    
                    popoverView.area = @"Left Buttock";
                    popoverView.array = self.injuryArray;
                    popoverView.view.backgroundColor = [UIColor whiteColor];//mani
                    self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
                    self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
                    self.popover.popoverContentSize = CGSizeMake(350, 400);
                    popoverView.delegate = self;
                    
                    CGRect frame = CGRectMake(self.location.x - 15, self.location.y - 200, 350, 400);
                    [self.popover presentPopoverFromRect:frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
                }
                else if ( (location.x > FeMale_RightButtock_x1) && (location.x < FeMale_RightButtock_x2) && (location.y>FeMale_RightButtock_y1) && (location.y < FeMale_RightButtock_y2) )
                {
                    if ([injuryArray count] < 1)
                    {
                        NSString* querySql = @"select InjuryID, 'InjuryType' , Type from InjuryType";
                        
                        @synchronized(g_SYNCLOOKUPDB)
                        {
                            self.injuryArray = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:querySql WithExtraInfo:NO];
                        }
                    }
                    PopupInjuryTypeViewController* popoverView =[[PopupInjuryTypeViewController alloc] initWithNibName:@"PopupInjuryTypeViewController" bundle:nil];
                    
                    popoverView.area = @"Right Buttock";
                    popoverView.array = self.injuryArray;
                    popoverView.view.backgroundColor = [UIColor whiteColor];//mani
                    self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
                    self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
                    self.popover.popoverContentSize = CGSizeMake(350, 400);
                    popoverView.delegate = self;
                    
                    CGRect frame = CGRectMake(self.location.x - 15, self.location.y - 200, 350, 400);
                    [self.popover presentPopoverFromRect:frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
                }
                else if ( (location.x > FeMale_LeftBackUpperLeg_x1) && (location.x < FeMale_LeftBackUpperLeg_x2) && (location.y>FeMale_LeftBackUpperLeg_y1) && (location.y < FeMale_LeftBackUpperLeg_y2) )
                {
                    if ([injuryArray count] < 1)
                    {
                        NSString* querySql = @"select InjuryID, 'InjuryType' , Type from InjuryType";
                        
                        @synchronized(g_SYNCLOOKUPDB)
                        {
                            self.injuryArray = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:querySql WithExtraInfo:NO];
                        }
                    }
                    PopupInjuryTypeViewController* popoverView =[[PopupInjuryTypeViewController alloc] initWithNibName:@"PopupInjuryTypeViewController" bundle:nil];
                    
                    popoverView.area = @"Back Left Upper Leg";
                    popoverView.array = self.injuryArray;
                    popoverView.view.backgroundColor = [UIColor whiteColor];//mani
                    self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
                    self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
                    self.popover.popoverContentSize = CGSizeMake(350, 400);
                    popoverView.delegate = self;
                    
                    CGRect frame = CGRectMake(self.location.x - 15, self.location.y - 200, 350, 400);
                    [self.popover presentPopoverFromRect:frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
                }
                else if ( (location.x > FeMale_RightBackUpperLeg_x1) && (location.x < FeMale_RightBackUpperLeg_x2) && (location.y>FeMale_RightBackUpperLeg_y1) && (location.y < FeMale_RightBackUpperLeg_y2) )
                {
                    if ([injuryArray count] < 1)
                    {
                        NSString* querySql = @"select InjuryID, 'InjuryType' , Type from InjuryType";
                        
                        @synchronized(g_SYNCLOOKUPDB)
                        {
                            self.injuryArray = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:querySql WithExtraInfo:NO];
                        }
                    }
                    PopupInjuryTypeViewController* popoverView =[[PopupInjuryTypeViewController alloc] initWithNibName:@"PopupInjuryTypeViewController" bundle:nil];
                    
                    popoverView.area = @"Back Right Upper Leg";
                    popoverView.array = self.injuryArray;
                    popoverView.view.backgroundColor = [UIColor whiteColor];//mani
                    self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
                    self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
                    self.popover.popoverContentSize = CGSizeMake(350, 400);
                    popoverView.delegate = self;
                    
                    CGRect frame = CGRectMake(self.location.x - 15, self.location.y - 200, 350, 400);
                    [self.popover presentPopoverFromRect:frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
                }
                else if ( (location.x > FeMale_BackLeftKnee_x1) && (location.x < FeMale_BackLeftKnee_x2) && (location.y>FeMale_BackLeftKnee_y1) && (location.y < FeMale_BackLeftKnee_y2) )
                {
                    if ([injuryArray count] < 1)
                    {
                        NSString* querySql = @"select InjuryID, 'InjuryType' , Type from InjuryType";
                        
                        @synchronized(g_SYNCLOOKUPDB)
                        {
                            self.injuryArray = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:querySql WithExtraInfo:NO];
                        }
                    }
                    PopupInjuryTypeViewController* popoverView =[[PopupInjuryTypeViewController alloc] initWithNibName:@"PopupInjuryTypeViewController" bundle:nil];
                    
                    popoverView.area = @"Back Left Knee";
                    popoverView.array = self.injuryArray;
                    popoverView.view.backgroundColor = [UIColor whiteColor];//mani
                    self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
                    self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
                    self.popover.popoverContentSize = CGSizeMake(350, 400);
                    popoverView.delegate = self;
                    
                    CGRect frame = CGRectMake(self.location.x - 15, self.location.y - 200, 350, 400);
                    [self.popover presentPopoverFromRect:frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
                }
                else if ( (location.x > FeMale_BackRightKnee_x1) && (location.x < FeMale_BackRightKnee_x2) && (location.y>FeMale_BackRightKnee_y1) && (location.y < FeMale_BackRightKnee_y2) )
                {
                    if ([injuryArray count] < 1)
                    {
                        NSString* querySql = @"select InjuryID, 'InjuryType' , Type from InjuryType";
                        
                        @synchronized(g_SYNCLOOKUPDB)
                        {
                            self.injuryArray = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:querySql WithExtraInfo:NO];
                        }
                    }
                    PopupInjuryTypeViewController* popoverView =[[PopupInjuryTypeViewController alloc] initWithNibName:@"PopupInjuryTypeViewController" bundle:nil];
                    
                    popoverView.area = @"Back Right Knee";
                    popoverView.array = self.injuryArray;
                    popoverView.view.backgroundColor = [UIColor whiteColor];//mani
                    self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
                    self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
                    self.popover.popoverContentSize = CGSizeMake(350, 400);
                    popoverView.delegate = self;
                    
                    CGRect frame = CGRectMake(self.location.x - 15, self.location.y - 200, 350, 400);
                    [self.popover presentPopoverFromRect:frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
                }
                else if ( (location.x > FeMale_BackLeftLowerLeg_x1) && (location.x < FeMale_BackLeftLowerLeg_x2) && (location.y>FeMale_BackLeftLowerLeg_y1) && (location.y < FeMale_BackLeftLowerLeg_y2) )
                {
                    if ([injuryArray count] < 1)
                    {
                        NSString* querySql = @"select InjuryID, 'InjuryType' , Type from InjuryType";
                        
                        @synchronized(g_SYNCLOOKUPDB)
                        {
                            self.injuryArray = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:querySql WithExtraInfo:NO];
                        }
                    }
                    PopupInjuryTypeViewController* popoverView =[[PopupInjuryTypeViewController alloc] initWithNibName:@"PopupInjuryTypeViewController" bundle:nil];
                    
                    popoverView.area = @"Back Left Lower Leg";
                    popoverView.array = self.injuryArray;
                    popoverView.view.backgroundColor = [UIColor whiteColor];//mani
                    self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
                    self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
                    self.popover.popoverContentSize = CGSizeMake(350, 400);
                    popoverView.delegate = self;
                    
                    CGRect frame = CGRectMake(self.location.x - 15, self.location.y - 200, 350, 400);
                    [self.popover presentPopoverFromRect:frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
                }
                else if ( (location.x > FeMale_BackRightLowerLeg_x1) && (location.x < FeMale_BackRightLowerLeg_x2) && (location.y>FeMale_BackRightLowerLeg_y1) && (location.y < FeMale_BackRightLowerLeg_y2) )
                {
                    if ([injuryArray count] < 1)
                    {
                        NSString* querySql = @"select InjuryID, 'InjuryType' , Type from InjuryType";
                        
                        @synchronized(g_SYNCLOOKUPDB)
                        {
                            self.injuryArray = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:querySql WithExtraInfo:NO];
                        }
                    }
                    PopupInjuryTypeViewController* popoverView =[[PopupInjuryTypeViewController alloc] initWithNibName:@"PopupInjuryTypeViewController" bundle:nil];
                    
                    popoverView.area = @"Back Right Lower Leg";
                    popoverView.array = self.injuryArray;
                    popoverView.view.backgroundColor = [UIColor whiteColor];//mani
                    self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
                    self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
                    self.popover.popoverContentSize = CGSizeMake(350, 400);
                    popoverView.delegate = self;
                    
                    CGRect frame = CGRectMake(self.location.x - 15, self.location.y - 200, 350, 400);
                    [self.popover presentPopoverFromRect:frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
                }
                else if ( (location.x > FeMale_BackLeftFoot_x1) && (location.x < FeMale_BackLeftFoot_x2) && (location.y>FeMale_BackLeftFoot_y1) && (location.y < FeMale_BackLeftFoot_y2) )
                {
                    if ([injuryArray count] < 1)
                    {
                        NSString* querySql = @"select InjuryID, 'InjuryType' , Type from InjuryType";
                        
                        @synchronized(g_SYNCLOOKUPDB)
                        {
                            self.injuryArray = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:querySql WithExtraInfo:NO];
                        }
                    }
                    PopupInjuryTypeViewController* popoverView =[[PopupInjuryTypeViewController alloc] initWithNibName:@"PopupInjuryTypeViewController" bundle:nil];
                    
                    popoverView.area = @"Back Left Foot";
                    popoverView.array = self.injuryArray;
                    popoverView.view.backgroundColor = [UIColor whiteColor];//mani
                    self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
                    self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
                    self.popover.popoverContentSize = CGSizeMake(350, 400);
                    popoverView.delegate = self;
                    
                    CGRect frame = CGRectMake(self.location.x - 15, self.location.y - 200, 350, 400);
                    [self.popover presentPopoverFromRect:frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
                }
                else if ( (location.x > FeMale_BackRightFoot_x1) && (location.x < FeMale_BackRightFoot_x2) && (location.y>FeMale_BackRightFoot_y1) && (location.y < FeMale_BackRightFoot_y2) )
                {
                    if ([injuryArray count] < 1)
                    {
                        NSString* querySql = @"select InjuryID, 'InjuryType' , Type from InjuryType";
                        
                        @synchronized(g_SYNCLOOKUPDB)
                        {
                            self.injuryArray = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:querySql WithExtraInfo:NO];
                        }
                    }
                    PopupInjuryTypeViewController* popoverView =[[PopupInjuryTypeViewController alloc] initWithNibName:@"PopupInjuryTypeViewController" bundle:nil];
                    
                    popoverView.area = @"Back Right Foot";
                    popoverView.array = self.injuryArray;
                    popoverView.view.backgroundColor = [UIColor whiteColor];//mani
                    self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
                    self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
                    self.popover.popoverContentSize = CGSizeMake(350, 400);
                    popoverView.delegate = self;
                    
                    CGRect frame = CGRectMake(self.location.x - 15, self.location.y - 200, 350, 400);
                    [self.popover presentPopoverFromRect:frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
                }
                else if ( (location.x > FeMale_BackLeftUpperArm_x1) && (location.x < FeMale_BackLeftUpperArm_x2) && (location.y>FeMale_BackLeftUpperArm_y1) && (location.y < FeMale_BackLeftUpperArm_y2) )
                {
                    if ([injuryArray count] < 1)
                    {
                        NSString* querySql = @"select InjuryID, 'InjuryType' , Type from InjuryType";
                        
                        @synchronized(g_SYNCLOOKUPDB)
                        {
                            self.injuryArray = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:querySql WithExtraInfo:NO];
                        }
                    }
                    PopupInjuryTypeViewController* popoverView =[[PopupInjuryTypeViewController alloc] initWithNibName:@"PopupInjuryTypeViewController" bundle:nil];
                    
                    popoverView.area = @"Back Left Upper Arm";
                    popoverView.array = self.injuryArray;
                    popoverView.view.backgroundColor = [UIColor whiteColor];//mani
                    self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
                    self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
                    self.popover.popoverContentSize = CGSizeMake(350, 400);
                    popoverView.delegate = self;
                    
                    CGRect frame = CGRectMake(self.location.x - 15, self.location.y - 200, 350, 400);
                    [self.popover presentPopoverFromRect:frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
                }
                else if ( (location.x > FeMale_BackLeftLowerArm_x1) && (location.x < FeMale_BackLeftLowerArm_x2) && (location.y>FeMale_BackLeftLowerArm_y1) && (location.y < FeMale_BackLeftLowerArm_y2) )
                {
                    if ([injuryArray count] < 1)
                    {
                        NSString* querySql = @"select InjuryID, 'InjuryType' , Type from InjuryType";
                        
                        @synchronized(g_SYNCLOOKUPDB)
                        {
                            self.injuryArray = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:querySql WithExtraInfo:NO];
                        }
                    }
                    PopupInjuryTypeViewController* popoverView =[[PopupInjuryTypeViewController alloc] initWithNibName:@"PopupInjuryTypeViewController" bundle:nil];
                    
                    popoverView.area = @"Back Left Lower Arm";
                    popoverView.array = self.injuryArray;
                    popoverView.view.backgroundColor = [UIColor whiteColor];//mani
                    self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
                    self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
                    self.popover.popoverContentSize = CGSizeMake(350, 400);
                    popoverView.delegate = self;
                    
                    CGRect frame = CGRectMake(self.location.x - 15, self.location.y - 200, 350, 400);
                    [self.popover presentPopoverFromRect:frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
                }
                else if ( (location.x > FeMale_BackLeftHand_x1) && (location.x < FeMale_BackLeftHand_x2) && (location.y>FeMale_BackLeftHand_y1) && (location.y < FeMale_BackLeftHand_y2) )
                {
                    if ([injuryArray count] < 1)
                    {
                        NSString* querySql = @"select InjuryID, 'InjuryType' , Type from InjuryType";
                        
                        @synchronized(g_SYNCLOOKUPDB)
                        {
                            self.injuryArray = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:querySql WithExtraInfo:NO];
                        }
                    }
                    PopupInjuryTypeViewController* popoverView =[[PopupInjuryTypeViewController alloc] initWithNibName:@"PopupInjuryTypeViewController" bundle:nil];
                    
                    popoverView.area = @"Back Left Hand";
                    popoverView.array = self.injuryArray;
                    popoverView.view.backgroundColor = [UIColor whiteColor];//mani
                    self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
                    self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
                    self.popover.popoverContentSize = CGSizeMake(350, 400);
                    popoverView.delegate = self;
                    
                    CGRect frame = CGRectMake(self.location.x - 15, self.location.y - 200, 350, 400);
                    [self.popover presentPopoverFromRect:frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
                }
                else if ( (location.x > FeMale_BackRightUpperArm_x1) && (location.x < FeMale_BackRightUpperArm_x2) && (location.y>FeMale_BackRightUpperArm_y1) && (location.y < FeMale_BackRightUpperArm_y2) )
                {
                    if ([injuryArray count] < 1)
                    {
                        NSString* querySql = @"select InjuryID, 'InjuryType' , Type from InjuryType";
                        
                        @synchronized(g_SYNCLOOKUPDB)
                        {
                            self.injuryArray = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:querySql WithExtraInfo:NO];
                        }
                    }
                    PopupInjuryTypeViewController* popoverView =[[PopupInjuryTypeViewController alloc] initWithNibName:@"PopupInjuryTypeViewController" bundle:nil];
                    
                    popoverView.area = @"Back Right Upper Arm";
                    popoverView.array = self.injuryArray;
                    popoverView.view.backgroundColor = [UIColor whiteColor];//mani
                    self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
                    self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
                    self.popover.popoverContentSize = CGSizeMake(350, 400);
                    popoverView.delegate = self;
                    
                    CGRect frame = CGRectMake(self.location.x - 15, self.location.y - 200, 350, 400);
                    [self.popover presentPopoverFromRect:frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
                }
                else if ( (location.x > FeMale_BackRightLowerArm_x1) && (location.x < FeMale_BackRightLowerArm_x2) && (location.y>FeMale_BackRightLowerArm_y1) && (location.y < FeMale_BackRightLowerArm_y2) )
                {
                    if ([injuryArray count] < 1)
                    {
                        NSString* querySql = @"select InjuryID, 'InjuryType' , Type from InjuryType";
                        
                        @synchronized(g_SYNCLOOKUPDB)
                        {
                            self.injuryArray = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:querySql WithExtraInfo:NO];
                        }
                    }
                    PopupInjuryTypeViewController* popoverView =[[PopupInjuryTypeViewController alloc] initWithNibName:@"PopupInjuryTypeViewController" bundle:nil];
                    
                    popoverView.area = @"Back Right Lower Arm";
                    popoverView.array = self.injuryArray;
                    popoverView.view.backgroundColor = [UIColor whiteColor];//mani
                    self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
                    self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
                    self.popover.popoverContentSize = CGSizeMake(350, 400);
                    popoverView.delegate = self;
                    
                    CGRect frame = CGRectMake(self.location.x - 15, self.location.y - 200, 350, 400);
                    [self.popover presentPopoverFromRect:frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
                }
                else if ( (location.x > FeMale_BackRightHand_x1) && (location.x < FeMale_BackRightHand_x2) && (location.y>FeMale_BackRightHand_y1) && (location.y < FeMale_BackRightHand_y2) )
                {
                    if ([injuryArray count] < 1)
                    {
                        NSString* querySql = @"select InjuryID, 'InjuryType' , Type from InjuryType";
                        
                        @synchronized(g_SYNCLOOKUPDB)
                        {
                            self.injuryArray = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:querySql WithExtraInfo:NO];
                        }
                    }
                    PopupInjuryTypeViewController* popoverView =[[PopupInjuryTypeViewController alloc] initWithNibName:@"PopupInjuryTypeViewController" bundle:nil];
                    
                    popoverView.area = @"Back Right Hand";
                    popoverView.array = self.injuryArray;
                    popoverView.view.backgroundColor = [UIColor whiteColor];//mani
                    self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
                    self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
                    self.popover.popoverContentSize = CGSizeMake(350, 400);
                    popoverView.delegate = self;
                    
                    CGRect frame = CGRectMake(self.location.x - 15, self.location.y - 200, 350, 400);
                    [self.popover presentPopoverFromRect:frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
                }
                
            }   // female back view

        }
        else // male
        {
            if (frontView)
            {
                if ( (location.x > Male_Head_x1) && (location.x < Male_Head_x2) && (location.y>Male_Head_y1) && (location.y < Male_Head_y2) )
                {
                    if ([injuryArray count] < 1)
                    {
                        NSString* querySql = @"select InjuryID, 'InjuryType' , Type from InjuryType";
                        
                        @synchronized(g_SYNCLOOKUPDB)
                        {
                            self.injuryArray = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:querySql WithExtraInfo:NO];
                        }
                    }
                    PopupInjuryTypeViewController* popoverView =[[PopupInjuryTypeViewController alloc] initWithNibName:@"PopupInjuryTypeViewController" bundle:nil];
                    
                    popoverView.area = @"Head";
                    popoverView.array = self.injuryArray;
                    popoverView.view.backgroundColor = [UIColor whiteColor];//mani
                    self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
                    self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
                    self.popover.popoverContentSize = CGSizeMake(350, 400);
                    popoverView.delegate = self;
                    
                    CGRect frame = CGRectMake(self.location.x - 15, self.location.y - 200, 350, 400);
                    [self.popover presentPopoverFromRect:frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
                }
                else if ( (location.x > Male_Neck_x1) && (location.x < Male_Neck_x2) && (location.y>Male_Neck_y1) && (location.y < Male_Neck_y2) )
                {
                    if ([injuryArray count] < 1)
                    {
                        NSString* querySql = @"select InjuryID, 'InjuryType' , Type from InjuryType";
                        
                        @synchronized(g_SYNCLOOKUPDB)
                        {
                            self.injuryArray = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:querySql WithExtraInfo:NO];
                        }
                    }
                    PopupInjuryTypeViewController* popoverView =[[PopupInjuryTypeViewController alloc] initWithNibName:@"PopupInjuryTypeViewController" bundle:nil];
                    
                    popoverView.area = @"Front Neck";
                    popoverView.array = self.injuryArray;
                    popoverView.view.backgroundColor = [UIColor whiteColor];//mani
                    self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
                    self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
                    self.popover.popoverContentSize = CGSizeMake(350, 400);
                    popoverView.delegate = self;
                    
                    CGRect frame = CGRectMake(self.location.x - 15, self.location.y - 200, 350, 400);
                    [self.popover presentPopoverFromRect:frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
                }
                else if ( (location.x > Male_RightChest_x1) && (location.x < Male_RightChest_x2) && (location.y>Male_RightChest_y1) && (location.y < Male_RightChest_y2) )
                {
                    if ([injuryArray count] < 1)
                    {
                        NSString* querySql = @"select InjuryID, 'InjuryType' , Type from InjuryType";
                        
                        @synchronized(g_SYNCLOOKUPDB)
                        {
                            self.injuryArray = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:querySql WithExtraInfo:NO];
                        }
                    }
                    PopupInjuryTypeViewController* popoverView =[[PopupInjuryTypeViewController alloc] initWithNibName:@"PopupInjuryTypeViewController" bundle:nil];
                    
                    popoverView.area = @"Right Chest";
                    popoverView.array = self.injuryArray;
                    popoverView.view.backgroundColor = [UIColor whiteColor];//mani
                    self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
                    self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
                    self.popover.popoverContentSize = CGSizeMake(350, 400);
                    popoverView.delegate = self;
                    
                    CGRect frame = CGRectMake(self.location.x - 15, self.location.y - 200, 350, 400);
                    [self.popover presentPopoverFromRect:frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
                }
                else if ( (location.x > Male_LeftChest_x1) && (location.x < Male_LeftChest_x2) && (location.y>Male_LeftChest_y1) && (location.y < Male_LeftChest_y2) )
                {
                    if ([injuryArray count] < 1)
                    {
                        NSString* querySql = @"select InjuryID, 'InjuryType' , Type from InjuryType";
                        
                        @synchronized(g_SYNCLOOKUPDB)
                        {
                            self.injuryArray = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:querySql WithExtraInfo:NO];
                        }
                    }
                    PopupInjuryTypeViewController* popoverView =[[PopupInjuryTypeViewController alloc] initWithNibName:@"PopupInjuryTypeViewController" bundle:nil];
                    
                    popoverView.area = @"Left Chest";
                    popoverView.array = self.injuryArray;
                    popoverView.view.backgroundColor = [UIColor whiteColor];//mani
                    self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
                    self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
                    self.popover.popoverContentSize = CGSizeMake(350, 400);
                    popoverView.delegate = self;
                    
                    CGRect frame = CGRectMake(self.location.x - 15, self.location.y - 200, 350, 400);
                    [self.popover presentPopoverFromRect:frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
                }
                else if ( (location.x > Male_Abdomen_x1) && (location.x < Male_Abdomen_x2) && (location.y>Male_Abdomen_y1) && (location.y < Male_Abdomen_y2) )
                {
                    if ([injuryArray count] < 1)
                    {
                        NSString* querySql = @"select InjuryID, 'InjuryType' , Type from InjuryType";
                        
                        @synchronized(g_SYNCLOOKUPDB)
                        {
                            self.injuryArray = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:querySql WithExtraInfo:NO];
                        }
                    }
                    PopupInjuryTypeViewController* popoverView =[[PopupInjuryTypeViewController alloc] initWithNibName:@"PopupInjuryTypeViewController" bundle:nil];
                    
                    popoverView.area = @"Abdomen";
                    popoverView.array = self.injuryArray;
                    popoverView.view.backgroundColor = [UIColor whiteColor];//mani
                    self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
                    self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
                    self.popover.popoverContentSize = CGSizeMake(350, 400);
                    popoverView.delegate = self;
                    
                    CGRect frame = CGRectMake(self.location.x - 15, self.location.y - 200, 350, 400);
                    [self.popover presentPopoverFromRect:frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
                }
                else if ( (location.x > Male_Genitals_x1) && (location.x < Male_Genitals_x2) && (location.y>Male_Genitals_y1) && (location.y < Male_Genitals_y2) )
                {
                    if ([injuryArray count] < 1)
                    {
                        NSString* querySql = @"select InjuryID, 'InjuryType' , Type from InjuryType";
                        
                        @synchronized(g_SYNCLOOKUPDB)
                        {
                            self.injuryArray = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:querySql WithExtraInfo:NO];
                        }
                    }
                    PopupInjuryTypeViewController* popoverView =[[PopupInjuryTypeViewController alloc] initWithNibName:@"PopupInjuryTypeViewController" bundle:nil];
                    
                    popoverView.area = @"Genitals";
                    popoverView.array = self.injuryArray;
                    popoverView.view.backgroundColor = [UIColor whiteColor];//mani
                    self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
                    self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
                    self.popover.popoverContentSize = CGSizeMake(350, 400);
                    popoverView.delegate = self;
                    
                    CGRect frame = CGRectMake(self.location.x - 15, self.location.y - 200, 350, 400);
                    [self.popover presentPopoverFromRect:frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
                }
                else if ( (location.x > Male_RightUpperLeg_x1) && (location.x < Male_RightUpperLeg_x2) && (location.y>Male_RightUpperLeg_y1) && (location.y < Male_RightUpperLeg_y2) )
                {
                    if ([injuryArray count] < 1)
                    {
                        NSString* querySql = @"select InjuryID, 'InjuryType' , Type from InjuryType";
                        
                        @synchronized(g_SYNCLOOKUPDB)
                        {
                            self.injuryArray = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:querySql WithExtraInfo:NO];
                        }
                    }
                    PopupInjuryTypeViewController* popoverView =[[PopupInjuryTypeViewController alloc] initWithNibName:@"PopupInjuryTypeViewController" bundle:nil];
                    
                    popoverView.area = @"Front Right Upper Leg";
                    popoverView.array = self.injuryArray;
                    popoverView.view.backgroundColor = [UIColor whiteColor];//mani
                    self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
                    self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
                    self.popover.popoverContentSize = CGSizeMake(350, 400);
                    popoverView.delegate = self;
                    
                    CGRect frame = CGRectMake(self.location.x - 15, self.location.y - 200, 350, 400);
                    [self.popover presentPopoverFromRect:frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
                }
                else if ( (location.x > Male_LeftUpperLeg_x1) && (location.x < Male_LeftUpperLeg_x2) && (location.y>Male_LeftUpperLeg_y1) && (location.y < Male_LeftUpperLeg_y2) )
                {
                    if ([injuryArray count] < 1)
                    {
                        NSString* querySql = @"select InjuryID, 'InjuryType' , Type from InjuryType";
                        
                        @synchronized(g_SYNCLOOKUPDB)
                        {
                            self.injuryArray = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:querySql WithExtraInfo:NO];
                        }
                    }
                    PopupInjuryTypeViewController* popoverView =[[PopupInjuryTypeViewController alloc] initWithNibName:@"PopupInjuryTypeViewController" bundle:nil];
                    
                    popoverView.area = @"Front Left Upper Leg";
                    popoverView.array = self.injuryArray;
                    popoverView.view.backgroundColor = [UIColor whiteColor];//mani
                    self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
                    self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
                    self.popover.popoverContentSize = CGSizeMake(350, 400);
                    popoverView.delegate = self;
                    
                    CGRect frame = CGRectMake(self.location.x - 15, self.location.y - 200, 350, 400);
                    [self.popover presentPopoverFromRect:frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
                }
                else if ( (location.x > Male_FrontRightKnee_x1) && (location.x < Male_FrontRightKnee_x2) && (location.y>Male_FrontRightKnee_y1) && (location.y < Male_FrontRightKnee_y2) )
                {
                    if ([injuryArray count] < 1)
                    {
                        NSString* querySql = @"select InjuryID, 'InjuryType' , Type from InjuryType";
                        
                        @synchronized(g_SYNCLOOKUPDB)
                        {
                            self.injuryArray = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:querySql WithExtraInfo:NO];
                        }
                    }
                    PopupInjuryTypeViewController* popoverView =[[PopupInjuryTypeViewController alloc] initWithNibName:@"PopupInjuryTypeViewController" bundle:nil];
                    
                    popoverView.area = @"Front Right Knee";
                    popoverView.array = self.injuryArray;
                    popoverView.view.backgroundColor = [UIColor whiteColor];//mani
                    self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
                    self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
                    self.popover.popoverContentSize = CGSizeMake(350, 400);
                    popoverView.delegate = self;
                    
                    CGRect frame = CGRectMake(self.location.x - 15, self.location.y - 200, 350, 400);
                    [self.popover presentPopoverFromRect:frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
                }
                else if ( (location.x > Male_FrontLeftKnee_x1) && (location.x < Male_FrontLeftKnee_x2) && (location.y>Male_FrontLeftKnee_y1) && (location.y < Male_FrontLeftKnee_y2) )
                {
                    if ([injuryArray count] < 1)
                    {
                        NSString* querySql = @"select InjuryID, 'InjuryType' , Type from InjuryType";
                        
                        @synchronized(g_SYNCLOOKUPDB)
                        {
                            self.injuryArray = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:querySql WithExtraInfo:NO];
                        }
                    }
                    PopupInjuryTypeViewController* popoverView =[[PopupInjuryTypeViewController alloc] initWithNibName:@"PopupInjuryTypeViewController" bundle:nil];
                    
                    popoverView.area = @"Front Left Knee";
                    popoverView.array = self.injuryArray;
                    popoverView.view.backgroundColor = [UIColor whiteColor];//mani
                    self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
                    self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
                    self.popover.popoverContentSize = CGSizeMake(350, 400);
                    popoverView.delegate = self;
                    
                    CGRect frame = CGRectMake(self.location.x - 15, self.location.y - 200, 350, 400);
                    [self.popover presentPopoverFromRect:frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
                }
                else if ( (location.x > Male_RightLowerLeg_x1) && (location.x < Male_RightLowerLeg_x2) && (location.y>Male_RightLowerLeg_y1) && (location.y < Male_RightLowerLeg_y2) )
                {
                    if ([injuryArray count] < 1)
                    {
                        NSString* querySql = @"select InjuryID, 'InjuryType' , Type from InjuryType";
                        
                        @synchronized(g_SYNCLOOKUPDB)
                        {
                            self.injuryArray = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:querySql WithExtraInfo:NO];
                        }
                    }
                    PopupInjuryTypeViewController* popoverView =[[PopupInjuryTypeViewController alloc] initWithNibName:@"PopupInjuryTypeViewController" bundle:nil];
                    
                    popoverView.area = @"Front Right Lower Leg";
                    popoverView.array = self.injuryArray;
                    popoverView.view.backgroundColor = [UIColor whiteColor];//mani
                    self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
                    self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
                    self.popover.popoverContentSize = CGSizeMake(350, 400);
                    popoverView.delegate = self;
                    
                    CGRect frame = CGRectMake(self.location.x - 15, self.location.y - 200, 350, 400);
                    [self.popover presentPopoverFromRect:frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
                }
                else if ( (location.x > Male_LeftLowerLeg_x1) && (location.x < Male_LeftLowerLeg_x2) && (location.y>Male_LeftLowerLeg_y1) && (location.y < Male_LeftLowerLeg_y2) )
                {
                    if ([injuryArray count] < 1)
                    {
                        NSString* querySql = @"select InjuryID, 'InjuryType' , Type from InjuryType";
                        
                        @synchronized(g_SYNCLOOKUPDB)
                        {
                            self.injuryArray = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:querySql WithExtraInfo:NO];
                        }
                    }
                    PopupInjuryTypeViewController* popoverView =[[PopupInjuryTypeViewController alloc] initWithNibName:@"PopupInjuryTypeViewController" bundle:nil];
                    
                    popoverView.area = @"Front Left Lower Leg";
                    popoverView.array = self.injuryArray;
                    popoverView.view.backgroundColor = [UIColor whiteColor];//mani
                    self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
                    self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
                    self.popover.popoverContentSize = CGSizeMake(350, 400);
                    popoverView.delegate = self;
                    
                    CGRect frame = CGRectMake(self.location.x - 15, self.location.y - 200, 350, 400);
                    [self.popover presentPopoverFromRect:frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
                }
                else if ( (location.x > Male_FrontRightFoot_x1) && (location.x < Male_FrontRightFoot_x2) && (location.y>Male_FrontRightFoot_y1) && (location.y < Male_FrontRightFoot_y2) )
                {
                    if ([injuryArray count] < 1)
                    {
                        NSString* querySql = @"select InjuryID, 'InjuryType' , Type from InjuryType";
                        
                        @synchronized(g_SYNCLOOKUPDB)
                        {
                            self.injuryArray = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:querySql WithExtraInfo:NO];
                        }
                    }
                    PopupInjuryTypeViewController* popoverView =[[PopupInjuryTypeViewController alloc] initWithNibName:@"PopupInjuryTypeViewController" bundle:nil];
                    
                    popoverView.area = @"Front Right Foot";
                    popoverView.array = self.injuryArray;
                    popoverView.view.backgroundColor = [UIColor whiteColor];//mani
                    self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
                    self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
                    self.popover.popoverContentSize = CGSizeMake(350, 400);
                    popoverView.delegate = self;
                    
                    CGRect frame = CGRectMake(self.location.x - 15, self.location.y - 200, 350, 400);
                    [self.popover presentPopoverFromRect:frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
                }
                else if ( (location.x > Male_FrontLeftFoot_x1) && (location.x < Male_FrontLeftFoot_x2) && (location.y>Male_FrontLeftFoot_y1) && (location.y < Male_FrontLeftFoot_y2) )
                {
                    if ([injuryArray count] < 1)
                    {
                        NSString* querySql = @"select InjuryID, 'InjuryType' , Type from InjuryType";
                        
                        @synchronized(g_SYNCLOOKUPDB)
                        {
                            self.injuryArray = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:querySql WithExtraInfo:NO];
                        }
                    }
                    PopupInjuryTypeViewController* popoverView =[[PopupInjuryTypeViewController alloc] initWithNibName:@"PopupInjuryTypeViewController" bundle:nil];
                    
                    popoverView.area = @"Front Left Foot";
                    popoverView.array = self.injuryArray;
                    popoverView.view.backgroundColor = [UIColor whiteColor];//mani
                    self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
                    self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
                    self.popover.popoverContentSize = CGSizeMake(350, 400);
                    popoverView.delegate = self;
                    
                    CGRect frame = CGRectMake(self.location.x - 15, self.location.y - 200, 350, 400);
                    [self.popover presentPopoverFromRect:frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
                }
                else if ( (location.x > Male_RightUpperArm_x1) && (location.x < Male_RightUpperArm_x2) && (location.y>Male_RightUpperArm_y1) && (location.y < Male_RightUpperArm_y2) )
                {
                    if ([injuryArray count] < 1)
                    {
                        NSString* querySql = @"select InjuryID, 'InjuryType' , Type from InjuryType";
                        
                        @synchronized(g_SYNCLOOKUPDB)
                        {
                            self.injuryArray = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:querySql WithExtraInfo:NO];
                        }
                    }
                    PopupInjuryTypeViewController* popoverView =[[PopupInjuryTypeViewController alloc] initWithNibName:@"PopupInjuryTypeViewController" bundle:nil];
                    
                    popoverView.area = @"Front Upper Right Arm";
                    popoverView.array = self.injuryArray;
                    popoverView.view.backgroundColor = [UIColor whiteColor];//mani
                    self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
                    self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
                    self.popover.popoverContentSize = CGSizeMake(350, 400);
                    popoverView.delegate = self;
                    
                    CGRect frame = CGRectMake(self.location.x - 15, self.location.y - 200, 350, 400);
                    [self.popover presentPopoverFromRect:frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
                }
                else if ( (location.x > Male_RightLowerArm_x1) && (location.x < Male_RightLowerArm_x2) && (location.y>Male_RightLowerArm_y1) && (location.y < Male_RightLowerArm_y2) )
                {
                    if ([injuryArray count] < 1)
                    {
                        NSString* querySql = @"select InjuryID, 'InjuryType' , Type from InjuryType";
                        
                        @synchronized(g_SYNCLOOKUPDB)
                        {
                            self.injuryArray = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:querySql WithExtraInfo:NO];
                        }
                    }
                    PopupInjuryTypeViewController* popoverView =[[PopupInjuryTypeViewController alloc] initWithNibName:@"PopupInjuryTypeViewController" bundle:nil];
                    
                    popoverView.area = @"Front Lower Right Arm";
                    popoverView.array = self.injuryArray;
                    popoverView.view.backgroundColor = [UIColor whiteColor];//mani
                    self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
                    self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
                    self.popover.popoverContentSize = CGSizeMake(350, 400);
                    popoverView.delegate = self;
                    
                    CGRect frame = CGRectMake(self.location.x - 15, self.location.y - 200, 350, 400);
                    [self.popover presentPopoverFromRect:frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
                }
                else if ( (location.x > Male_RightHand_x1) && (location.x < Male_RightHand_x2) && (location.y>Male_RightHand_y1) && (location.y < Male_RightHand_y2) )
                {
                    if ([injuryArray count] < 1)
                    {
                        NSString* querySql = @"select InjuryID, 'InjuryType' , Type from InjuryType";
                        
                        @synchronized(g_SYNCLOOKUPDB)
                        {
                            self.injuryArray = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:querySql WithExtraInfo:NO];
                        }
                    }
                    PopupInjuryTypeViewController* popoverView =[[PopupInjuryTypeViewController alloc] initWithNibName:@"PopupInjuryTypeViewController" bundle:nil];
                    
                    popoverView.area = @"Front Right Hand";
                    popoverView.array = self.injuryArray;
                    popoverView.view.backgroundColor = [UIColor whiteColor];//mani
                    self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
                    self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
                    self.popover.popoverContentSize = CGSizeMake(350, 400);
                    popoverView.delegate = self;
                    
                    CGRect frame = CGRectMake(self.location.x - 15, self.location.y - 200, 350, 400);
                    [self.popover presentPopoverFromRect:frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
                }
                else if ( (location.x > Male_LeftUpperArm_x1) && (location.x < Male_LeftUpperArm_x2) && (location.y>Male_LeftUpperArm_y1) && (location.y < Male_LeftUpperArm_y2) )
                {
                    if ([injuryArray count] < 1)
                    {
                        NSString* querySql = @"select InjuryID, 'InjuryType' , Type from InjuryType";
                        
                        @synchronized(g_SYNCLOOKUPDB)
                        {
                            self.injuryArray = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:querySql WithExtraInfo:NO];
                        }
                    }
                    PopupInjuryTypeViewController* popoverView =[[PopupInjuryTypeViewController alloc] initWithNibName:@"PopupInjuryTypeViewController" bundle:nil];
                    
                    popoverView.area = @"Front Left Upper Arm";
                    popoverView.array = self.injuryArray;
                    popoverView.view.backgroundColor = [UIColor whiteColor];//mani
                    self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
                    self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
                    self.popover.popoverContentSize = CGSizeMake(350, 400);
                    popoverView.delegate = self;
                    
                    CGRect frame = CGRectMake(self.location.x - 15, self.location.y - 200, 350, 400);
                    [self.popover presentPopoverFromRect:frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
                }
                else if ( (location.x > Male_LeftLowerArm_x1) && (location.x < Male_LeftLowerArm_x2) && (location.y>Male_LeftLowerArm_y1) && (location.y < Male_LeftLowerArm_y2) )
                {
                    if ([injuryArray count] < 1)
                    {
                        NSString* querySql = @"select InjuryID, 'InjuryType' , Type from InjuryType";
                        
                        @synchronized(g_SYNCLOOKUPDB)
                        {
                            self.injuryArray = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:querySql WithExtraInfo:NO];
                        }
                    }
                    PopupInjuryTypeViewController* popoverView =[[PopupInjuryTypeViewController alloc] initWithNibName:@"PopupInjuryTypeViewController" bundle:nil];
                    
                    popoverView.area = @"Front Left Lower Arm";
                    popoverView.array = self.injuryArray;
                    popoverView.view.backgroundColor = [UIColor whiteColor];//mani
                    self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
                    self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
                    self.popover.popoverContentSize = CGSizeMake(350, 400);
                    popoverView.delegate = self;
                    
                    CGRect frame = CGRectMake(self.location.x - 15, self.location.y - 200, 350, 400);
                    [self.popover presentPopoverFromRect:frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
                }
                
                else if ( (location.x > Male_LeftHand_x1) && (location.x < Male_LeftHand_x2) && (location.y>Male_LeftHand_y1) && (location.y < Male_LeftHand_y2) )
                {
                    if ([injuryArray count] < 1)
                    {
                        NSString* querySql = @"select InjuryID, 'InjuryType' , Type from InjuryType";
                        
                        @synchronized(g_SYNCLOOKUPDB)
                        {
                            self.injuryArray = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:querySql WithExtraInfo:NO];
                        }
                    }
                    PopupInjuryTypeViewController* popoverView =[[PopupInjuryTypeViewController alloc] initWithNibName:@"PopupInjuryTypeViewController" bundle:nil];
                    
                    popoverView.area = @"Front Left Hand";
                    popoverView.array = self.injuryArray;
                    popoverView.view.backgroundColor = [UIColor whiteColor];//mani
                    self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
                    self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
                    self.popover.popoverContentSize = CGSizeMake(350, 400);
                    popoverView.delegate = self;
                    
                    CGRect frame = CGRectMake(self.location.x - 15, self.location.y - 200, 350, 400);
                    [self.popover presentPopoverFromRect:frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
                }
                
            }
            else  //  male back view
            {
                if ( (location.x > Male_BackHead_x1) && (location.x < Male_BackHead_x2) && (location.y>Male_BackHead_y1) && (location.y < Male_BackHead_y2) )
                {
                    if ([injuryArray count] < 1)
                    {
                        NSString* querySql = @"select InjuryID, 'InjuryType' , Type from InjuryType";
                        
                        @synchronized(g_SYNCLOOKUPDB)
                        {
                            self.injuryArray = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:querySql WithExtraInfo:NO];
                        }
                    }
                    
                    PopupInjuryTypeViewController* popoverView =[[PopupInjuryTypeViewController alloc] initWithNibName:@"PopupInjuryTypeViewController" bundle:nil];
                    
                    popoverView.area = @"Back Head";
                    popoverView.array = self.injuryArray;
                    popoverView.view.backgroundColor = [UIColor whiteColor];//mani
                    self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
                    self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
                    self.popover.popoverContentSize = CGSizeMake(350, 400);
                    popoverView.delegate = self;
                    
                    CGRect frame = CGRectMake(self.location.x - 15, self.location.y - 200, 350, 400);
                    
                    [self.popover presentPopoverFromRect:frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
                }
                
                else if ( (location.x > Male_BackNeck_x1) && (location.x < Male_BackNeck_x2) && (location.y>Male_BackNeck_y1) && (location.y < Male_BackNeck_y2) )
                {
                    if ([injuryArray count] < 1)
                    {
                        NSString* querySql = @"select InjuryID, 'InjuryType' , Type from InjuryType";
                        
                        @synchronized(g_SYNCLOOKUPDB)
                        {
                            self.injuryArray = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:querySql WithExtraInfo:NO];
                        }
                    }
                    PopupInjuryTypeViewController* popoverView =[[PopupInjuryTypeViewController alloc] initWithNibName:@"PopupInjuryTypeViewController" bundle:nil];
                    popoverView.area = @"Back Neck";
                    popoverView.array = self.injuryArray;
                    popoverView.view.backgroundColor = [UIColor whiteColor];//mani
                    self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
                    self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
                    self.popover.popoverContentSize = CGSizeMake(350, 400);
                    popoverView.delegate = self;
                    CGRect frame = CGRectMake(self.location.x - 15, self.location.y - 200, 350, 400);
                    
                    [self.popover presentPopoverFromRect:frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
                }
                else if ( (location.x > Male_LeftUpperBack_x1) && (location.x < Male_LeftUpperBack_x2) && (location.y>Male_LeftUpperBack_y1) && (location.y < Male_LeftUpperBack_y2) )
                {
                    if ([injuryArray count] < 1)
                    {
                        NSString* querySql = @"select InjuryID, 'InjuryType' , Type from InjuryType";
                        
                        @synchronized(g_SYNCLOOKUPDB)
                        {
                            self.injuryArray = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:querySql WithExtraInfo:NO];
                        }
                    }
                    PopupInjuryTypeViewController* popoverView =[[PopupInjuryTypeViewController alloc] initWithNibName:@"PopupInjuryTypeViewController" bundle:nil];
                    popoverView.area = @"Left Upper Back";
                    popoverView.array = self.injuryArray;
                    popoverView.view.backgroundColor = [UIColor whiteColor];//mani
                    self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
                    self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
                    self.popover.popoverContentSize = CGSizeMake(350, 400);
                    popoverView.delegate = self;
                    
                    CGRect frame = CGRectMake(self.location.x - 15, self.location.y - 200, 350, 400);
                    
                    [self.popover presentPopoverFromRect:frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
                }
                else if ( (location.x > Male_RightUpperBack_x1) && (location.x < Male_RightUpperBack_x2) && (location.y>Male_RightUpperBack_y1) && (location.y < Male_RightUpperBack_y2) )
                {
                    if ([injuryArray count] < 1)
                    {
                        NSString* querySql = @"select InjuryID, 'InjuryType' , Type from InjuryType";
                        
                        @synchronized(g_SYNCLOOKUPDB)
                        {
                            self.injuryArray = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:querySql WithExtraInfo:NO];
                        }
                    }
                    PopupInjuryTypeViewController* popoverView =[[PopupInjuryTypeViewController alloc] initWithNibName:@"PopupInjuryTypeViewController" bundle:nil];
                    popoverView.area = @"Right Upper Back";
                    popoverView.array = self.injuryArray;
                    popoverView.view.backgroundColor = [UIColor whiteColor];//mani
                    self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
                    self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
                    self.popover.popoverContentSize = CGSizeMake(350, 400);
                    popoverView.delegate = self;
                    CGRect frame = CGRectMake(self.location.x - 15, self.location.y - 200, 350, 400);
                    [self.popover presentPopoverFromRect:frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
                }
                else if ( (location.x > Male_LeftLowerBack_x1) && (location.x < Male_LeftLowerBack_x2) && (location.y>Male_LeftLowerBack_y1) && (location.y < Male_LeftLowerBack_y2) )
                {
                    if ([injuryArray count] < 1)
                    {
                        NSString* querySql = @"select InjuryID, 'InjuryType' , Type from InjuryType";
                        
                        @synchronized(g_SYNCLOOKUPDB)
                        {
                            self.injuryArray = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:querySql WithExtraInfo:NO];
                        }
                    }
                    PopupInjuryTypeViewController* popoverView =[[PopupInjuryTypeViewController alloc] initWithNibName:@"PopupInjuryTypeViewController" bundle:nil];
                    popoverView.area = @"Left Lower Back";
                    popoverView.array = self.injuryArray;
                    popoverView.view.backgroundColor = [UIColor whiteColor];//mani
                    self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
                    self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
                    self.popover.popoverContentSize = CGSizeMake(350, 400);
                    popoverView.delegate = self;
                    CGRect frame = CGRectMake(self.location.x - 15, self.location.y - 200, 350, 400);
                    [self.popover presentPopoverFromRect:frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
                }
                else if ( (location.x > Male_RightLowerBack_x1) && (location.x < Male_RightLowerBack_x2) && (location.y>Male_RightLowerBack_y1) && (location.y < Male_RightLowerBack_y2) )
                {
                    if ([injuryArray count] < 1)
                    {
                        NSString* querySql = @"select InjuryID, 'InjuryType' , Type from InjuryType";
                        
                        @synchronized(g_SYNCLOOKUPDB)
                        {
                            self.injuryArray = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:querySql WithExtraInfo:NO];
                        }
                    }
                    PopupInjuryTypeViewController* popoverView =[[PopupInjuryTypeViewController alloc] initWithNibName:@"PopupInjuryTypeViewController" bundle:nil];
                    popoverView.area = @"Right Lower Back";
                    popoverView.array = self.injuryArray;
                    popoverView.view.backgroundColor = [UIColor whiteColor];//mani
                    self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
                    self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
                    self.popover.popoverContentSize = CGSizeMake(350, 400);
                    popoverView.delegate = self;
                    CGRect frame = CGRectMake(self.location.x - 15, self.location.y - 200, 350, 400);
                    [self.popover presentPopoverFromRect:frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
                }
                else if ( (location.x > Male_LeftButtock_x1) && (location.x < Male_LeftButtock_x2) && (location.y>Male_LeftButtock_y1) && (location.y < Male_LeftButtock_y2) )
                {
                    if ([injuryArray count] < 1)
                    {
                        NSString* querySql = @"select InjuryID, 'InjuryType' , Type from InjuryType";
                        
                        @synchronized(g_SYNCLOOKUPDB)
                        {
                            self.injuryArray = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:querySql WithExtraInfo:NO];
                        }
                    }
                    PopupInjuryTypeViewController* popoverView =[[PopupInjuryTypeViewController alloc] initWithNibName:@"PopupInjuryTypeViewController" bundle:nil];
                    popoverView.area = @"Left Buttock";
                    popoverView.array = self.injuryArray;
                    popoverView.view.backgroundColor = [UIColor whiteColor];//mani
                    self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
                    self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
                    self.popover.popoverContentSize = CGSizeMake(350, 400);
                    popoverView.delegate = self;
                    CGRect frame = CGRectMake(self.location.x - 15, self.location.y - 200, 350, 400);
                    [self.popover presentPopoverFromRect:frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
                }
                else if ( (location.x > Male_RightButtock_x1) && (location.x < Male_RightButtock_x2) && (location.y>Male_RightButtock_y1) && (location.y < Male_RightButtock_y2) )
                {
                    if ([injuryArray count] < 1)
                    {
                        NSString* querySql = @"select InjuryID, 'InjuryType' , Type from InjuryType";
                        
                        @synchronized(g_SYNCLOOKUPDB)
                        {
                            self.injuryArray = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:querySql WithExtraInfo:NO];
                        }
                    }
                    PopupInjuryTypeViewController* popoverView =[[PopupInjuryTypeViewController alloc] initWithNibName:@"PopupInjuryTypeViewController" bundle:nil];
                    popoverView.area = @"Right Buttock";
                    popoverView.array = self.injuryArray;
                    popoverView.view.backgroundColor = [UIColor whiteColor];//mani
                    self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
                    self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
                    self.popover.popoverContentSize = CGSizeMake(350, 400);
                    popoverView.delegate = self;
                    CGRect frame = CGRectMake(self.location.x - 15, self.location.y - 200, 350, 400);
                    [self.popover presentPopoverFromRect:frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
                }
                else if ( (location.x > Male_LeftBackUpperLeg_x1) && (location.x < Male_LeftBackUpperLeg_x2) && (location.y>Male_LeftBackUpperLeg_y1) && (location.y < Male_LeftBackUpperLeg_y2) )
                {
                    if ([injuryArray count] < 1)
                    {
                        NSString* querySql = @"select InjuryID, 'InjuryType' , Type from InjuryType";
                        
                        @synchronized(g_SYNCLOOKUPDB)
                        {
                            self.injuryArray = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:querySql WithExtraInfo:NO];
                        }
                    }
                    PopupInjuryTypeViewController* popoverView =[[PopupInjuryTypeViewController alloc] initWithNibName:@"PopupInjuryTypeViewController" bundle:nil];
                    popoverView.area = @"Back Left Upper Leg";
                    popoverView.array = self.injuryArray;
                    popoverView.view.backgroundColor = [UIColor whiteColor];//mani
                    self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
                    self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
                    self.popover.popoverContentSize = CGSizeMake(350, 400);
                    popoverView.delegate = self;
                    CGRect frame = CGRectMake(self.location.x - 15, self.location.y - 200, 350, 400);
                    [self.popover presentPopoverFromRect:frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
                }
                else if ( (location.x > Male_RightBackUpperLeg_x1) && (location.x < Male_RightBackUpperLeg_x2) && (location.y>Male_RightBackUpperLeg_y1) && (location.y < Male_RightBackUpperLeg_y2) )
                {
                    if ([injuryArray count] < 1)
                    {
                        NSString* querySql = @"select InjuryID, 'InjuryType' , Type from InjuryType";
                        
                        @synchronized(g_SYNCLOOKUPDB)
                        {
                            self.injuryArray = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:querySql WithExtraInfo:NO];
                        }
                    }
                    PopupInjuryTypeViewController* popoverView =[[PopupInjuryTypeViewController alloc] initWithNibName:@"PopupInjuryTypeViewController" bundle:nil];
                    popoverView.area = @"Back Right Upper Leg";
                    popoverView.array = self.injuryArray;
                    popoverView.view.backgroundColor = [UIColor whiteColor];//mani
                    self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
                    self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
                    self.popover.popoverContentSize = CGSizeMake(350, 400);
                    popoverView.delegate = self;
                    CGRect frame = CGRectMake(self.location.x - 15, self.location.y - 200, 350, 400);
                    [self.popover presentPopoverFromRect:frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
                }
                else if ( (location.x > Male_BackLeftKnee_x1) && (location.x < Male_BackLeftKnee_x2) && (location.y>Male_BackLeftKnee_y1) && (location.y < Male_BackLeftKnee_y2) )
                {
                    if ([injuryArray count] < 1)
                    {
                        NSString* querySql = @"select InjuryID, 'InjuryType' , Type from InjuryType";
                        
                        @synchronized(g_SYNCLOOKUPDB)
                        {
                            self.injuryArray = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:querySql WithExtraInfo:NO];
                        }
                    }
                    PopupInjuryTypeViewController* popoverView =[[PopupInjuryTypeViewController alloc] initWithNibName:@"PopupInjuryTypeViewController" bundle:nil];
                    popoverView.area = @"Back Left Knee";
                    popoverView.array = self.injuryArray;
                    popoverView.view.backgroundColor = [UIColor whiteColor];//mani
                    self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
                    self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
                    self.popover.popoverContentSize = CGSizeMake(350, 400);
                    popoverView.delegate = self;
                    CGRect frame = CGRectMake(self.location.x - 15, self.location.y - 200, 350, 400);
                    [self.popover presentPopoverFromRect:frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
                }
                else if ( (location.x > Male_BackRightKnee_x1) && (location.x < Male_BackRightKnee_x2) && (location.y>Male_BackRightKnee_y1) && (location.y < Male_BackRightKnee_y2) )
                {
                    if ([injuryArray count] < 1)
                    {
                        NSString* querySql = @"select InjuryID, 'InjuryType' , Type from InjuryType";
                        
                        @synchronized(g_SYNCLOOKUPDB)
                        {
                            self.injuryArray = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:querySql WithExtraInfo:NO];
                        }
                    }
                    PopupInjuryTypeViewController* popoverView =[[PopupInjuryTypeViewController alloc] initWithNibName:@"PopupInjuryTypeViewController" bundle:nil];
                    popoverView.area = @"Back Right Knee";
                    popoverView.array = self.injuryArray;
                    popoverView.view.backgroundColor = [UIColor whiteColor];//mani
                    self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
                    self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
                    self.popover.popoverContentSize = CGSizeMake(350, 400);
                    popoverView.delegate = self;
                    CGRect frame = CGRectMake(self.location.x - 15, self.location.y - 200, 350, 400);
                    [self.popover presentPopoverFromRect:frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
                }
                else if ( (location.x > Male_BackLeftLowerLeg_x1) && (location.x < Male_BackLeftLowerLeg_x2) && (location.y>Male_BackLeftLowerLeg_y1) && (location.y < Male_BackLeftLowerLeg_y2) )
                {
                    if ([injuryArray count] < 1)
                    {
                        NSString* querySql = @"select InjuryID, 'InjuryType' , Type from InjuryType";
                        
                        @synchronized(g_SYNCLOOKUPDB)
                        {
                            self.injuryArray = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:querySql WithExtraInfo:NO];
                        }
                    }
                    PopupInjuryTypeViewController* popoverView =[[PopupInjuryTypeViewController alloc] initWithNibName:@"PopupInjuryTypeViewController" bundle:nil];
                    popoverView.area = @"Back Left Lower Leg";
                    popoverView.array = self.injuryArray;
                    popoverView.view.backgroundColor = [UIColor whiteColor];//mani
                    self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
                    self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
                    self.popover.popoverContentSize = CGSizeMake(350, 400);
                    popoverView.delegate = self;
                    CGRect frame = CGRectMake(self.location.x - 15, self.location.y - 200, 350, 400);
                    [self.popover presentPopoverFromRect:frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
                }
                else if ( (location.x > Male_BackRightLowerLeg_x1) && (location.x < Male_BackRightLowerLeg_x2) && (location.y>Male_BackRightLowerLeg_y1) && (location.y < Male_BackRightLowerLeg_y2) )
                {
                    if ([injuryArray count] < 1)
                    {
                        NSString* querySql = @"select InjuryID, 'InjuryType' , Type from InjuryType";
                        
                        @synchronized(g_SYNCLOOKUPDB)
                        {
                            self.injuryArray = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:querySql WithExtraInfo:NO];
                        }
                    }
                    PopupInjuryTypeViewController* popoverView =[[PopupInjuryTypeViewController alloc] initWithNibName:@"PopupInjuryTypeViewController" bundle:nil];
                    popoverView.area = @"Back Right Lower Leg";
                    popoverView.array = self.injuryArray;
                    popoverView.view.backgroundColor = [UIColor whiteColor];//mani
                    self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
                    self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
                    self.popover.popoverContentSize = CGSizeMake(350, 400);
                    popoverView.delegate = self;
                    CGRect frame = CGRectMake(self.location.x - 15, self.location.y - 200, 350, 400);
                    [self.popover presentPopoverFromRect:frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
                }
                else if ( (location.x > Male_BackLeftFoot_x1) && (location.x < Male_BackLeftFoot_x2) && (location.y>Male_BackLeftFoot_y1) && (location.y < Male_BackLeftFoot_y2) )
                {
                    if ([injuryArray count] < 1)
                    {
                        NSString* querySql = @"select InjuryID, 'InjuryType' , Type from InjuryType";
                        
                        @synchronized(g_SYNCLOOKUPDB)
                        {
                            self.injuryArray = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:querySql WithExtraInfo:NO];
                        }
                    }
                    PopupInjuryTypeViewController* popoverView =[[PopupInjuryTypeViewController alloc] initWithNibName:@"PopupInjuryTypeViewController" bundle:nil];
                    popoverView.area = @"Back Left Foot";
                    popoverView.array = self.injuryArray;
                    popoverView.view.backgroundColor = [UIColor whiteColor];//mani
                    self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
                    self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
                    self.popover.popoverContentSize = CGSizeMake(350, 400);
                    popoverView.delegate = self;
                    CGRect frame = CGRectMake(self.location.x - 15, self.location.y - 200, 350, 400);
                    [self.popover presentPopoverFromRect:frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
                }
                else if ( (location.x > Male_BackRightFoot_x1) && (location.x < Male_BackRightFoot_x2) && (location.y>Male_BackRightFoot_y1) && (location.y < Male_BackRightFoot_y2) )
                {
                    if ([injuryArray count] < 1)
                    {
                        NSString* querySql = @"select InjuryID, 'InjuryType' , Type from InjuryType";
                        
                        @synchronized(g_SYNCLOOKUPDB)
                        {
                            self.injuryArray = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:querySql WithExtraInfo:NO];
                        }
                    }
                    PopupInjuryTypeViewController* popoverView =[[PopupInjuryTypeViewController alloc] initWithNibName:@"PopupInjuryTypeViewController" bundle:nil];
                    popoverView.area = @"Back Right Foot";
                    popoverView.array = self.injuryArray;
                    popoverView.view.backgroundColor = [UIColor whiteColor];//mani
                    self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
                    self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
                    self.popover.popoverContentSize = CGSizeMake(350, 400);
                    popoverView.delegate = self;
                    CGRect frame = CGRectMake(self.location.x - 15, self.location.y - 200, 350, 400);
                    [self.popover presentPopoverFromRect:frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
                }
                
                else if ( (location.x > Male_BackLeftUpperArm_x1) && (location.x < Male_BackLeftUpperArm_x2) && (location.y>Male_BackLeftUpperArm_y1) && (location.y < Male_BackLeftUpperArm_y2) )
                {
                    if ([injuryArray count] < 1)
                    {
                        NSString* querySql = @"select InjuryID, 'InjuryType' , Type from InjuryType";
                        
                        @synchronized(g_SYNCLOOKUPDB)
                        {
                            self.injuryArray = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:querySql WithExtraInfo:NO];
                        }
                    }
                    PopupInjuryTypeViewController* popoverView =[[PopupInjuryTypeViewController alloc] initWithNibName:@"PopupInjuryTypeViewController" bundle:nil];
                    popoverView.area = @"Back Left Upper Arm";
                    popoverView.array = self.injuryArray;
                    popoverView.view.backgroundColor = [UIColor whiteColor];//mani
                    self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
                    self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
                    self.popover.popoverContentSize = CGSizeMake(350, 400);
                    popoverView.delegate = self;
                    CGRect frame = CGRectMake(self.location.x - 15, self.location.y - 200, 350, 400);
                    [self.popover presentPopoverFromRect:frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
                }
                
                else if ( (location.x > Male_BackLeftLowerArm_x1) && (location.x < Male_BackLeftLowerArm_x2) && (location.y>Male_BackLeftLowerArm_y1) && (location.y < Male_BackLeftLowerArm_y2) )
                {
                    if ([injuryArray count] < 1)
                    {
                        NSString* querySql = @"select InjuryID, 'InjuryType' , Type from InjuryType";
                        
                        @synchronized(g_SYNCLOOKUPDB)
                        {
                            self.injuryArray = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:querySql WithExtraInfo:NO];
                        }
                    }
                    PopupInjuryTypeViewController* popoverView =[[PopupInjuryTypeViewController alloc] initWithNibName:@"PopupInjuryTypeViewController" bundle:nil];
                    popoverView.area = @"Back Left Lower Arm";
                    popoverView.array = self.injuryArray;
                    popoverView.view.backgroundColor = [UIColor whiteColor];//mani
                    self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
                    self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
                    self.popover.popoverContentSize = CGSizeMake(350, 400);
                    popoverView.delegate = self;
                    CGRect frame = CGRectMake(self.location.x - 15, self.location.y - 200, 350, 400);
                    [self.popover presentPopoverFromRect:frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
                }
                else if ( (location.x > Male_BackLeftHand_x1) && (location.x < Male_BackLeftHand_x2) && (location.y>Male_BackLeftHand_y1) && (location.y < Male_BackLeftHand_y2) )
                {
                    if ([injuryArray count] < 1)
                    {
                        NSString* querySql = @"select InjuryID, 'InjuryType' , Type from InjuryType";
                        
                        @synchronized(g_SYNCLOOKUPDB)
                        {
                            self.injuryArray = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:querySql WithExtraInfo:NO];
                        }
                    }
                    PopupInjuryTypeViewController* popoverView =[[PopupInjuryTypeViewController alloc] initWithNibName:@"PopupInjuryTypeViewController" bundle:nil];
                    popoverView.area = @"Back Left Hand";
                    popoverView.array = self.injuryArray;
                    popoverView.view.backgroundColor = [UIColor whiteColor];//mani
                    self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
                    self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
                    self.popover.popoverContentSize = CGSizeMake(350, 400);
                    popoverView.delegate = self;
                    CGRect frame = CGRectMake(self.location.x - 15, self.location.y - 200, 350, 400);
                    [self.popover presentPopoverFromRect:frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
                }
                else if ( (location.x > Male_BackRightUpperArm_x1) && (location.x < Male_BackRightUpperArm_x2) && (location.y>Male_BackRightUpperArm_y1) && (location.y < Male_BackRightUpperArm_y2) )
                {
                    if ([injuryArray count] < 1)
                    {
                        NSString* querySql = @"select InjuryID, 'InjuryType' , Type from InjuryType";
                        
                        @synchronized(g_SYNCLOOKUPDB)
                        {
                            self.injuryArray = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:querySql WithExtraInfo:NO];
                        }
                    }
                    PopupInjuryTypeViewController* popoverView =[[PopupInjuryTypeViewController alloc] initWithNibName:@"PopupInjuryTypeViewController" bundle:nil];
                    popoverView.area = @"Back Right Upper Arm";
                    popoverView.array = self.injuryArray;
                    popoverView.view.backgroundColor = [UIColor whiteColor];//mani
                    self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
                    self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
                    self.popover.popoverContentSize = CGSizeMake(350, 400);
                    popoverView.delegate = self;
                    CGRect frame = CGRectMake(self.location.x - 15, self.location.y - 200, 350, 400);
                    [self.popover presentPopoverFromRect:frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
                }
                else if ( (location.x > Male_BackRightLowerArm_x1) && (location.x < Male_BackRightLowerArm_x2) && (location.y>Male_BackRightLowerArm_y1) && (location.y < Male_BackRightLowerArm_y2) )
                {
                    if ([injuryArray count] < 1)
                    {
                        NSString* querySql = @"select InjuryID, 'InjuryType' , Type from InjuryType";
                        
                        @synchronized(g_SYNCLOOKUPDB)
                        {
                            self.injuryArray = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:querySql WithExtraInfo:NO];
                        }
                    }
                    PopupInjuryTypeViewController* popoverView =[[PopupInjuryTypeViewController alloc] initWithNibName:@"PopupInjuryTypeViewController" bundle:nil];
                    popoverView.area = @"Back Right Lower Arm";
                    popoverView.array = self.injuryArray;
                    popoverView.view.backgroundColor = [UIColor whiteColor];//mani
                    self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
                    self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
                    self.popover.popoverContentSize = CGSizeMake(350, 400);
                    popoverView.delegate = self;
                    CGRect frame = CGRectMake(self.location.x - 15, self.location.y - 200, 350, 400);
                    [self.popover presentPopoverFromRect:frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
                }
                else if ( (location.x > Male_BackRightHand_x1) && (location.x < Male_BackRightHand_x2) && (location.y>Male_BackRightHand_y1) && (location.y < Male_BackRightHand_y2) )
                {
                    if ([injuryArray count] < 1)
                    {
                        NSString* querySql = @"select InjuryID, 'InjuryType' , Type from InjuryType";
                        
                        @synchronized(g_SYNCLOOKUPDB)
                        {
                            self.injuryArray = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:querySql WithExtraInfo:NO];
                        }
                    }
                    PopupInjuryTypeViewController* popoverView =[[PopupInjuryTypeViewController alloc] initWithNibName:@"PopupInjuryTypeViewController" bundle:nil];
                    popoverView.area = @"Back Right Hand";
                    popoverView.array = self.injuryArray;
                    popoverView.view.backgroundColor = [UIColor whiteColor];//mani
                    self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
                    self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
                    self.popover.popoverContentSize = CGSizeMake(350, 400);
                    popoverView.delegate = self;
                    CGRect frame = CGRectMake(self.location.x - 15, self.location.y - 200, 350, 400);
                    [self.popover presentPopoverFromRect:frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
                }
            } // end if front view
            
        }  // end else if male
        
    }
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewWillDisappear:(BOOL)animated
{
    
    if ([injurySelectedAll count] > 0 || frontImageTouch || needSave)
    {
        NSData* data0 = UIImageJPEGRepresentation(currentImage, 1.0f);
        NSString* imgStr0 = [Base64 encode:data0];
        NSData* data = UIImageJPEGRepresentation(currentImageDraw, 1.0f);
        NSString* imgStr = [Base64 encode:data];
        NSDate* sourceDate = [NSDate date];
        NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
        NSString* timeAdded = [dateFormat stringFromDate:sourceDate];
        NSString* sql;
        NSInteger count ;
        
        NSString* classification;
        if (ageSex == 1)
        {
            classification = @"Infant";
        }
        else if (ageSex == 2)
        {
            classification = @"Female";
        }
        else
        {
            classification = @"Male";
        }
        
        sql = [NSString stringWithFormat:@"Select count(*) from TicketAttachments where TicketID = %@ and AttachmentID = 1", ticketID ];
        @synchronized(g_SYNCBLOBSDB)
        {
            count = [DAO getCount:[[g_SETTINGS objectForKey:@"blobsDB"] pointerValue] Sql:sql];
        }
        if (count < 1)
        {
            sql = [NSString stringWithFormat:@"Insert into TicketAttachments(LocalTicketID, TicketID, AttachmentID, FileType, FileStr, FileName, TimeAdded) Values(0, %@, %d, 'BodyFront', '%@', '%@', '%@')", ticketID, 1, imgStr0, @" ", timeAdded ];
            @synchronized(g_SYNCBLOBSDB)
            {
                [DAO saveImage:[[g_SETTINGS objectForKey:@"blobsDB"] pointerValue] Sql:sql];
            }
            
            sql = [NSString stringWithFormat:@"Insert into TicketAttachments(LocalTicketID, TicketID, AttachmentID, FileType, FileStr, FileName, TimeAdded) Values(0, %@, %d, 'BodyFrontDrawing', '%@', '%@', '%@')", ticketID, 2, imgStr, @" ", timeAdded ];
            @synchronized(g_SYNCBLOBSDB)
            {
                [DAO saveImage:[[g_SETTINGS objectForKey:@"blobsDB"] pointerValue] Sql:sql];
            }
            
            sql = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue) Values(0, %@, %d, %d, %d, '%@', '%@', '%@')", ticketID, 9002, 0, 1, @"", @"", classification];
            @synchronized(g_SYNCDATADB)
            {
                [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sql];
            }
            sql = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue) Values(0, %@, %d, %d, %d, '%@', '%@', '%@')", ticketID, 9002, 0, 1, @"", @"", classification];
            @synchronized(g_SYNCDATADB)
            {
                [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sql];
            }
            
        }
        else
        {
            sql = [NSString stringWithFormat:@"Update TicketAttachments set FileStr = '%@', isUploaded = 0, Deleted = null where ticketID = %@ and AttachmentID = 1", imgStr0, ticketID];
            @synchronized(g_SYNCBLOBSDB)
            {
                [DAO saveImage:[[g_SETTINGS objectForKey:@"blobsDB"] pointerValue] Sql:sql];
            }
            
            sql = [NSString stringWithFormat:@"Update TicketAttachments set FileStr = '%@', isUploaded = 0, Deleted = null where ticketID = %@ and AttachmentID = 2", imgStr, ticketID];
            @synchronized(g_SYNCBLOBSDB)
            {
                [DAO saveImage:[[g_SETTINGS objectForKey:@"blobsDB"] pointerValue] Sql:sql];
            }
            sql = [NSString stringWithFormat:@"Update TicketInputs set InputValue = '%@', isUploaded = 0 where TicketID = %@ and InputID = 9002",classification, ticketID];
            @synchronized(g_SYNCDATADB)
            {
                [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sql];
            }
        }

    }
    if ([injurySelectedAll count] > 0 || backImageTouch || needSave)
    {
        NSData* data0 = UIImageJPEGRepresentation(currentImageBack, 1.0f);
        NSString* imgStr0 = [Base64 encode:data0];
        NSData* data = UIImageJPEGRepresentation(currentImageDrawBack, 1.0f);
        NSString* imgStr = [Base64 encode:data];

        NSDate* sourceDate = [NSDate date];
        NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"MM/dd/yyyy hh:mm:ss"];
        NSString* timeAdded = [dateFormat stringFromDate:sourceDate];
        NSString* sql;

        NSInteger count ;
        sql = [NSString stringWithFormat:@"Select count(*) from TicketAttachments where TicketID = %@ and AttachmentID = 3", ticketID ];
        
        @synchronized(g_SYNCBLOBSDB)
        {
            count = [DAO getCount:[[g_SETTINGS objectForKey:@"blobsDB"] pointerValue] Sql:sql];
        }
        if (count < 1)
        {
            sql = [NSString stringWithFormat:@"Insert into TicketAttachments(LocalTicketID, TicketID, AttachmentID, FileType, FileStr, FileName, TimeAdded) Values(0, %@, %d, 'BodyFront', '%@', '%@', '%@')", ticketID, 3, imgStr0, @" ", timeAdded ];
            @synchronized(g_SYNCBLOBSDB)
            {
                [DAO saveImage:[[g_SETTINGS objectForKey:@"blobsDB"] pointerValue] Sql:sql];
            }
            
            sql = [NSString stringWithFormat:@"Insert into TicketAttachments(LocalTicketID, TicketID, AttachmentID, FileType, FileStr, FileName, TimeAdded) Values(0, %@, %d, 'BodyFrontDrawing', '%@', '%@', '%@')", ticketID, 4, imgStr, @" ", timeAdded ];
            @synchronized(g_SYNCBLOBSDB)
            {
                [DAO saveImage:[[g_SETTINGS objectForKey:@"blobsDB"] pointerValue] Sql:sql];
            }
        }
        else
        {
            sql = [NSString stringWithFormat:@"Update TicketAttachments set FileStr = '%@', isUploaded = 0, Deleted = null where ticketID = %@ and AttachmentID = 3", imgStr0, ticketID];
            @synchronized(g_SYNCBLOBSDB)
            {
                [DAO saveImage:[[g_SETTINGS objectForKey:@"blobsDB"] pointerValue] Sql:sql];
            }
            
            sql = [NSString stringWithFormat:@"Update TicketAttachments set FileStr = '%@', isUploaded = 0, Deleted = null where ticketID = %@ and AttachmentID = 4", imgStr, ticketID];
            @synchronized(g_SYNCBLOBSDB)
            {
                [DAO saveImage:[[g_SETTINGS objectForKey:@"blobsDB"] pointerValue] Sql:sql];
            }
            
        }
        
    }

    if ([injurySelectedAll count] > 0 || needSave)
    {
        NSMutableString* injuryStr = [[NSMutableString alloc] init];
        for (int i= 0; i< [injurySelectedAll count]; i++)
        {
            ClsInjuryType* it = [injurySelectedAll objectAtIndex:i];
            NSString* viewType;
            if (it.front == 0)
            {
                viewType = @"F";
            }
            else
            {
                viewType = @"B";
            }
                
            [injuryStr appendString:[NSString stringWithFormat:@"%@: %@, %@, %.0f, %.0f, |", it.area, it.type, viewType, it.location.x, it.location.y]];
        }
        
        
        NSInteger count;
        NSString* sqlStr = [NSString stringWithFormat:@"Select count(*) from TicketInputs where TicketID = %@ and InputID = 9001", ticketID ];
        
        @synchronized(g_SYNCDATADB)
        {
            count = [DAO getCount:[[g_SETTINGS objectForKey:@"dataDB"]
                                   pointerValue] Sql:sqlStr];
        }
        if (count < 1)
        {
            sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue) Values(0, %@, %d, %d, %d, '%@', '%@', '%@')", ticketID, 9001, 0, 1, @"", @"", injuryStr];
            @synchronized(g_SYNCDATADB)
            {
                [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
                
            }
        }
        else
        {
            sqlStr = [NSString stringWithFormat:@"Update TicketInputs set InputValue = '%@' where TicketID = %@ and InputID = 9001",injuryStr, ticketID];
            @synchronized(g_SYNCDATADB)
            {
                [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            }
        }
        
    }
    [super viewWillDisappear:animated];
}


- (void)viewDidUnload {
    [self setImageView:nil];
    [self setTvInjury:nil];
    [super viewDidUnload];
}
- (IBAction)btnQueueClick:(id)sender {
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Quit" message:@"Are you sure you want to exit the application?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    alert.tag = 0;
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 0)
    {
        if (buttonIndex == 1)
        {
            exit(0);
        } else
        {
            
        }
    }
}

- (IBAction)btnMainMenuClick:(id)sender {
//    [self dismissViewControllerAnimated:YES completion:nil];
    [delegate dismissViewControl];
}

- (IBAction)btnFreeDrawingClick:(id)sender {
    if (isDrawing)
    {
        isDrawing = false;
        [btnFreeDrawing setTitle:@"Free Drawing" forState:UIControlStateNormal];
        btnClear.enabled = false;
    }
    else
    {
        isDrawing = true;
        [btnFreeDrawing setTitle:@"Select Injury" forState:UIControlStateNormal];
        btnClear.enabled = true;
    }
}

- (IBAction)btnClearClick:(id)sender {
    if (frontView)
    {
     //   UIImage* backgroundImage = [UIImage imageNamed:@"ChildFront_480x655.JPG"];
        frontImageTouch = false;
        UIImage* backgroundImage = defaultImage;
        self.currentImageDraw = defaultImage;
        CGSize size = CGSizeMake(479, 610);
        UIGraphicsBeginImageContext(size);
        [backgroundImage drawInRect:CGRectMake(0, 0, 479, 610)];
        for (int i = 0; i< [injurySelectedAll count]; i++)
        {
            ClsInjuryType* current = [injurySelectedAll objectAtIndex:i];
            if (current.front == 0)
            {
                UIImage* watermarkImage = [UIImage imageNamed:[NSString stringWithFormat:@"Mark%d.gif", i + 1]];
                ClsInjuryType* temp = [injurySelectedAll objectAtIndex:i];
                [watermarkImage drawInRect:CGRectMake(temp.location.x - 375, temp.location.y - 70, watermarkImage.size.width, watermarkImage.size.height)];
            }
            
        }
        UIImage* result = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        self.currentImage = result;
        [imageView setImage:currentImage];
        frontDraw = false;
    }
    else
    {
        backImageTouch = false;
        UIImage* backgroundImage = defaultImageBack;
        self.currentImageDrawBack = defaultImageBack;
        CGSize size = CGSizeMake(479, 610);
        UIGraphicsBeginImageContext(size);
        [backgroundImage drawInRect:CGRectMake(0, 0, 479, 610)];
        for (int i = 0; i< [injurySelectedAll count]; i++)
        {
            ClsInjuryType* current = [injurySelectedAll objectAtIndex:i];
            if (current.front == 1)
            {
                UIImage* watermarkImage = [UIImage imageNamed:[NSString stringWithFormat:@"Mark%d.gif", i + 1]];
                ClsInjuryType* temp = [injurySelectedAll objectAtIndex:i];
                [watermarkImage drawInRect:CGRectMake(temp.location.x - 375, temp.location.y - 70, watermarkImage.size.width, watermarkImage.size.height)];
            }
            
        }
        UIImage* result = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        self.currentImageBack = result;
        [imageView setImage:currentImageBack];
        backDraw = false;
    }
}

- (IBAction)btnInternalInjuries:(id)sender {
    if (frontView)
    {
        ClsInjuryType* selected = [[ClsInjuryType alloc] init];
        selected.type = @"Suspected Internal Injuries";
        selected.location = CGPointZero;
        selected.area = @"Internal";
        selected.front = 2;
        bool found = false;
        for (int i = 0; i< [injurySelectedAll count]; i++)
        {
            ClsInjuryType* injury = [injurySelectedAll objectAtIndex:i];
            if ([@"Suspected Internal Injuries" isEqualToString:injury.type])
            {
                found = true;
            }
        }
        if (!found)
        {
            //[injurySelected addObject:selected];
            [injurySelectedAll addObject:selected];
            [tvInjury reloadData];
        }
    }
    else
    {
        ClsInjuryType* selected = [[ClsInjuryType alloc] init];
        selected.type = @"Suspected Internal Injuries";
        selected.location = CGPointZero;
        selected.area = @"Internal";
        selected.front = 2;
        bool found = false;
        for (int i = 0; i< [injurySelectedAll count]; i++)
        {
            ClsInjuryType* injury = [injurySelectedAll objectAtIndex:i];
            if ([@"Suspected Internal Injuries" isEqualToString:injury.type])
            {
                found = true;
            }
        }
        if (!found)
        {
                [injurySelectedBack addObject:selected];
                [injurySelectedAll addObject:selected];
                [tvInjury reloadData];
        }
    }
}

- (IBAction)btnTraumaClick:(id)sender {
    if (frontView)
    {
        ClsInjuryType* selected = [[ClsInjuryType alloc] init];
        selected.type = @"No Obvious Trauma";
        selected.location = CGPointZero;
        selected.area = @"External";
        selected.front = 3;
        bool found = false;
        for (int i = 0; i< [injurySelectedAll count]; i++)
        {
            ClsInjuryType* injury = [injurySelectedAll objectAtIndex:i];
            if ([@"No Obvious Trauma" isEqualToString:injury.type])
            {
                found = true;
            }
        }
        if (!found)
        {
            [injurySelectedAll addObject:selected];
            [tvInjury reloadData];
        }
    }
    else
    {
        ClsInjuryType* selected = [[ClsInjuryType alloc] init];
        selected.type = @"No Obvious Trauma";
        selected.location = CGPointZero;
        selected.area = @"External";
        selected.front = 3;
        bool found = false;
        for (int i = 0; i< [injurySelectedAll count]; i++)
        {
            ClsInjuryType* injury = [injurySelectedAll objectAtIndex:i];
            if ([@"No Obvious Trauma" isEqualToString:injury.type])
            {
                found = true;
            }
        }
        if (!found)
        {
            [injurySelectedAll addObject:selected];
            [tvInjury reloadData];
        }
    }
    
}

- (IBAction)btnRemoveInjuryClick:(id)sender {
    if (rowSelected < 0)
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Select Treatment" message:@"Please select a treatment entry below before continuing." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    else
    {
        needSave = true;
        if (frontView)
        {
            [injurySelectedAll removeObjectAtIndex:rowSelected];
            UIImage* backgroundImage;
            if (frontDraw)
            {
                backgroundImage = currentImageDraw;
            }
            else
            {
              //  backgroundImage = [UIImage imageNamed:@"ChildFront_480x655.JPG"];
                backgroundImage = defaultImage;
            }

            CGSize size = CGSizeMake(479, 610);
            UIGraphicsBeginImageContext(size);
            [backgroundImage drawInRect:CGRectMake(0, 0, 479, 610)];
            for (int i = 0; i< [injurySelectedAll count]; i++)
            {
                ClsInjuryType* current = [injurySelectedAll objectAtIndex:i];
                if (current.front == 0)
                {
                    UIImage* watermarkImage = [UIImage imageNamed:[NSString stringWithFormat:@"Mark%d.gif", i + 1]];
                    ClsInjuryType* temp = [injurySelectedAll objectAtIndex:i];
                    [watermarkImage drawInRect:CGRectMake(temp.location.x - 375, temp.location.y - 70, watermarkImage.size.width, watermarkImage.size.height)];
                }
            }
            UIImage* result = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            self.currentImage = result;
            [imageView setImage:currentImage];
        }
        else
        {
            [injurySelectedAll removeObjectAtIndex:rowSelected];
            UIImage* backgroundImage;
            if (frontDraw)
            {
                backgroundImage = currentImageDrawBack;
            }
            else
            {
             //   backgroundImage = [UIImage imageNamed:@"ChildBack.JPG"];
                backgroundImage = defaultImageBack;
            }
            CGSize size = CGSizeMake(479, 610);
            UIGraphicsBeginImageContext(size);
            [backgroundImage drawInRect:CGRectMake(0, 0, 479, 610)];
            for (int i = 0; i< [injurySelectedAll count]; i++)
            {
                ClsInjuryType* current = [injurySelectedAll objectAtIndex:i];
                if (current.front == 1)
                {
                    UIImage* watermarkImage = [UIImage imageNamed:[NSString stringWithFormat:@"Mark%d.gif", i + 1]];
                    ClsInjuryType* temp = [injurySelectedAll objectAtIndex:i];
                    [watermarkImage drawInRect:CGRectMake(temp.location.x - 375, temp.location.y - 70, watermarkImage.size.width, watermarkImage.size.height)];
                }
            }
            UIImage* result = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            self.currentImageBack = result;
            [imageView setImage:currentImageBack];
        }
        rowSelected = -1;
        [tvInjury reloadData];
    }
}

- (IBAction)btnShowBackClick:(id)sender {
    if (frontView)
    {
        frontView = false;
        [btnShowBack setTitle:@"Show Front" forState:UIControlStateNormal];
        [self loadBackView];
    }
    else
    {
        frontView = true;
        [btnShowBack setTitle:@"Show Back" forState:UIControlStateNormal];
        [self loadFrontView];
    }
    [tvInjury reloadData];
}

- (IBAction)btnValidateClick:(UIButton*)sender {
    //[self saveTab];
    ValidateViewController *popoverView =[[ValidateViewController alloc] initWithNibName:@"ValidateViewController" bundle:nil];
    
    self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
    self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
    self.popover.popoverContentSize = CGSizeMake(540, 590);
    popoverView.delegate = self;
    
    [self.popover presentPopoverFromRect:sender.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (void) doneSelectValidate
{
    ValidateViewController *p = (ValidateViewController *)self.popover.contentViewController;
    
    [self.popover dismissPopoverAnimated:YES];
    self.popover = nil;
    if (p.ticketComplete)
    {
        [delegate dismissViewControl];
    }
    
    else if (p.tagID >= 0)
    {
        [self.delegate dismissViewControlAndStartNew:p.tagID];
    }
}



-(void) loadBackView
{
    UIImage* backgroundImage = currentImageDrawBack;
    CGSize size = CGSizeMake(479, 610);
    UIGraphicsBeginImageContext(size);
    [backgroundImage drawInRect:CGRectMake(0, 0, 479, 610)];
    for (int i = 0; i< [injurySelectedAll count]; i++)
    {
        ClsInjuryType* current = [injurySelectedAll objectAtIndex:i];
        if (current.front == 1)
        {
            UIImage* watermarkImage = [UIImage imageNamed:[NSString stringWithFormat:@"Mark%d.gif", i + 1]];
            ClsInjuryType* temp = [injurySelectedAll objectAtIndex:i];
            [watermarkImage drawInRect:CGRectMake(temp.location.x - 375, temp.location.y - 70, watermarkImage.size.width, watermarkImage.size.height)];
        }
        
    }
    UIImage* result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.currentImageBack = result;
    [imageView setImage:currentImageBack];
}

-(void) loadFrontView
{
    UIImage* backgroundImage = currentImageDraw;
    CGSize size = CGSizeMake(479, 610);
    UIGraphicsBeginImageContext(size);
    [backgroundImage drawInRect:CGRectMake(0, 0, 479, 610)];
    for (int i = 0; i< [injurySelectedAll count]; i++)
    {
        ClsInjuryType* current = [injurySelectedAll objectAtIndex:i];
        if (current.front == 0)
        {
            UIImage* watermarkImage = [UIImage imageNamed:[NSString stringWithFormat:@"Mark%d.gif", i + 1]];
            ClsInjuryType* temp = [injurySelectedAll objectAtIndex:i];
            [watermarkImage drawInRect:CGRectMake(temp.location.x - 375, temp.location.y - 70, watermarkImage.size.width, watermarkImage.size.height)];
        }
        
    }
    UIImage* result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.currentImage = result;
    [imageView setImage:currentImage];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (frontView)
    {
        return [injurySelectedAll count];
    }
    else
    {
        return [injurySelectedAll count];
    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        static NSString *CellIdentifier = @"Cell";
        InjuryCell *cell = (InjuryCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"InjuryCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        if (frontView)
        {
            ClsInjuryType* type = [injurySelectedAll objectAtIndex:indexPath.row];
            UIImage* image = [UIImage imageNamed:[NSString stringWithFormat:@"Mark%d.gif", indexPath.row + 1]];
            cell.image.image = image;
            cell.label.text = [NSString stringWithFormat:@"%@: %@", type.area, type.type];
        }
        else
        {
            ClsInjuryType* type = [injurySelectedAll objectAtIndex:indexPath.row];
            UIImage* image = [UIImage imageNamed:[NSString stringWithFormat:@"Mark%d.gif", indexPath.row + 1]];
            cell.image.image = image;
            cell.label.text = [NSString stringWithFormat:@"%@: %@", type.area, type.type];
        }
        return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
    
    //UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    rowSelected = indexPath.row;
}

#pragma mark- UI controls adjustments
-(void) setViewUI
{
    // toolBar background image
    UIImage *toolBarIMG = [UIImage imageNamed:NSLocalizedString(@"IMG_BG_NAVIGATIONBAR", nil)];
    [self.toolBar setBackgroundImage:toolBarIMG forToolbarPosition:0 barMetrics:0];
    toolBarIMG = nil;
    
}

- (IBAction)btnQuickClick:(UIButton*)sender {
    QuickViewController *popoverView =[[QuickViewController alloc] initWithNibName:@"QuickViewController" bundle:nil];
    self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
    self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];
    self.popover.popoverContentSize = CGSizeMake(540, 580);
    popoverView.delegate = self;
    
    [self.popover presentPopoverFromRect:sender.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    
}

- (void) doneQuickButton
{
    [self.popover dismissPopoverAnimated:YES];
    self.popover = nil;
}

- (IBAction)btnQAMessageClick:(UIButton *)sender {
    
    NSString* sql = [NSString stringWithFormat:@"Select ticketAdminNotes from Tickets where TicketID = %@", ticketID ];
    NSString* notes;
    @synchronized(g_SYNCDATADB)
    {
        notes = [DAO executeSelectScalar:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sql];
    }
    
    QAMessageViewController* popoverView = [[QAMessageViewController alloc] initWithNibName:@"QAMessageViewController" bundle:nil];
    popoverView.view.backgroundColor = [UIColor whiteColor];
    popoverView.adminNotes = notes;
    popoverView.ticketID = [ticketID intValue];
    self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
    self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
    
    if (notes.length > 1)
    {
            self.popover.popoverContentSize = CGSizeMake(502, 455);
    }
    else
    {
        self.popover.popoverContentSize = CGSizeMake(502, 355);
    }
    CGRect rect = CGRectMake(sender.frame.origin.x, sender.frame.origin.y + 16, sender.frame.size.width, sender.frame.size.height);
    [self.popover presentPopoverFromRect:rect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    
}
@end
