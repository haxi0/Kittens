//
//  Extensions.swift
//  Kittens
//
//  Created by Анохин Юрий on 03.12.2022.
//

import SwiftUI
import SystemConfiguration

struct VisualEffectView: UIViewRepresentable {
    var effect: UIVisualEffect?
    func makeUIView(context: UIViewRepresentableContext<Self>) -> UIVisualEffectView { UIVisualEffectView() }
    func updateUIView(_ uiView: UIVisualEffectView, context: UIViewRepresentableContext<Self>) { uiView.effect = effect }
}

public struct untitledStyle: ButtonStyle {
    public func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .font(Font.body.weight(.medium))
            .foregroundColor(Color.accentColor)
            .padding(.vertical, 12)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 14.0, style: .continuous)
                    .fill(Color.gray)
                    .opacity(0.2)
                )
            .opacity(configuration.isPressed ? 0.2 : 1.0)
    }
}

public class Reachability {

    class func isConnectedToNetwork() -> Bool {

        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)

        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }

        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }

        /* Only Working for WIFI
        let isReachable = flags == .reachable
        let needsConnection = flags == .connectionRequired

        return isReachable && !needsConnection
        */

        // Working for Cellular and WIFI
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        let ret = (isReachable && !needsConnection)

        return ret

    }
}

extension UIApplication {
    
    static var appVersion: String? {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
    }
    
}
