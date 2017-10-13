//
//  NSDictionary+Extension.swift
//  iFreshF
//
//  Created by Jion on 16/4/12.
//  Copyright © 2016年 Youjuke. All rights reserved.
//

import Foundation

extension Dictionary {
    ///  将字典合并到当前字典
    mutating func merge<K, V>(dict: [K: V]) {
        for (k, v) in dict {
            self.updateValue(v as! Value, forKey: k as! Key)
        }
    }
}