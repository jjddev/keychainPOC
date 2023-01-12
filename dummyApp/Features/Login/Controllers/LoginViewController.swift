import UIKit
import Security
import LocalAuthentication


class LoginViewController: UIViewController {
    
    let mainView: LoginView
    let navigation: UINavigationController
    let context = LAContext()
    var biometryType: String = ""
    
    init(navigation: UINavigationController) {
        self.navigation = navigation
        mainView = LoginView(navigation: navigation)
        super.init(nibName: nil, bundle: nil)
        checkForBiometric()
        validedBiometry()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = mainView
        title = "Login"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

    func checkForBiometric() {
        var error: NSError?
        let permissions = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
        
        switch context.biometryType {
        case .none:
            biometryType = "Nenhuma disponível"
        case .touchID:
            biometryType = "TouchID"
        case .faceID:
            biometryType = "FaceID"
        default:
            biometryType = "Deconhecido"
            
        }
        
        print("permission: \(permissions)")
        print("biometry: \(biometryType)")
        
        
        
        let message: String
        if permissions {
            message = ">> Touch ID disponível"
        } else {
            message = ">> Touch ID não disponível"
        }
        
        setStatus(status: permissions, message: message)
    }
    
    func validedBiometry() {
        
        
        let loginAction: (() -> Void)? = { [weak self]  in
            self?.context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: "Log in with Touch ID") { [self] success, error in
                if success {
                    DispatchQueue.main.async {
                        
                        if let data = self?.searchEntry(key: self?.mainView.keyTextField.text ?? "") {
                            self?.navigation.pushViewController(SecretViewController(user: data.0, password: data.1, biometryType: self?.biometryType ?? ""), animated: true)
                        } else {
                            print("chave não encontrada")
                        }
                        
                        
                        
                    }
                } else {
                    DispatchQueue.main.async {
                        self?.setStatus(status: false, message: ">>Biometria inválida")
                    }
                }
            }
        }
        
        
        mainView.loginAction = loginAction
        
    }
    
    private func searchEntry(key: String) -> (String, String)? {
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
                
                return (key, password)
            }
            
        } else {
            print("error")
            return nil
        }
        
        return nil
    }
    
    func setStatus(status: Bool, message: String) {
        mainView.statusLabel.text = message
        mainView.statusLabel.textColor = status ? .green : .red
    }
    
}

