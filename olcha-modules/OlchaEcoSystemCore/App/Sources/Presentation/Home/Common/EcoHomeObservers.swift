import Combine
import OlchaUtils

public class EcoHomeObservers {
    
    public let clickActionSubject = PassthroughSubject<ClickAction, Never>()
    public let appServiceSubject = PassthroughSubject<EcoHomeViewController.EcoAppService, Never>()
}
