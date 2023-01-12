import Foundation
import UIKit

final class MainView: UIView {
    let welcomeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .title1)
        label.textColor = .green
        label.text = "Hello view code! it's works"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        
        addSubview(welcomeLabel)
        NSLayoutConstraint.activate([
            welcomeLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            welcomeLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
        
        configurationViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



extension MainView: ViewCodingProtocol {
    func buildViewHierarchy() {
        addSubview(welcomeLabel)
    }
    
    func setupConstraints() {
        
    }
    
    func configurationViews() {
        backgroundColor = .systemBackground
    }
}
