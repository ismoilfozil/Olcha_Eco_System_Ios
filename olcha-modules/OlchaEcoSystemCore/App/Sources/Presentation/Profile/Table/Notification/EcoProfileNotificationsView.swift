import UIKit
import OlchaUI
import OlchaCommon
import OlchaUtils
import Combine

public class EcoProfileNotificationsView: BaseView {
    
    @Published public var cards: [NotificationCard] = []
    @Published public var readNotification: CommonNotificationModel?
    public var tapObserver: ((ClickAction?) -> Void)?
    private var cardAttributes: [(downscale: CGFloat, alpha: CGFloat)] {
        [(1, 1), (0.92, 0.95), (0.84, 0.95)]
    }
    private var cardColors: [UIColor] = [UIColor.black, UIColor.green, UIColor.yellow]
    private var cardIsHiding = false
    private var cardTranslation: CGPoint = .zero
    private let cardInteritemSpacing: CGFloat = 11
    
    public override func configureViews() {
        clipsToBounds = false
    }
    
}

public extension EcoProfileNotificationsView {
    struct Constants {
        static let cardsMaxIndex = 2
        static let cardsMax = 3
    }
    
    func addCards(notifications: [CommonNotificationModel]) {
        notifications.forEach { notification in
            switch notification.getTemplate() {
            case .installment:
                let card = NotificationCardInstallmentView(frame: CGRect(x: 0, y: 0, width: 300, height: 82))
                card.setup(with: notification)
                cards.append(card)
            case .order:
                let card = NotificationCardView(frame: CGRect(x: 0, y: 0, width: 300, height: 82))
                card.setup(with: notification)
                cards.append(card)
            default: break
            }
        }
        newLayoutCards()
    }
    /// Set up the frames, alphas, and transforms of the first 3 cards on the screen
    func newLayoutCards() {
        guard !cards.isEmpty else { return }
        cards.forEach({
            $0.frame.size.width = frame.width - 32
            $0.closeCardObserver = removeFrontCard
            $0.cardTappedObserver = tapObserver
        })
        // frontmost card (first card of the deck)
        let firstCard = cards[0]
        self.addSubview(firstCard)
        firstCard.layer.zPosition = CGFloat(cards.count)
        firstCard.center = self.center
        firstCard.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handleCardPan)))
        
        // the next 2 cards in the deck
        for i in 1...Constants.cardsMaxIndex {
            if i > (cards.count - 1) { continue }
            
            let card = cards[i]
            
            card.layer.zPosition = CGFloat(cards.count - i)
            
            // here we're just getting some hand-picked vales from cardAttributes (an array of tuples)
            // which will tell us the attributes of each card in the 3 cards visible to the user
            let downscale = cardAttributes[i].downscale
            let alpha = cardAttributes[i].alpha
            card.transform = CGAffineTransform(scaleX: downscale, y: downscale)
            card.alpha = alpha
            
            // position each card so there's a set space (cardInteritemSpacing) between each card, to give it a fanned out look
            card.center.x = self.center.x
            card.frame.origin.y = cards[0].frame.origin.y - (CGFloat(i) * cardInteritemSpacing)
            
            self.addSubview(card)
        }
        
        // make sure that the first card in the deck is at the front
        self.bringSubviewToFront(cards[0])
    }
    
    /// This is called whenever the front card is swiped off the screen or is animating away from its initial position.
    /// showNextCard() just adds the next card to the 3 visible cards and animates each card to move forward.
    func newShowNextCard(completion: (() -> Void)?) {
        guard !cards.isEmpty else { return }
        let animationDuration: TimeInterval = 0.2
        // 1. animate each card to move forward one by one
        for i in 1...Constants.cardsMaxIndex {
            if i > (cards.count - 1) { continue }
            let card = cards[i]
            let newDownscale = cardAttributes[i - 1].downscale
            let newAlpha = cardAttributes[i - 1].alpha
            UIView.animate(
                withDuration: animationDuration,
                delay: (TimeInterval(i - 1) * (animationDuration / 2)),
                usingSpringWithDamping: 0.8,
                initialSpringVelocity: 0.0,
                options: [], animations: {
                card.transform = CGAffineTransform(scaleX: newDownscale, y: newDownscale)
                card.alpha = newAlpha
                if i == 1 {
                    card.center = self.center
                } else {
                    card.center.x = self.center.x
                    card.frame.origin.y = self.cards[1].frame.origin.y - (CGFloat(i - 1) * self.cardInteritemSpacing)
                }
            }, completion: { (_) in
                if i == 1 {
                    card.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(self.handleCardPan)))
                }
            })
            
        }
        
        // 2. add a new card (now the 4th card in the deck) to the very back
        if Constants.cardsMax > (cards.count - 1) {
            if cards.count != 1 {
                self.bringSubviewToFront(cards[1])
            }
            return
        }
        let newCard = cards[Constants.cardsMax]
        newCard.layer.zPosition = CGFloat(cards.count - Constants.cardsMax)
        let downscale = cardAttributes[Constants.cardsMaxIndex].downscale
        let alpha = cardAttributes[Constants.cardsMaxIndex].alpha
        
        // initial state of new card
        newCard.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        newCard.alpha = 0
        newCard.center.x = self.center.x
        newCard.frame.origin.y = cards[1].frame.origin.y - (CGFloat(Constants.cardsMax) * cardInteritemSpacing)
        self.addSubview(newCard)
        
        // animate to end state of new card
        UIView.animate(
            withDuration: animationDuration,
            delay: (Double(Constants.cardsMaxIndex) * (animationDuration / 2)),
            usingSpringWithDamping: 0.8,
            initialSpringVelocity: 0.0,
            options: [], animations: {
            newCard.transform = CGAffineTransform(scaleX: downscale, y: downscale)
            newCard.alpha = alpha
            newCard.center.x = self.center.x
            newCard.frame.origin.y = self.cards[1].frame.origin.y - (CGFloat(Constants.cardsMaxIndex) * self.cardInteritemSpacing) + 1.5
        }, completion: { (_) in
            completion?()
        })
        // first card needs to be in the front for proper interactivity
        self.bringSubviewToFront(self.cards[1])
        
    }
    
    /// This function continuously checks to see if the card's center is on the screen anymore. If it finds that the card's center is not on screen, then it triggers removeOldFrontCard() which removes the front card from the data structure and from the view.
    func hideFrontCard() {
        var cardRemoveTimer: Timer? = nil
        cardRemoveTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { [weak self] (_) in
            guard let self else { return }
            cardRemoveTimer?.invalidate()
            cardIsHiding = true
            UIView.animate(withDuration: 0.2, delay: 0, options: [.curveLinear], animations: {
                self.cards[0].alpha = 0
            }, completion: { (_) in
                self.removeOldFrontCard()
                self.cardIsHiding = false
            })
        })
    }
    
    /// Whenever the front card is off the screen, this method is called in order to remove the card from our data structure and from the view.
    func removeOldFrontCard() {
        guard !cards.isEmpty else { return }
        cards[0].removeFromSuperview()
        cards.remove(at: 0)
    }
    
    func destroy(completion: (() -> Void)? = nil) {
        cards.forEach { card in
            card.removeFromSuperview()
            card.isHidden = true
        }
        cards.removeAll()
        completion?()
    }
    
}

private extension EcoProfileNotificationsView {
    @objc func handleCardPan(sender: UIPanGestureRecognizer) {
        // if we're in the process of hiding a card, don't let the user interace with the cards yet
        if cardIsHiding { return }
        let scale = CGAffineTransform(scaleX: 1.08, y: 1.08)
        switch sender.state {
        case .began:
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.cards[0].transform = scale
            })
        case .changed:
            cardTranslation = sender.translation(in: cards[0])
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.cards[0].transform = CGAffineTransform(
                    translationX: self.cardTranslation.x,
                    y: self.cardTranslation.y
                ).concatenating(scale)
            })
        case .ended:
            if cardTranslation.x < -40.0 || cardTranslation.x > 40.0 {
                removeFrontCard()
            } else {
                UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    self.cards[0].transform = .identity
                })
            }
        default:
            break
        }
    }
    
    func removeFrontCard() {
        guard let model = self.cards[0].model else { return }
        readNotification = model
        newShowNextCard(completion: nil)
        hideFrontCard()
    }
}
