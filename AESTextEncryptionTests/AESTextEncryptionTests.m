//
//  AESTextEncryptionTests.m
//  AESTextEncryptionTests
//
//  Created by Evgenii Neumerzhitckii on 5/11/2013.
//  Copyright (c) 2013 Evgenii Neumerzhitckii. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "AESEncryptor.h"

@interface AESTextEncryptionTests : XCTestCase

@property (strong, nonatomic) AESEncryptor* encryptor;

@end

@implementation AESTextEncryptionTests

- (void)setUp
{
    [super setUp];
    self.encryptor = [[AESEncryptor alloc] init];
}

- (void)testEncryptEndDecryptMessage
{
    NSString *encryptedText = [self.encryptor encrypt:@"My message" withKey:@"my key"];
    XCTAssertFalse([@"My message" isEqualToString:encryptedText]);

    NSString *decryptedText = [self.encryptor decrypt:encryptedText withKey:@"my key"];
    XCTAssertTrue([@"My message" isEqualToString:decryptedText]);
}

- (void)testEncryptionRemovesWhitespacesAndNewlines
{
    NSString *encryptedText = [self.encryptor encrypt:@" \nmy Text \r\n" withKey:@"  paSS \n"];
    XCTAssertFalse([@"my Text" isEqualToString:encryptedText]);

    NSString *decryptedText = [self.encryptor decrypt:encryptedText withKey:@"\n paSS \r\n"];
    XCTAssertTrue([@"my Text" isEqualToString:decryptedText]);
}

// Decryption test. Checks compatibility with openssl.
// Message was encrypted with following command:
// echo 'My Test Message' | openssl enc -aes-256-cbc -pass pass:"Secret Passphrase" -e -base64
- (void)testDecrypt
{
    NSString *encryptedText = @"U2FsdGVkX19QoG20T57G9tsv8Vn9VelURHMt+ArpDA878DjrFhtpUgJFn6CyycGi";
    NSString *decryptedText = [self.encryptor decrypt:encryptedText withKey:@"Secret Passphrase"];

    XCTAssertTrue([@"My Test Message 日本" isEqualToString:decryptedText]);
}



@end
