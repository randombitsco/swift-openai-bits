import Foundation

/// A type of ``Call`` that will be triggered via HTTP.
protocol HTTPCall: Call, HTTPRequestable where Response: HTTPResponse {}
