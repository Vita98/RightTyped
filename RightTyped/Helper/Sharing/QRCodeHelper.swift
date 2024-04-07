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
        } catch let error {
            #if DEBUG
            print(error.localizedDescription)
            #endif
            return nil
        }
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
            let transform = CGAffineTransform(scaleX: 5, y: 5)
            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }
        return nil
    }
    
    //MARK: QRCode reader
    static func readQRCode<T: Serializable>(data: Data, type: T.Type) -> T? {
        if let decompressedData = decompress(data) {
            return try? JSONDecoder().decode(T.self, from: decompressedData)
        }
        return nil
    }
    
    static func readQRCode(_ data: Data) -> Serializable? {
        guard let dataDecompressed = decompress(data) else { return nil }
        for poss in objectPossibilities{
            if let c = poss.jsonDecode(dataDecompressed) {
                return c
            }
        }
        return nil
    }
}
