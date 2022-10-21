import Foundation

/// A type of ``Call`` that will be triggered via a HTTP request.
protocol HTTPCall: Call, HTTPRequestable where Response: HTTPResponse {}
