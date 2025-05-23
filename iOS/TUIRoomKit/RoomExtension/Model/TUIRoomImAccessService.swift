//
//  TUIRoomImAccessService.swift
//  TUIRoomKit
//
//  Created by janejntang on 2023/6/2.
//

import Foundation
import TUICore

class TUIRoomImAccessService: NSObject, TUIServiceProtocol  {
    static let shared = TUIRoomImAccessService()
    var isShownInvitedToJoinRoomView: Bool = false
    weak var inviteViewController: UIViewController?
    var inviteWindow: UIWindow?
    private override init() {
        super.init()
        initRoomMessage()
        initSignalingListener()
        initThemeResource()
    }
    func initRoomMessage() {
        TUICore.callService(TUICore_TUIChatService, method: TUICore_TUIChatService_AppendCustomMessageMethod, param:
                                [BussinessID: BussinessID_GroupRoomMessage, TMessageCell_Name: "RoomMessageBubbleCell",
                      TMessageCell_Data_Name:"RoomMessageBubbleCellData",])
    }
    func initSignalingListener() {
        V2TIMManager.sharedInstance().addSignalingListener(listener: self)
    }
    func initThemeResource() {
        TUICoreThemeConvert.initThemeResource()
    }
}

extension TUIRoomImAccessService: V2TIMSignalingListener {
    func onReceiveNewInvitation(inviteID: String, inviter: String?, groupID: String?, inviteeList: [String], data: String?) {
        guard let data = data else { return }
        let dict = data.convertToDic()
        guard let businessID = dict?["businessID"] as? String else { return }
        guard businessID == "ROOM_INVITE_ACTION" else { return }
        guard let roomId = dict?["roomId"] as? String else { return }
        guard let userId = TUILogin.getUserID() else { return }
        let dataDic = dict?["data"] as? NSDictionary ?? [:]
        let inviter = dataDic["inviter"] as? NSDictionary ?? [:]
        let avatarUrl = inviter["avatarUrl"] as? String ?? ""
        let inviterUserName = inviter["userName"] as? String ?? ""
        guard inviteeList.contains(userId) else { return }
            let businessScene = TUILogin.getCurrentBusinessScene()
            guard businessScene == .None || businessScene == .InMeetingRoom else { return }
            showInvitedToJoinRoomView(inviterUserName: inviterUserName, inviteUserAvatarUrl: avatarUrl, roomId: roomId)
    }
    private func showInvitedToJoinRoomView(inviterUserName: String, inviteUserAvatarUrl: String, roomId: String) {
        if isShownInvitedToJoinRoomView {
            return
        }
        isShownInvitedToJoinRoomView = true
        let inviteViewController = InvitedToJoinRoomViewController(inviteUserName: inviterUserName,inviteUserAvatarUrl:
                                                                    inviteUserAvatarUrl, roomId: roomId)
        let nav = UINavigationController(rootViewController: inviteViewController)
        nav.setNavigationBarHidden(true, animated: true)
        inviteWindow = UIWindow(frame: UIScreen.main.bounds)
        inviteWindow?.windowLevel = .alert - 1
        guard let inviteWindow = inviteWindow else { return }
        inviteWindow.rootViewController = nav
        inviteWindow.isHidden = false
        inviteWindow.makeKeyAndVisible()
    }
}
