//
//  CCSettings.swift
//  JGFLabRoom
//
//  Created by Josep González on 22/1/16.
//  Copyright © 2016 Josep Gonzalez Fernandez. All rights reserved.
//

import Foundation

enum CCSettings {
    case CCAlgorithm, CCOption, CCKeySize, CCBlockSize, CCContextSize
    static let types: [CCSettings] = [.CCAlgorithm, .CCOption, .CCKeySize, .CCBlockSize, .CCContextSize]
    static let titles: [String] = ["CCAlgorithm", "CCOption", "CCKeySize", "CCBlockSize", "CCContextSize"]
    
    static func getTitle(type: CCSettings) -> String {
        return CCSettings.titles[type.hashValue]
    }
    
    static func getTitlesArray(settingsType: CCSettings) -> [String] {
        switch settingsType {
        case .CCAlgorithm:
            return ["AES 128",
                "AES",
                "DES",
                "3DES",
                "CAST",
                "RC4",
                "RC2",
                "Blowfish"]
        case .CCBlockSize:
            return ["AES 128",
                "DES",
                "3DES",
                "CAST",
                "RC2",
                "Blowfish"]
        case .CCContextSize:
            return ["AES 128",
                "DES",
                "3DES",
                "CAST",
                "RC4"]
        case .CCKeySize:
            return ["AES 128",
                "AES 192",
                "AE S256",
                "DES",
                "3DES",
                "Min CAST",
                "Max CAST",
                "Min RC4",
                "Max RC4",
                "Min RC2",
                "Max RC2",
                "Min Blowfish",
                "Max Blowfish"]
        case .CCOption:
            return ["PKCS7 Padding",
                "ECB Mode",
                "PKCS7 Padding + ECB Mode"]
        }
    }
    
    static func getValuesArray(settingsType: CCSettings) -> [Int] {
        switch settingsType {
        case .CCAlgorithm:
            return [kCCAlgorithmAES128,
                kCCAlgorithmAES,
                kCCAlgorithmDES,
                kCCAlgorithm3DES,
                kCCAlgorithmCAST,
                kCCAlgorithmRC4,
                kCCAlgorithmRC2,   
                kCCAlgorithmBlowfish]
        case .CCBlockSize:
            return [kCCBlockSizeAES128,
                kCCBlockSizeDES,
                kCCBlockSize3DES,
                kCCBlockSizeCAST,
                kCCBlockSizeRC2,
                kCCBlockSizeBlowfish]
        case .CCContextSize:
            return [kCCContextSizeAES128,
                kCCContextSizeDES,
                kCCContextSize3DES,
                kCCContextSizeCAST,
                kCCContextSizeRC4]
        case .CCKeySize:
            return [kCCKeySizeAES128,
                kCCKeySizeAES192,
                kCCKeySizeAES256,
                kCCKeySizeDES,
                kCCKeySize3DES,
                kCCKeySizeMinCAST,
                kCCKeySizeMaxCAST,
                kCCKeySizeMinRC4,
                kCCKeySizeMaxRC4,
                kCCKeySizeMinRC2,
                kCCKeySizeMaxRC2,
                kCCKeySizeMinBlowfish,
                kCCKeySizeMaxBlowfish]
        case .CCOption:
            return [kCCOptionPKCS7Padding,
                kCCOptionECBMode,
                kCCOptionPKCS7Padding + kCCOptionECBMode]
        }
    }
}