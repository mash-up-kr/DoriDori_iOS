//
//  NetworkTests.swift
//  DoriDori_iOSTests
//
//  Created by JeongMinho on 2022/06/15.
//

import XCTest
@testable import DoriDori_iOS

final class NetworkTests: XCTestCase {

    private var sut: Network!
    
    override func setUp() {
        super.setUp()
        self.sut = Network()
    }

    override func tearDown() {
        self.sut = nil
        super.tearDown()
    }

    func testRxNetwork_setFailRequest_catchError() async {
        // given
        let request = FakeRequest(
            url: "fakeProtocol//api",
            parameters: ["fake": ""],
            method: .get
        )
        
        // when
        var response: ResponseModel<FakeModel>?
        var networkError: Error?
        do {
            response = try await sut.fetch2(
                request: request,
                responseModel: ResponseModel<FakeModel>.self
            ).value
        } catch (let error) {
            networkError = error
        }
        
        // then
        XCTAssertNil(response)
        XCTAssertNotNil(networkError)
    }

    func testConcurrencyNetwork_setFailRequest_catchError() async {
        // given
        let request = FakeRequest(
            url: "fakeProtocol//api",
            parameters: ["fake": ""],
            method: .get
        )
        
        // when
        var response: ResponseModel<FakeModel>?
        var networkError: Error?
        
        do {
            response = try await sut.fetch(
                request: request,
                responseModel: ResponseModel<FakeModel>.self
            )
        } catch (let error) {
            networkError = error
        }
       
        // then
        XCTAssertNil(response)
        XCTAssertNotNil(networkError)
    }
}
