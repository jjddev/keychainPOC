import UIKit
import Security

class CreateAccountViewController: UIViewController {
    
    let mainView: CreateAccountView
    let navigation: UINavigationController
    
    init(navigation: UINavigationController) {
        self.navigation = navigation
        mainView = CreateAccountView(navigation: navigation)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = mainView
        title = "Criar Chave"
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
    

    

}

