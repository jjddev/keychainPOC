import Foundation
import LocalAuthentication

final class KeychainHelper {
    
    static func save(key: String, value: String) -> KeychainHelperError? {
        let access = SecAccessControlCreateWithFlags(nil, kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly, .userPresence, nil)
        
        let attributes: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                         kSecAttrAccessControl as String: access as Any,
                                         kSecAttrAccount as String: key,
                                         kSecValueData as String: value.data(using: .utf8) as Any,
                                         kSecUseAuthenticationContext as String: LAContext()]
        
        let status = SecItemAdd(attributes as CFDictionary, nil)
        if status == noErr {
            print("saved")
            return nil
        } else {
            print("error")
            return KeychainHelperError(status: status)
        }
    }
    
    static func fetch(query: [String: Any]) -> (String, String)? {
        var item: CFTypeRef?
        
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        
        if status == noErr {
            if let existingItem = item as? [String: Any],
               let key = existingItem[kSecAttrAccount as String] as? String,
               let passwordData = existingItem[kSecValueData as String] as? Data,
               let password = String(data: passwordData, encoding: .utf8) {
                print("key: \(key)")
                print("password: \(password)")
                
                return (key, password)
            }
            
        } else {
            print("error")
            let error = KeychainHelperError(status: status)
            print(error.localizedDescription)
            return nil
        }
        
        return nil
    }
    
    static func delete(key: String) -> KeychainHelperError? {
        let attributes: [String : Any] = [kSecClass as String: kSecClassGenericPassword as String,
                                          kSecAttrAccount as String: key]
        
        let status = SecItemDelete(attributes as CFDictionary)
        
        return status == noErr ? nil : KeychainHelperError(status: status)
    }
    
    static func deleteAll() -> KeychainHelperError? {
        let attributes: [String: Any] = [kSecClass as String: kSecClassGenericPassword]
        let status = SecItemDelete(attributes as CFDictionary)
        return status == noErr ? nil : KeychainHelperError(status: status)
    }
    
    static func buildSaveQuery(key: String, value: String, access: SecAccessControl?, authenticationContext: Bool = false) -> [String: Any] {
        var attributes: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: value.data(using: .utf8) as Any
        ]

        
        if access != nil {
            attributes[kSecAttrAccessControl as String] = access as Any
        }
        
        if authenticationContext {
            attributes[kSecUseAuthenticationContext as String] = LAContext()
        }

        return attributes
    }
    
    static func buildFetchQuery(key: String) -> [String: Any] {
        return [kSecClass as String: kSecClassGenericPassword,
                kSecAttrAccount as String: key,
                kSecMatchLimit as String: kSecMatchLimitOne,
                kSecReturnAttributes as String: true,
                kSecReturnData as String: true,
                kSecUseAuthenticationContext as String: LAContext()]
    }
}

struct KeychainHelperError: Error {
    let status: OSStatus

    var localizedDescription: String {
        return SecCopyErrorMessageString(status, nil) as String? ?? "Unknown error."
    }
}

struct KeychainData {
    let key: String
    let value: String
    var statusDescription: String
    let status: OSStatus
}
