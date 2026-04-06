
import UIKit
import OlchaUI
import WebKit
class ProductCharacteristicsModalPage: BaseModalViewController {
    
    private let scrollView: IScrollView = {
        let scrollView = IScrollView()
        scrollView.container.spacing = 16
        scrollView.settings.contentInset = .init(top: 16, left: 0, bottom: 16, right: 0)
        scrollView.settings.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private let characteristicsView = CharacteristicsContainer()
    
    private var characteristics: [CharacteristicFeature] = []
    
    override func setupViews() {
        container.addSubview(scrollView)
        scrollView.addArrangedSubview(view: characteristicsView)
    }
    
    override func autolayout() {
        scrollView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.right.equalToSuperview().inset(16)
        }
    }
    
    override func configureViews() {
        setHeader(title: "characteristics".localized())
        setContainerHeight()
    }
    
    func setup(with data: CharacteristicsData?) {
        if let dictionary = data?.features?.values {
            characteristics = Array(dictionary)
            characteristicsView.setup(with: characteristics)
        }
    }
    
}
