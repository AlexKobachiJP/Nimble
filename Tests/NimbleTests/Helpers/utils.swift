#if !os(WASI)
import Dispatch
#endif
import Foundation
@testable import Nimble
import XCTest

@discardableResult
func suppressErrors<T>(closure: () -> T) -> T {
    var output: T?
    let recorder = AssertionRecorder()
    withAssertionHandler(recorder) {
        output = closure()
    }
    return output!
}

func producesStatus<Exp: Expectation, T>(_ status: ExpectationStatus, file: FileString = #file, line: UInt = #line, closure: () -> Exp) where Exp.Value == T {
    let expectation = suppressErrors(closure: closure)
    
    expect(file: file, line: line, expectation.status).to(equal(status))
}

#if !os(WASI)
func deferToMainQueue(action: @escaping () -> Void) {
    DispatchQueue.main.async {
        Thread.sleep(forTimeInterval: 0.01)
        action()
    }
}
#endif

#if !os(WASI)
extension Date {
    init(dateTimeString: String) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        let date = dateFormatter.date(from: dateTimeString)!
        self.init(timeInterval: 0, since: date)
    }
}

extension NSDate {
    convenience init(dateTimeString: String) {
        let date = Date(dateTimeString: dateTimeString)
        self.init(timeIntervalSinceReferenceDate: date.timeIntervalSinceReferenceDate)
    }
}
#endif
