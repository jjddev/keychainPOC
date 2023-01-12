import UIKit
import Security

final class HomeViewController: UIViewController {
    
    var homeView: HomeView?
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        homeView = HomeView(navigation: navigationController ?? UINavigationController())
        view = homeView
        title = ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

    
    func createEntry(key: String, secret: String) {
        let attributes: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: secret
        ]
        
        if SecItemAdd(attributes as CFDictionary, nil) == noErr {
            print("saved")
        } else {
            print("error")
        }
    }
    
    func searchItem(key: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecMatchLimit as String: kSecMatchLimitOne,
            kSecReturnAttributes as String: true,
            kSecReturnData as String: true
        ]
        
        var item: CFTypeRef?
        
        if SecItemCopyMatching(query as CFDictionary, &item) == noErr {
            if let existingItem = item as? [String: Any],
               let key = existingItem[kSecAttrAccount as String] as? String,
               let passwordData = existingItem[kSecValueData as String] as? Data,
               let password = String(data: passwordData, encoding: .utf8) {
                print("key: \(key)")
                print("password: \(password)")
            }
            
        } else {
            print("error")
        }
    }
}

