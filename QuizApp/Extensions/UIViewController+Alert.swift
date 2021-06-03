import UIKit

extension UIViewController {
    func handleError(_ error: RequestError) {
        switch error {
        case .noConnectionError:
            noConnectionAlert()
        case .clientError:
            errorAlert(title: "Client error", message: "Applcation wasn't able to make connection")
        case .serverError, .noDataError, .decodingError:
            errorAlert(title: "Server error", message: "Applcation wasn't able to download")
        }
    }
    
    func noConnectionAlert() {
        errorAlert(title: "No connection", message: "Please check your Internet connection")
    }
    
    func errorAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
}
