import UIKit
import OlchaUI
import OlchaUtils

public class AboutViewController: BaseViewController<TitleNavigationBar> {
    
    public var logo: UIImage? {
        didSet { logoImageView.image = logo }
    }
    public var appUrl: String?
    
    private let topStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 20
        stack.alignment = .center
        return stack
    }()
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.round(8)
        return imageView
    }()
    
    private let versionLabel: UILabel = {
        let label = UILabel()
        label.style(.semibold, 16.0)
        label.textColor = .olchaPrimaryColor
        return label
    }()
    
    private lazy var table: BaseTableView = {
        let table = BaseTableView()
        table.delegate = self
        table.dataSource = self
        table.registerClass(forCell: AboutTableCell.self)
        table.configure()
        return table
    }()
    
    public override func setupViews() {
        container.addSubview(topStack)
        topStack.addArrangedSubview(logoImageView)
        topStack.addArrangedSubview(versionLabel)
        container.addSubview(table)
    }
    
    public override func autolayout() {
        topStack.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(44)
            make.left.right.equalToSuperview().inset(16)
        }
        logoImageView.snp.makeConstraints { make in
            make.height.width.equalTo(50)
        }
        table.snp.makeConstraints { make in
            make.top.equalTo(topStack.snp.bottom).offset(40)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    public override func configureViews() {
        navigationBar.setTitle("about_app".localized(.common))
        versionLabel.text = "\(Bundle.main.appVersionLong) (\(Bundle.main.appBuild))"
    }

    public func setup(logo: UIImage?, url: String) {
        self.logo = logo
        self.appUrl = url
    }
}
