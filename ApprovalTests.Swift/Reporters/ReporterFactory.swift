public class ReporterFactory {
    public static var defaultReporter: () -> ApprovalFailureReporter = {
        DefaultReporter()
    }

    public static var get: ApprovalFailureReporter {
        defaultReporter()
    }
    
    public static func registerDefaultReporter(_ newReporterCreator: @escaping () -> ApprovalFailureReporter) -> DefaultReporterDisposer {
        DefaultReporterDisposer(newReporterCreator)
    }
}

public class DefaultReporterDisposer {
    private let oldCreator: () -> ApprovalFailureReporter 

    public init(_ newCreator: @escaping () -> ApprovalFailureReporter) {
        oldCreator = ReporterFactory.defaultReporter
        ReporterFactory.defaultReporter = newCreator
    }

    deinit {
        ReporterFactory.defaultReporter = oldCreator
    }
}

#if os(OSX)
    public typealias DefaultReporter = ReportersForMac
#elseif os(iOS)
    public typealias DefaultReporter = ReportersForiOS
#endif
