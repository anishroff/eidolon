import UIKit

public enum RegistrationIndex {
    case MobileVC
    case EmailVC
    case PasswordVC
    case CreditCardVC
    case ZipCodeVC
    case ConfirmVC
    
    public func toInt() -> Int {
        switch (self) {
            case MobileVC: return 0
            case EmailVC: return 1
            case PasswordVC: return 1
            case CreditCardVC: return 2
            case ZipCodeVC: return 3
            case ConfirmVC: return 4
        }
    }

    public static func fromInt(index:Int) -> RegistrationIndex {
        switch (index) {
            case 0: return .MobileVC
            case 1: return .EmailVC
            case 1: return .PasswordVC
            case 2: return .CreditCardVC
            case 3: return .ZipCodeVC
            default : return .ConfirmVC
        }
    }
}

public class RegistrationCoordinator: NSObject {

    public dynamic var currentIndex: Int = 0
    public var storyboard:UIStoryboard!

    func viewControllerForIndex(index: RegistrationIndex) -> UIViewController {
        currentIndex = index.toInt()
        
        switch index {

        case .MobileVC:
            return storyboard.viewControllerWithID(.RegisterMobile)

        case .EmailVC:
            return storyboard.viewControllerWithID(.RegisterEmail)

        case .PasswordVC:
            return storyboard.viewControllerWithID(.RegisterPassword)

        case .CreditCardVC:
            if AppSetup.sharedState.disableCardReader {
                return storyboard.viewControllerWithID(.ManualCardDetailsInput)
            } else {
                return storyboard.viewControllerWithID(.RegisterCreditCard)
            }


        case .ZipCodeVC:
            return storyboard.viewControllerWithID(.RegisterPostalorZip)

        case .ConfirmVC:
            return storyboard.viewControllerWithID(.RegisterConfirm)
        }
    }

    func nextViewControllerForBidDetails(details: BidDetails) -> UIViewController {
        if notSet(details.newUser.phoneNumber) {
            return viewControllerForIndex(.MobileVC)
        }

        if notSet(details.newUser.email) {
            return viewControllerForIndex(.EmailVC)
        }

        if notSet(details.newUser.password) {
            return viewControllerForIndex(.PasswordVC)
        }

        if notSet(details.newUser.creditCardToken) {
            return viewControllerForIndex(.CreditCardVC)
        }

        if notSet(details.newUser.zipCode) {
            return viewControllerForIndex(.ZipCodeVC)
        }

        return viewControllerForIndex(.ConfirmVC)
    }
}

private func notSet(string:String?) -> Bool {
    return string?.isEmpty ?? true
}
