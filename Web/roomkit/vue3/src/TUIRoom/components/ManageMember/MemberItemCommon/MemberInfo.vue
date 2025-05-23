<template>
  <!-- User base information -->
  <div :class="[isMobile ? 'member-info-mobile' : 'member-info']">
    <div
      :class="
        !showStateIcon && isTargetUserAdmin
          ? 'member-basic-info-admin'
          : 'member-basic-info'
      "
    >
      <Avatar class="avatar-url" :img-src="userInfo.avatarUrl" />
      <div class="user-name">{{ roomService.getDisplayName(userInfo) }}</div>
      <div class="role-info">
        <svg-icon
          v-if="isTargetUserRoomOwner || isTargetUserAdmin"
          :color="isTargetUserAdmin ? '#F06C4B' : '#4791FF'"
          :class="isTargetUserAdmin ? 'admin-icon' : 'master-icon'"
        >
          <img src="../../../assets/imgs/room_owner.png" style="width: 20px; height: 20px;" />
        </svg-icon>
        <div
          :class="`user-extra-info ${isTargetUserAdmin ? 'user-extra-info-admin' : ''}`"
        >
          {{ extraInfo }}
        </div>
      </div>
    </div>
    <!-- User audio and video status information -->
    <div v-if="showStateIcon" class="member-av-state">
      <svg-icon
        v-for="(item, index) in iconList"
        :key="index"
        :icon="typeof item.icon === 'string' ? undefined : item.icon"
        :class="['state-icon', { 'disable-icon': item.disable }]"
        :size="20"
      >
        <img v-if="item.icon === 'AudioOpenIcon'" src="../../../assets/imgs/room_un_mute_audio.png" style="width: 20px; height: 20px;" />
        <img v-if="item.icon === 'AudioCloseIcon'" src="../../../assets/imgs/room_mute_audio_red.png" style="width: 20px; height: 20px;" />
        <img v-if="item.icon === 'VideoOpenIcon'" src="../../../assets/imgs/room_un_mute_video.png" style="width: 20px; height: 20px;" />
        <img v-if="item.icon === 'VideoCloseIcon'" src="../../../assets/imgs/room_mute_video_red.png" style="width: 20px; height: 20px;" />
        </svg-icon>
    </div>
    <member-invite
      class="member-invite"
      v-show="!props.userInfo.isInRoom"
      :user-info="props.userInfo"
    />
  </div>
</template>
<script setup lang="ts">
import { computed, defineProps } from 'vue';
import Avatar from '../../common/Avatar.vue';
import { useBasicStore } from '../../../stores/basic';
import { UserInfo, useRoomStore } from '../../../stores/room';
import { storeToRefs } from 'pinia';
import SvgIcon from '../../common/base/SvgIcon.vue';
import VideoOpenIcon from '../../common/icons/VideoOpenIcon.vue';
import VideoCloseIcon from '../../common/icons/VideoCloseIcon.vue';
import AudioOpenIcon from '../../common/icons/AudioOpenIcon.vue';
import AudioCloseIcon from '../../common/icons/AudioCloseIcon.vue';
import ScreenOpenIcon from '../../common/icons/ScreenOpenIcon.vue';
import ApplyActiveIcon from '../../common/icons/ApplyActiveIcon.vue';
import MemberInvite from '../MemberInvite/MemberInvite.vue';
import { useI18n } from '../../../locales';
import { isMobile } from '../../../utils/environment';
import UserIcon from '../../common/icons/UserIcon.vue';
import { TUIRole } from '@tencentcloud/tuiroom-engine-js';
import { roomService } from '../../../services';

const { t } = useI18n();

interface Props {
  userInfo: UserInfo;
  showStateIcon: boolean;
}

const props = defineProps<Props>();
const basicStore = useBasicStore();
const roomStore = useRoomStore();
const { isMaster, isSpeakAfterTakingSeatMode } = storeToRefs(roomStore);

const isMe = computed(() => basicStore.userId === props.userInfo.userId);

const isTargetUserRoomOwner = computed(
  () => props.userInfo.userRole === TUIRole.kRoomOwner
);
const isTargetUserAdmin = computed(
  () => props.userInfo.userRole === TUIRole.kAdministrator
);

const extraInfo = computed(() => {
  if (isMaster.value && isMe.value) {
    return `${t('Host')}, ${t('Me')}`;
  }
  if (isTargetUserRoomOwner.value) {
    return t('Host');
  }
  if (isTargetUserAdmin.value && isMe.value) {
    return `${t('Admin')}, ${t('Me')}`;
  }
  if (isTargetUserAdmin.value) {
    return t('Admin');
  }
  if (isMe.value) {
    return t('Me');
  }
  return '';
});

const isAudienceRole = computed(
  () => isSpeakAfterTakingSeatMode.value && !props.userInfo.onSeat
);

const iconList = computed(() => {
  const list = [];
  if (props.userInfo.hasScreenStream) {
    list.push({ icon: ScreenOpenIcon });
  }
  if (!isAudienceRole.value) {
    list.push({
      icon: props.userInfo.hasAudioStream ? 'AudioOpenIcon' : 'AudioCloseIcon',
    });
    list.push({
      icon: props.userInfo.hasVideoStream ? 'VideoOpenIcon' : 'VideoCloseIcon',
    });
  }
  if (isAudienceRole.value && !props.userInfo.isUserApplyingToAnchor) {
    list.push({ icon: 'AudioCloseIcon', disable: true });
    list.push({ icon: 'VideoCloseIcon', disable: true });
  }
//   if (isAudienceRole.value && props.userInfo.isUserApplyingToAnchor) {
//     list.push({ icon: ApplyActiveIcon, size: 20 });
//   }
  return list;
});
</script>

<style lang="scss" scoped>
.member-info,
.member-info-mobile {
  display: flex;
  justify-content: space-between;
  width: 100%;
  height: 100%;

  .member-basic-info,
  .member-basic-info-admin {
    display: flex;
    flex-direction: row;
    align-items: center;

    .avatar-url {
      display: flex;
      align-items: center;
      width: 32px;
      height: 32px;
      border-radius: 50%;
    }

    .user-name {
      max-width: 100px;
      margin-left: 12px;
      overflow: hidden;
      font-size: 14px;
      font-weight: 400;
      line-height: 22px;
      text-overflow: ellipsis;
      white-space: nowrap;
      color: var(--text-color-secondary);
    }

    .role-info {
      display: flex;

      .master-icon,
      .admin-icon {
        display: flex;
        margin-left: 8px;
        color: var(--text-color-link);
      }

      .admin-icon {
        color: var(--text-color-warning);
      }

      .user-extra-info,
      .user-extra-info-admin {
        padding: 2px;
        padding: 0 6px;
        margin-left: 4px;
        font-size: 14px;
        font-weight: 400;
        line-height: 20px;
        color: #00b68f;
      }

      .user-extra-info-admin {
        transition: none;
        color: var(--text-color-warning);
      }
    }
  }

  .member-basic-info-admin {
    .user-name {
      max-width: 40px;
    }
  }

  .member-invite {
    display: flex;
    align-items: center;
    height: 100%;
  }

  .member-av-state {
    display: flex;
    align-items: center;
    height: 100%;
    column-gap: 4px;
    color: var(--icon-color);

    .state-icon .member-invite {
      margin-left: 16px;
    }

    .disable-icon {
      opacity: 0.4;
    }
  }
}

.member-info-mobile {
  align-items: center;
  width: 80vw;
}
</style>
