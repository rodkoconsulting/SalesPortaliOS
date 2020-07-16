//
//  GBApplicationStringsProvider.m
//  appledoc
//
//  Created by Tomaz Kragelj on 1.10.10.
//  Copyright (C) 2010, Gentle Bytes. All rights reserved.
//

#import "GBApplicationStringsProvider.h"

@implementation GBApplicationStringsProvider

#pragma mark Initialization & disposal

+ (id)provider {
	return [[self alloc] init];
}

#pragma mark Object output strings

- (NSDictionary *)objectPage {
	static NSMutableDictionary *result = nil;
	if (!result) {
		result = [[NSMutableDictionary alloc] init];
		result[@"classTitle"] = @"%@ クラス リファレンス";
		result[@"categoryTitle"] = @"%1$@(%2$@) カテゴリ リファレンス";
		result[@"protocolTitle"] = @"%@ プロトコル リファレンス";
		result[@"constantTitle"] = @"%@ 定数 リファレンス";
        result[@"blockTitle"] = @"%@ ブロック リファレンス";
		result[@"mergedCategorySectionTitle"] = @"%@ メソッド";
		result[@"mergedExtensionSectionTitle"] = @"拡張メソッド";
		result[@"mergedPrefixedCategorySectionTitle"] = @"%2$@ から %1$@";
	}
	return result;
}

- (NSDictionary *)objectSpecifications {
	static NSMutableDictionary *result = nil;
	if (!result) {
		result = [[NSMutableDictionary alloc] init];
		result[@"inheritsFrom"] = @"継承元";
		result[@"conformsTo"] = @"参照先";
        result[@"references"] = @"リファレンス";
        result[@"availability"] = @"可用性";
		result[@"declaredIn"] = @"定義先";
		result[@"companionGuide"] = @"関連ガイド";
	}
	return result;
}

- (NSDictionary *)objectOverview {
	static NSMutableDictionary *result = nil;
	if (!result) {
		result = [[NSMutableDictionary alloc] init];
		result[@"title"] = @"概要";
	}
	return result;
}

- (NSDictionary *)objectTasks {
	static NSMutableDictionary *result = nil;
	if (!result) {
		result = [[NSMutableDictionary alloc] init];
		result[@"title"] = @"タスク";
		result[@"otherMethodsSectionName"] = @"その他 メソッド";
		result[@"requiredMethod"] = @"実装必須 メソッド";
		result[@"property"] = @"プロパティ";
	}
	return result;
}

- (NSDictionary *)objectMethods {
	static NSMutableDictionary *result = nil;
	if (!result) {
		result = [[NSMutableDictionary alloc] init];
		result[@"classMethodsTitle"] = @"クラス メソッド";
		result[@"instanceMethodsTitle"] = @"インスタンス メソッド";
        result[@"blockDefTitle"] = @"ブロック 定義";
		result[@"propertiesTitle"] = @"プロパティ";
		result[@"parametersTitle"] = @"パラメータ";
		result[@"resultTitle"] = @"戻り値";
		result[@"availability"] = @"可用性";
		result[@"discussionTitle"] = @"内容";
		result[@"exceptionsTitle"] = @"例外";
		result[@"seeAlsoTitle"] = @"関連項目";
		result[@"declaredInTitle"] = @"定義先";
	}
	return result;
}

#pragma mark Document output strings

- (NSDictionary *)documentPage {
	static NSMutableDictionary *result = nil;
	if (!result) {
		result = [[NSMutableDictionary alloc] init];
		result[@"titleTemplate"] = @"%@ ドキュメント";
	}
	return result;
}

#pragma mark Index output strings

- (NSDictionary *)indexPage {
	static NSMutableDictionary *result = nil;
	if (!result) {
		result = [[NSMutableDictionary alloc] init];
		result[@"titleTemplate"] = @"%@ リファレンス";
		result[@"docsTitle"] = @"プログラミングガイド";
		result[@"classesTitle"] = @"クラス リファレンス";
		result[@"categoriesTitle"] = @"カテゴリ リファレンス";
		result[@"protocolsTitle"] = @"プロトコル リファレンス";
        result[@"constantsTitle"] = @"定数 リファレンス";
        result[@"blocksTitle"] = @"ブロック リファレンス";
	}
	return result;
}

- (NSDictionary *)hierarchyPage {
	static NSMutableDictionary *result = nil;
	if (!result) {
		result = [[NSMutableDictionary alloc] init];
		result[@"titleTemplate"] = @"%@ 階層";
		result[@"classesTitle"] = @"クラス階層";
		result[@"categoriesTitle"] = @"カテゴリ リファレンス";
		result[@"protocolsTitle"] = @"プロトコル リファレンス";
        result[@"constantsTitle"] = @"定数 リファレンス";
        result[@"blocksTitle"] = @"ブロック リファレンス";
	}
	return result;
}

#pragma mark Documentation set output strings

- (NSDictionary *)docset {
	static NSMutableDictionary *result = nil;
	if (!result) {
		result = [[NSMutableDictionary alloc] init];
		result[@"docsTitle"] = @"プログラミングガイド";
		result[@"classesTitle"] = @"クラス";
		result[@"categoriesTitle"] = @"カテゴリー";
		result[@"protocolsTitle"] = @"プロトコル";
        result[@"constantsTitle"] = @"定数";
        result[@"blocksTitle"] = @"ブロック";
	}
	return result;
}

- (NSDictionary *)appledocData {
	static NSMutableDictionary *result = nil;
	if (!result) {
		result = [[NSMutableDictionary alloc] init];
		result[@"tool"] = @"appledoc";
		result[@"version"] = @"2.2.1";
		result[@"build"] = @"1334";
		result[@"homepage"] = @"http://appledoc.gentlebytes.com";
	}
	return result;
}

@end