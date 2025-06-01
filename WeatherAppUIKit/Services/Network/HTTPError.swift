
import Foundation

enum HTTPError: Error {
    case invalidURL, badRequest, badResponse, invalidDecoding, invalidEncoding
}
