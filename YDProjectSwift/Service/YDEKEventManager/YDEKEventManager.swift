//
//  YDEKEventManager.swift
//  YDProjectSwift
//
//  Created by 王远东 on 2024/4/11.
//

import Foundation
import EventKit

private let kEventTitle = "记得打卡哦"

class YDEKEventManager {
    static let share = YDEKEventManager()
    
    lazy var store = EKEventStore()
    
    lazy var formatter: DateFormatter = {
        let fm = DateFormatter()
        fm.dateFormat = "yyyy-MM-dd HH:mm"
        return fm
    }()
    
    func requestEventAuth(_ callback:((Bool) -> Void)?) {
        store.requestAccess(to: EKEntityType.event) { granted, error in
            DispatchQueue.main.async {
                callback?(granted)
            }
        }
    }
    
    /// 向日历添加提醒事件
    /// - Parameters:
    ///   - title: 事件title（同时会作为事件标识，同样的title事件不会重复添加）
    ///   - startDate: 事件的开始日期
    ///   - endDate: 事件的结束日期
    ///   - time: 事件提醒的时间hh:mm
    ///   - complete: 回调block (事件是否添加成功, 失败原因) -> ()
    static func addEventWith(title: String?, startDate: Date, endDate: Date, time: String, complete: @escaping (Bool, String?) -> ()) {
        let manager = YDEKEventManager.share
        
        manager.requestEventAuth { result in
            if result == false {
                showAlertView(title: "请开启日历访问权限", message: "添加日报打卡提醒需要访问您的日历")
                complete(false, nil)
                return
            }
            
            let eventTitle = title ?? kEventTitle
    
            YDEKEventManager.deleteHistoryEnentWith(eventTitle)
            
            let event = EKEvent(eventStore: manager.store)
            event.title = eventTitle
            
            if let sstartDate = getDateWithTime(date: startDate, time: time) {
                //单次事件开始日期、结束日期
                let startDate = sstartDate
                let endDate = Date(timeInterval: 60, since: sstartDate)
                event.startDate = startDate
                event.endDate = endDate
                event.isAllDay = false
            } else {
                complete(false, "生成开始日期失败")
                return
            }
             
            //闹铃
            let elarm = EKAlarm(relativeOffset: 0)
            event.addAlarm(elarm)
            event.calendar = manager.store.defaultCalendarForNewEvents
            
            //重复规则
            if let ruleEndDate = getDateWithTime(date: endDate, time: time) {
                let rule = EKRecurrenceRule(recurrenceWith: .daily, interval: 1, end: EKRecurrenceEnd(end: ruleEndDate))
                event.addRecurrenceRule(rule)
            } else {
                complete(false, "添加重复规则失败")
                return
            }
           
            do {
                try manager.store.save(event, span: .thisEvent)
                YDEKEventManager.saveEnentIdentifier(key: eventTitle, identifier: event.eventIdentifier)
                LogInfo("添加日历提醒成功：\(event.eventIdentifier ?? "")")
                LogInfo("提醒开始时间：\(manager.formatter.string(from: startDate))")
                complete(true, "添加日历提醒成功")
            }
            catch {
                LogInfo("添加日历提醒失败")
                complete(false, "添加日历提醒失败")
            }
        }
    }
    
    /// 显示设置对话框
    class func showAlertView(title: String? = nil, message: String? = nil, canceled: (()->())? = nil) {
        let cancel = UIAlertAction(title: "不允许", style: .cancel, handler: { (_) in
            if let canceled = canceled {
                canceled()
            }
        })
        let settings = UIAlertAction(title: "去开启", style: .destructive) { (_) in
            UIApplication.shared.openSettingsURL()
        }
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(cancel)
        alert.addAction(settings)
        if let root = UIApplication.shared.keyWindow?.rootViewController {
            root.present(alert, animated: true, completion: nil)
        }
    }
        
    private static func getDateWithTime(date: Date, time: String) -> Date? {
        let dateStr = share.formatter.string(from: date)
        let dateCompentArray = dateStr.components(separatedBy: " ")
        if dateCompentArray.count == 2, let firstPart = dateCompentArray.first {
            let newDateStr = firstPart + " " + time
            return share.formatter.date(from: newDateStr)
        }
        return nil
    }
    
    private static func getTodyDateWith(hour: Int) -> Date? {
        var compents = Calendar.current.dateComponents(in: TimeZone.current, from: Date())
        compents.hour = hour
        compents.minute = 0
        compents.second = 0
        compents.nanosecond = 0
        let date = Calendar.current.date(from: compents)
        return date
    }
    
    private static func deleteHistoryEnentWith(_ key: String) {
        if let identifier = self.getHistoryEventIdentifierWith(key) {
            if let event = share.store.event(withIdentifier: identifier) {
                do {
                    try share.store.remove(event, span: .futureEvents)
                    LogInfo("删除历史事件成功")
                }
                catch {
                    LogInfo("删除历史事件失败\(error)")
                }
            }
        }
    }
    
    private static func saveEnentIdentifier(key: String, identifier: String) {
        let userdefault = UserDefaults.standard
        userdefault.setValue(identifier, forKey: key)
        userdefault.synchronize()
    }
    
    private static func getHistoryEventIdentifierWith(_ key: String) -> String? {
        return UserDefaults.standard.value(forKey: key) as? String
    }
}
