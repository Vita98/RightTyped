//
//  QRCodeHelper.swift
//  RightTyped
//
//  Created by Vitandrea Sorino on 05/11/23.
//

import Foundation
import UIKit
import AVFoundation

class QRCodeHelper {
    
    private init(){}
    
    //MARK: Compression
    private static func compress(_ data: Data) -> Data? {
        do {
            return try (data as NSData).compressed(using: .zlib) as Data
        } catch _ { return nil }
    }
    
    private static func decompress(_ data: Data) -> Data? {
        do {
            return try (data as NSData).decompressed(using: .zlib) as Data
        } catch _ { return nil }
    }
    
    //MARK: QRCode generator
    static func qrCodeData(_ obj: QRCodable) -> Data? {
        guard let data = obj.jsonEncode() else { return nil }
        return compress(data)
    }
    
    static func generateQRCode(from obj: QRCodable) async -> UIImage? {
        guard let data = qrCodeData(obj) else { return nil }
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 3, y: 3)
            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }
        return nil
    }
    
    static func readQRCode(_ stringValue: String) -> Serializable? {
        guard let data = stringValue.data(using: .utf8) else { return nil }
        for poss in objectPossibilities{
            do {
                let c = try poss.init(from: JSONDecoder().decode(poss, from: data) as! Decoder)
                return c
            } catch _ { continue }
        }
        return nil
    }
}
