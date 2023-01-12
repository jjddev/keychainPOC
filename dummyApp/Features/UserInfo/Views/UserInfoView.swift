import Foundation
import UIKit

final class CreateAccountView: UIView {
    let keyTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .line
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.textContentType = .password
        return textField
    }()
    
    let keyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Chave/ID"
        return label
    }()
    
    let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .line
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.textContentType = .password
        return textField
    }()
    
    let createButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .blue
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .title1)
        button.setTitle("Criar chave", for: .normal)
        button.addTarget(self, action: #selector(checkEntry), for: .touchUpInside)
        return button
    }()
    
    let passwordLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Senha"
        return label
    }()
    
    let stackContainer: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 8
        return stack
    }()
    
    var backAction: (() -> Void)?
    private let navigation: UINavigationController?
        
    init(navigation: UINavigationController) {
        self.navigation = navigation
        super.init(frame: .zero)
        setupViewConfiguration()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    func checkEntry() {
        let key: String = keyTextField.text ?? ""
        let password: String = passwordTextField.text ?? ""
        
        
        guard !key.isEmpty, !password.isEmpty else {
            let alertController = UIAlertController(title: "Erro", message: "O valor da chave ou da senha não podem ser vazios.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default))
            navigation?.topViewController?.present(alertController, animated: true)
            return
        }
        
        
        let alertController = UIAlertController(title: "Sucesso", message: "Chave criada com sucesso", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            self.navigation?.popViewController(animated: true)
        }))
        
        if searchEntry(key: key) == nil {
            createEntry(key: key, password: password)
            navigation?.topViewController?.present(alertController, animated: true)
        } else {
            
        }
    }
    
    
    func createEntry(key: String, password: String) {
        print(">>create")
        
        let attributes: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: password.data(using: .utf8)
        ]
        
        
        if SecItemAdd(attributes as CFDictionary, nil) == noErr {
            print("saved")
        } else {
            print("error")
        }

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
}



extension CreateAccountView: ViewCodingProtocol {
    func buildViewHierarchy() {
        stackContainer.addArrangedSubview(keyLabel)
        stackContainer.addArrangedSubview(keyTextField)
        stackContainer.addArrangedSubview(passwordLabel)
        stackContainer.addArrangedSubview(passwordTextField)
        
        addSubview(stackContainer)
        addSubview(createButton)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            stackContainer.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackContainer.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 60),
            stackContainer.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stackContainer.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
        ])
        
        NSLayoutConstraint.activate([
            keyTextField.heightAnchor.constraint(equalToConstant: 44),
            passwordTextField.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        NSLayoutConstraint.activate([
            createButton.topAnchor.constraint(equalTo: stackContainer.bottomAnchor, constant: 80),
            createButton.heightAnchor.constraint(equalToConstant: 44),
            createButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            createButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
        ])
    }
    
    func configurationViews() {
        backgroundColor = .systemBackground
    }
}
