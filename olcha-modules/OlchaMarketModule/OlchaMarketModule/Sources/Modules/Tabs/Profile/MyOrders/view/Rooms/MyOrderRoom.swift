import UIKit
import CountdownLabel
import Combine
import OlchaUI

class MyOrderRoom: BaseTableCell {
    var count = 0
    
    private let headerContainer = UIView()
    
    private let dateTitle: UILabel = {
        let label = UILabel()
        label.style(.semibold, 18)
        label.textColor = .olchaTextBlack
        label.isUserInteractionEnabled = false
        label.text = "\t\t\t"
        return label
    }()
    
    private let orderNumberTitle: UILabel = {
        let label = UILabel()
        label.style(.medium, 14)
        label.textColor = .olchaBlue
        label.isUserInteractionEnabled = false
        label.text = "\t\t\t"
        return label
    }()
    
    private let statusContainer = UIView()
    
    private let statusScrollView = UIScrollView()
    
    let statusView: RightIconButton = {
        let button = RightIconButton()
        button.backgroundColor = .olchaAccentColor
        button.round()
        button.buttonTitle.style(.medium, 14)
        button.buttonTitle.textColor = .olchaWhite
        button.configure(image: .info?.withColor(.olchaWhite), title: "\t\t", size: 20, padding: 12)
        return button
    }()
    
    private let creditLabel: Label = {
        let label = Label()
        label.round()
        label.backgroundColor = .olchaAccentColor
        label.settings.textColor = .olchaWhite
        label.settings.style(.medium, 14)
        label.settings.textAlignment = .center
        label.text = "buy_credit".localized()
        label.verticalInset = 4
        label.horizontalInset = 12
        return label
    }()
    
    private lazy var productsTable: BaseTableView = {
        let table = BaseTableView()
        table.delegate = self
        table.dataSource = self
        table.registerClass(forCell: OrderProductRoom.self)
        table.isUserInteractionEnabled = false
        table.isScrollEnabled = false
        table.configure()
        return table
    }()

    private let bottomContainer = UIStackView()

    private let timerContainer = UIView()
    
    private let timerTitle: UILabel = {
        let label = UILabel()
        label.style(.medium, 16)
        label.textColor = .olchaLightTextColornnnnnn
        label.text = "order_will_cancel".localized()
        return label
    }()
    
