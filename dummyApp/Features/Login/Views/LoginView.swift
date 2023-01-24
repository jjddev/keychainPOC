import Foundation
import UIKit

final class LoginView: UIView {
    
    let keyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Chave/ID"
        return label
    }()
    
    let keyTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .line
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.textContentType = .password
        return textField
    }()
    
    let loginButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .blue
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .title1)
        button.setTitle("Login", for: .normal)
        button.addTarget(self, action: #selector(checkEntry), for: .touchUpInside)
        return button
    }()
    
    let statusLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ">>"
        label.textColor = .green
        return label
    }()
        
    let stackContainer: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 8
        return stack
    }()
    
    private let navigation: UINavigationController?
    var loginAction: (() -> Void)?
        
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
        loginAction?()
    }
}



extension LoginView: ViewCodingProtocol {
    func buildViewHierarchy() {
        stackContainer.addArrangedSubview(keyLabel)
        stackContainer.addArrangedSubview(keyTextField)
        stackContainer.addArrangedSubview(statusLabel)
        
        addSubview(stackContainer)
        addSubview(loginButton)
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
        ])
        
        NSLayoutConstraint.activate([
            loginButton.topAnchor.constraint(equalTo: stackContainer.bottomAnchor, constant: 80),
            loginButton.heightAnchor.constraint(equalToConstant: 44),
            loginButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            loginButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
        ])
    }
    
    func configurationViews() {
        backgroundColor = .systemBackground
        keyTextField.becomeFirstResponder()
    }
}
