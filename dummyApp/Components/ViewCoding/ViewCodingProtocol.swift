import UIKit

protocol ViewCodingProtocol: AnyObject {
    func setupViewConfiguration()
    func buildViewHierarchy()
    func setupConstraints()
    func configurationViews()
}

extension ViewCodingProtocol {
    func setupViewConfiguration() {
        buildViewHierarchy()
        setupConstraints()
        configurationViews()
    }
    
    func configurationViews() {
        
    }
}
