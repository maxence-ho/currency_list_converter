//
//  PollingAsync.swift
//  currency_converter
//
//  Created by HO Maxence (i-BP) on 24/02/2019.
//  Copyright © 2019 chiminhTT. All rights reserved.
//

import Foundation
import Promises

let concurrentPollingQueue = DispatchQueue(label: "polling_queue", attributes: .concurrent)

/** Defines the structure */
class PollAsyncTask<T: Codable>
{
    /** Factory generating the request's promises */
    let requestFactory: RequestFactory<T>!
    /** Completion handler to be called when the request's promise succeeds */
    let completion: ((T) -> Void)!
    /** Polling interval */
    let interval: TimeInterval!
    /** Polling timer (in seconds) that will run in concurrent queue */
    let timer = DispatchSource.makeTimerSource(queue: concurrentPollingQueue)
    
    init(requestFactory: RequestFactory<T>,
         completion: @escaping ((T) -> Void),
         interval: TimeInterval )
    {
        self.requestFactory = requestFactory
        self.completion = completion
        self.interval = interval
    }
    
    deinit
    {
        timer.setEventHandler {}
        timer.cancel()
    }
}

extension PollAsyncTask
{
    /** Setup and starts the polling timer and its handler (based on the `completion` parameter) */
    func start()
    {
        timer.schedule(
            deadline: .now(),
            repeating: .milliseconds(Int(interval * 1000)),
            leeway: .milliseconds(100)
        )
        
        timer.setEventHandler { [weak self] in
            guard let self = self else { return }
            self.requestFactory
                .getRequest()
                .then({ [weak self] response in
                    guard let self = self else { return }
                    self.completion(response)
                })
        }
        
        timer.resume()
    }
}