    private lazy var timerValue: CountdownLabel = {
        let label = CountdownLabel()
        label.style(.medium, 16)
        label.textColor = .olchaAccentColor
        label.countdownDelegate = self
        label.text = ""
        return label
    }()
    
    
    private let buttonsContainer = UIView()
    private let buttonsStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 24
        return stack
    }()
    
    
    private let payButton: OlchaButton = {
        let button = OlchaButton()
        button.isUserInteractionEnabled = false
        button.setTitle("pay".localized())
        return button
    }()
    
    let cancelButton: Button = {
        let button = Button()
        button.titleLabel?.style(.medium, 16)
        button.setTitleColor(.olchaTextBlack, for: .normal)
        button.setTitle("to_cancel".localized(), for: .normal)
        return button
    }()

    let deliveryCodeButton: OlchaButton = {
        let button = OlchaButton()
        button.setTitle("receive_order".localized())
        return button
    }()
    
    weak var productHelper : ProductHelper?
    
    static let cellHeight: CGFloat = 110
    
    var products: [ProductModel] = []
    
    var order: Order?
    
    weak var tableReloader: PassthroughSubject<Bool, Never>?
    
    override func setupViews() {
        container.addSubview(headerContainer)
        headerContainer.addSubview(dateTitle)
        headerContainer.addSubview(orderNumberTitle)
        headerContainer.addSubview(statusScrollView)
        
        
        statusScrollView.addSubview(statusContainer)
        statusContainer.addSubview(statusView)
        statusContainer.addSubview(creditLabel)
        
        container.addSubview(productsTable)
        container.addSubview(bottomContainer)
        
        bottomContainer.addArrangedSubview(timerContainer)
        timerContainer.addSubview(timerTitle)
        timerContainer.addSubview(timerValue)
        
        bottomContainer.addArrangedSubview(buttonsContainer)
        buttonsContainer.addSubview(buttonsStack)

        buttonsStack.addArrangedSubview(deliveryCodeButton)
        buttonsStack.addArrangedSubview(cancelButton)
        buttonsStack.addArrangedSubview(payButton)
    }
    
    override func autolayout() {
        horizontalEdge = 16
        verticalEdge = 12
        
        headerContainer.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
        }
        
        dateTitle.snp.makeConstraints { make in
            make.left.top.equalToSuperview().inset(16)
        }
        
        orderNumberTitle.snp.makeConstraints { make in
            make.centerY.equalTo(dateTitle.snp.centerY)
            make.left.equalTo(dateTitle.snp.right).inset(-8)
        }
        
        statusScrollView.snp.makeConstraints { make in
            make.top.equalTo(orderNumberTitle.snp.bottom).inset(-8)
            make.bottom.left.right.equalToSuperview().inset(16)
            make.height.equalTo(28)
        }
        
        statusContainer.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(headerContainer.snp.width).priority(.low)
            make.height.equalTo(28)
        }
        
        statusView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview()
            make.height.equalTo(28)
        }
        
        creditLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.equalTo(statusView.snp.right).inset(-8)
            make.height.equalTo(28)
        }
        
        productsTable.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(statusContainer.snp.bottom)
            make.height.equalTo(0)
        }
        
        bottomContainer.snp.makeConstraints { make in
            make.top.equalTo(productsTable.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
        
        timerTitle.snp.makeConstraints { make in
            make.left.top.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(12)
        }
        
        timerValue.snp.makeConstraints { make in
            make.left.equalTo(timerTitle.snp.right).inset(-4)
            make.centerY.equalTo(timerTitle.snp.centerY)
        }
        
        buttonsStack.snp.makeConstraints { make in
            make.top.bottom.right.equalToSuperview().inset(16)
        }
    }
    
    override func configureViews() {
        
        container.round()
        container.border()
        
        statusScrollView.showsHorizontalScrollIndicator = false
        statusContainer.backgroundColor = .clear
        buttonsContainer.isHidden = true
        bottomContainer.axis = .vertical
        
        timerContainer.isHidden = true
        
        creditLabel.isUserInteractionEnabled = false
    }
    
    func setup(with data: Order?) {
        
        self.order = data
        
        dateTitle.text = "order_date".localized() + " : " + (data?.created_at ?? "").day_month
        orderNumberTitle.text = "#" + (data?.id?.string ?? "0")
        
        products = data?.products ?? []

        updateLayout()
        checkStatuses()
        
    }
    
    private func checkStatuses() {
        creditLabel.isHidden = !(order?.is_installment ?? false)
        
        statusView.configure(image: .info?.withColor(.olchaWhite),
                             title: (order?.getStatusTitle() ?? "").localized(),
                             size: 20,
                             padding: 12)
        statusView.backgroundColor = order?.getStatusColor()
        
        orderStatus()
    }
    
    private func updateLayout() {
    
        productsTable.reloadData()
        productsTable.snp.remakeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(statusContainer.snp.bottom)
            make.height.equalTo(MyOrderRoom.cellHeight * products.count.cgfloat)
        }
    }

    private func orderStatus() {
        cancelButton.isHidden = true
        payButton.isHidden = true
        deliveryCodeButton.isHidden = true
        buttonsContainer.isHidden = true

        let showDeliveryCode = order?.shouldShowDeliveryCode() ?? false
        deliveryCodeButton.isHidden = !showDeliveryCode

        if (order?.is_installment ?? false) {

            buttonsContainer.isHidden = !(installmentPayStatus() || installmentCancelStatus() || showDeliveryCode)
            payButton.isHidden = !installmentPayStatus()
            cancelButton.isHidden = !installmentCancelStatus()

        } else {

            buttonsContainer.isHidden = !(orderCancelStatus() || orderPayStatus() || showDeliveryCode)
            cancelButton.isHidden = !orderCancelStatus()
            payButton.isHidden = !orderPayStatus()

        }

    }
    
    private func orderCancelStatus() -> Bool {
        return order?.can_cancel ?? false
    }
    
    private func orderPayStatus() -> Bool {
//        let status = order?.getStatus()
//        return status == .pending
        return false
    }
    
    private func installmentPayStatus() -> Bool {
//        (order?.checkInstallmentPayButtonStatus() ?? false)
        return false
    }
    
    private func installmentCancelStatus() -> Bool {
        return order?.can_cancel ?? false
    }
}
extension MyOrderRoom: CountdownLabelDelegate{
    func countdownFinished() {
        timerContainer.isHidden = true
        tableReloader?.send(true)
    }
}

extension MyOrderRoom {
    
    private func startTimer() {
        
        let endDateStr = order?.created_at ?? ""

        let dateFormat = "dd-MM-yyyy HH:mm"
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = dateFormat

        let endDate = dateFormater.date(from: endDateStr)
        
        if let endDate = endDate, Calendar.current.isDateInToday(endDate) {
             
                timerContainer.isHidden = false
                
                let cal = Calendar.current

                let components = cal.dateComponents([.hour, .minute, .second],
                                                    from: endDate, to: Date())
                
                let hour = components.hour ?? 0
                let minute = components.minute ?? 0
                let second = components.second ?? 0
            
                if hour < 1 {
                    timerValue.setCountDownTime(fromDate: NSDate(), minutes: TimeInterval((59-minute)*60 + (59-second)))
                    
                    timerValue.start()
                } else {
                    timerContainer.isHidden = true
                    timerValue.pause()
                }
                
        } else {
            timerContainer.isHidden = true
        }
        
        
    }
    
    private func fillHours(time: Int) -> String {
        if time.string.count < 2 {
            return "0" + time.string
        } else {
            return time.string
        }
    }
    
}
