//
//  PollAsync.swift
//  currency_converterTests
//
//  Created by HO Maxence (i-BP) on 26/02/2019.
//  Copyright © 2019 chiminhTT. All rights reserved.
//

import XCTest
import Promises

@testable import currency_converter

class PollAsyncTests: XCTestCase
{
    var testPoll: PollAsyncTask<Bool>?
    
    /**
     * - When : calling `start` from PollAsync instance that is killed after 3 ticks
     * - Expects : at each timer tick, the correct response is returned
     * - Expects : exactly 3 ticks have happened
     */
    func test_start() {
        var count = 0
        let testRequestFactory = RequestFactory(getRequest: {
            return Promise<Bool> { fulfill, reject in
                fulfill(true)
            }
        })
        
        let expectation = XCTestExpectation(description: "Get 3 ticks of polling")
        testPoll = PollAsyncTask(
            requestFactory: testRequestFactory,
            completion: { response in
                print(count)
                XCTAssert(response == true)
                guard count < 3 else
                {
                    self.testPoll = nil
                    expectation.fulfill()
                    return
                }
                count += 1
            },
            interval: 1
        )
        testPoll?.start()
        wait(for: [expectation], timeout: 4.0)
        
        XCTAssert(count == 3)
    }
}
