// Copyright 2024 The NATS Authors
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import Foundation
import XCTest

@testable import Nats

#if canImport(FoundationNetworking)
    import FoundationNetworking
#endif

class JwtTests: XCTestCase {

    static var allTests = [
        ("testParseCredentialsFile", testParseCredentialsFile)
    ]

    func testParseCredentialsFile() async throws {
        logger.logLevel = .debug
        let currentFile = URL(fileURLWithPath: #file)
        let testDir = currentFile.deletingLastPathComponent().deletingLastPathComponent()
        let resourceURL = testDir.appendingPathComponent("Integration/Resources/TestUser.creds")
        let credsData = try await URLSession.shared.data(from: resourceURL).0

        let nkey = String(data: JwtUtils.parseDecoratedNKey(contents: credsData)!, encoding: .utf8)
        let expectedNkey = "SUACH75SWCM5D2JMJM6EKLR2WDARVGZT4QC6LX3AGHSWOMVAKERABBBRWM"

        XCTAssertEqual(nkey, expectedNkey)

        let jwt = String(data: JwtUtils.parseDecoratedJWT(contents: credsData)!, encoding: .utf8)
        let expectedJWT =
            "eyJ0eXAiOiJKV1QiLCJhbGciOiJlZDI1NTE5LW5rZXkifQ.eyJqdGkiOiJMN1dBT1hJU0tPSUZNM1QyNEhMQ09ENzJRT1czQkNVWEdETjRKVU1SSUtHTlQ3RzdZVFRRIiwiaWF0IjoxNjUxNzkwOTgyLCJpc3MiOiJBRFRRUzdaQ0ZWSk5XNTcyNkdPWVhXNVRTQ1pGTklRU0hLMlpHWVVCQ0Q1RDc3T1ROTE9PS1pPWiIsIm5hbWUiOiJUZXN0VXNlciIsInN1YiI6IlVBRkhHNkZVRDJVVTRTREZWQUZVTDVMREZPMlhNNFdZTTc2VU5YVFBKWUpLN0VFTVlSQkhUMlZFIiwibmF0cyI6eyJwdWIiOnt9LCJzdWIiOnt9LCJzdWJzIjotMSwiZGF0YSI6LTEsInBheWxvYWQiOi0xLCJ0eXBlIjoidXNlciIsInZlcnNpb24iOjJ9fQ.bp2-Jsy33l4ayF7Ku1MNdJby4WiMKUrG-rSVYGBusAtV3xP4EdCa-zhSNUaBVIL3uYPPCQYCEoM1pCUdOnoJBg"

        XCTAssertEqual(jwt, expectedJWT)
    }
}
