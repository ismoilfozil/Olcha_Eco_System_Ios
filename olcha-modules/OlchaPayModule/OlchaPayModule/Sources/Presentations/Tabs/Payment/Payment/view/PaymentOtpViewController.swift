
import UIKit
import OlchaUI
public class PaymentOtpViewController: BaseViewController<BackNavigationBar> {

    private lazy var scrollView: IScrollView = {
        let scrollView = IScrollView()
        scrollView.container.spacing = 8
        scrollView.container.alignment = .leading
        return scrollView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.style(.regular, 14)
        label.textColor = .olchaTextBlack
        label.text = "code_sent_subtitle".localized() + ": "
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var codeField: OtpField = {
        let field = OtpField()
        field.topHint = "code".localized()
        field.field_tag = (\VerifyCardOTPRequest.code).propertyName
        return field
    }()
    
    private lazy var nextButton: OlchaButton = {
        let button = OlchaButton()
        button.setTitle("next".localized())
        button.configure(type: .pay)
        return button
    }()
    
    public override var validatedFields: [TField] {
        [codeField]
    }

    public var input: Input
    public let transactionViewModel: TransactionViewModel
    public let makeTransactionViewModel: MakeTransactionViewModel
    public let bankCardsViewModel: BankCardsViewModel
    public weak var coordinator: PaymentsCoordinatorProtocol?
    
    public init(transactionViewModel: TransactionViewModel,
                makeTransactionViewModel: MakeTransactionViewModel,
                bankCardsViewModel: BankCardsViewModel,
                input: Input = .init()) {
        self.transactionViewModel = transactionViewModel
        self.makeTransactionViewModel = makeTransactionViewModel
        self.bankCardsViewModel = bankCardsViewModel
        self.input = input
        super.init()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func setupViews() {
        container.addSubview(scrollView)
        scrollView.addArrangedSubview(titleLabel)
        scrollView.addArrangedSubview(codeField)
        scrollView.addArrangedSubview(nextButton)
    }
    
    public override func autolayout() {
        scrollView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.right.equalToSuperview().inset(16)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
        }

        codeField.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
        }
        
        nextButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
        }
    }
    
    public override func configureViews() {
        navigationBar.setTitle("enter_code".localized())
        scrollView.container.setCustomSpacing(8, after: titleLabel)
        checkButtonState()
    }
    
    public override func initialRequest() {
        startTimer()
    }
    
    public override func setupObservers() {
        
        codeField.observeText { [weak self] in
            guard let self = self else { return }
            checkButtonState()
        }
        
        nextButton.clicked { [weak self] in
            guard let self = self else { return }
            verifyOTP()
        }
        
        codeField.sendButton.clicked { [weak self] in
            guard let self else { return }
            makeTransaction()
        }
        
        handle(makeTransactionViewModel.$transactionVerifyOtp) { [weak self] data in
            guard let self else { return }
            self.coordinator?.pushPaymentFinish(transaction: data?.transaction)
            self.transactionViewModel.loadInitialTransactions()
            self.bankCardsViewModel.initialLoad(withBankCards: false)
        } loading: { [weak self] isLoading in
            guard let self else { return }
            nextButton.settings.requesting = isLoading
        }
        
        handle(makeTransactionViewModel.$makeTransaction,
               success: { [weak self] data in
            guard let self = self else { return }
            print("check data", data)
            input.verifyOtpData = data
            setupData()
        })
        
    }
    
    public func verifyOTP() {
        makeTransactionViewModel.makeTransactionVerifyOtp(otp: codeField.getValue(),
                                                          verifyOtpData: input.verifyOtpData)
    }
    
    private func checkButtonState() {
        let isEnabled = codeField.getText() != ""
        isEnabled ? nextButton.enableButton() : nextButton.disableButton()
    }
    
    private func makeTransaction() {
        if let helper = input.paymentHelper {
            makeTransactionViewModel.makeTransaction(helper: helper)
            startTimer()
        }
    }
    
    private func startTimer() {
        codeField.startTimer()
    }

    private func stopTimer() {
        codeField.stopTimer()
    }
    
    public func setupData() {
        titleLabel.attributedText = getTitleText()
    }
    
    private func getTitleText() -> NSMutableAttributedString {
        let mutableString = NSMutableAttributedString()
        mutableString.append(("code_sent_subtitle".localized() + ": ").attributed([
            .font: UIFont.style(.medium, 16),
            .foregroundColor: UIColor.olchaTextBlack,
        ]))
        
        mutableString.append((input.verifyOtpData?.getPhone() ?? "").attributed([
            .font: UIFont.style(.medium, 16),
            .foregroundColor: UIColor.olchaGreen,
        ]))
        return mutableString
    }
}

