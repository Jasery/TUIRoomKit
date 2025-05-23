//
//  UserEntity.swift
//  TUIRoomKit
//
//  Created by WesleyLei on 2022/9/26.
//  Copyright © 2022 Tencent. All rights reserved.
//

import Foundation
import RTCRoomEngine

class UserEntity {
    var userId: String = ""
    var userName: String = ""
    var avatarUrl: String = ""
    var userRole: TUIRole = .generalUser
    var userVoiceVolume: Int = 0
    var hasAudioStream: Bool = false
    var hasVideoStream: Bool = false
    var videoStreamType: TUIVideoStreamType = .cameraStream
    var isOnSeat: Bool = false
    var disableSendingMessage: Bool = false
    var hasScreenStream: Bool = false
    func update(userInfo: TUIUserInfo) {
        userId = userInfo.userId
        userName = userInfo.nameCard.isEmpty ? userInfo.userName : userInfo.nameCard
        avatarUrl = userInfo.avatarUrl
        userRole = userInfo.userRole
        hasAudioStream = userInfo.hasAudioStream
        hasVideoStream = userInfo.hasVideoStream
        hasScreenStream = userInfo.hasScreenStream
    }
    
    init(){}
    
    init(invitation: TUIInvitation) {
        self.userId = invitation.invitee.userId
        self.userName = invitation.invitee.userName
        self.avatarUrl = invitation.invitee.avatarUrl
    }
    
    deinit {
        debugPrint("deinit \(self)")
    }
}
