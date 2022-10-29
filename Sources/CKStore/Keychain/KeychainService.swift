//
//  KeychainService.swift
//  CKStore
//
//  Created by Charles on 2022/6/11.
//

import Foundation

public final class KeychainService {
    
    public enum KeychainServiceError: Error {
        case unknown
    }
    
    public static func saveSecretObject<Input: Codable>(
        secret: Input,
        for account: String,
        on server: String? = nil,
        by application: String? = nil
    ) throws {
        let jsonEncoder = JSONEncoder()
        let credentialData = try jsonEncoder.encode(secret)
    
        if let _: Input = retriveSecretObject(for: account, on: server) {
            var query: [String: Any] = [
                kSecClass as String: kSecClassInternetPassword,
                kSecAttrAccount as String: account
            ]
            
            if let server = server {
                query[kSecAttrServer as String] = server
            }
            
            if let application = application {
                query[kSecAttrApplicationTag as String] = application
            }
            
            let attributes: [String: Any] = [
                kSecValueRef as String: credentialData
            ]
            
            
            let status = SecItemUpdate(query as CFDictionary, attributes as CFDictionary)
            guard status != errSecItemNotFound else {
                throw KeychainServiceError.unknown
            }
            guard status == errSecSuccess else {
                throw KeychainServiceError.unknown
            }
        } else {
            var query: [String: Any] = [
                kSecClass as String: kSecClassInternetPassword,
                kSecAttrAccount as String: account,
                kSecValueData as String: credentialData
            ]
            
            if let server = server {
                query[kSecAttrServer as String] = server
            }
            
            if let application = application {
                query[kSecAttrApplicationTag as String] = application
            }
            
            let status = SecItemAdd(query as CFDictionary, nil)
            guard status == errSecSuccess else {
                throw KeychainServiceError.unknown
            }
        }
    }
    
    public static func retriveSecretObject<Output: Codable>(
        for account: String,
        on server: String?,
        by application: String? = nil
    ) -> Output? {
        var query: [String: Any] = [
            kSecClass as String: kSecClassInternetPassword,
            kSecAttrAccount as String: account,
            kSecMatchLimit as String: kSecMatchLimitOne,
            kSecReturnData as String: kCFBooleanTrue!
        ]
        
        if let server = server {
            query[kSecAttrServer as String] = server
        }
        
        if let application = application {
            query[kSecAttrApplicationTag as String] = application
        }
    
        var retrivedData: AnyObject? = nil
        let _ = SecItemCopyMatching(query as CFDictionary, &retrivedData)
            
        guard let data = retrivedData as? Data else {
            return nil
        }
        let jsonDecoder = JSONDecoder()
        return try? jsonDecoder.decode(Output.self, from: data)
    }
    
}
