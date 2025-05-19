<template>
  <div class="footer-container">
    <manage-member-control
      v-tap="() => handleControlClick('manageMemberControl')"
    />
    <audio-control
      v-if="!isAudience || isAdmin"
      :display-mode="MediaSettingDisplayMode.Icon"
      v-tap="() => handleControlClick('audioControl')"
    />
    <video-setting
      v-if="!isAudience || isAdmin"
      :display-mode="MediaSettingDisplayMode.Icon"
      v-tap="() => handleControlClick('videoControl')"
    />
    <!-- <icon-button
      :is-active="false"
      title="共享屏幕"
    >
        <img src="@/assets/images/icon-screen.png" style="width: 24px; height: 24px;" />
    </icon-button> -->
    <chat-control
      v-tap="() => handleControlClick('chatControl')"
    />
    <master-apply-control
      v-if="roomStore.isSpeakAfterTakingSeatMode && (isMaster || isAdmin)"
      v-tap="() => handleControlClick('MasterApplyControl')"
    />
    <member-apply-control
      v-if="roomStore.isSpeakAfterTakingSeatMode && !isMaster"
      v-tap="() => handleControlClick('MemberApplyControl')"
    />
    <!-- <icon-button
      :is-active="true"
      title="邀请"
      @click-icon="() => emit('show-info')"
    >
        <img src="@/assets/images/room_invite.png" style="width: 24px; height: 24px;" />
    </icon-button> -->
    <!-- <more-control
      v-tap="() => handleControlClick('moreControl')"
      @show-overlay="handleShowOverlay"
    /> -->
  </div>
</template>
<script setup lang="ts">
import { defineEmits } from 'vue';
import {
  AudioSetting,
  VideoSetting,
  MediaSettingDisplayMode,
} from '../../../core';
import ManageMemberControl from '../ManageMemberControl.vue';
import ChatControl from '../ChatControl.vue';
import MasterApplyControl from '../ManageStageControl.vue';
import MemberApplyControl from '../ApplyControl/MemberApplyControl.vue';
import MoreControl from '../MoreControl/index';
import bus from '../../../hooks/useMitt';
import vTap from '../../../directives/vTap';

import useRoomFooter from './useRoomFooterHooks';

const { roomStore, isMaster, isAdmin, isAudience } = useRoomFooter();


const emit = defineEmits(['show-overlay', 'click', 'show-info']);

function handleControlClick(name: string) {
  bus.emit('experience-communication', name);
}

function handleShowOverlay(data: { name: string; visible: boolean }) {
  emit('show-overlay', data);
}

function handleTouchStart() {
  emit('click');
}

</script>

<style lang="scss" scoped>
.footer-container {
  position: absolute;
  bottom: 0;
  display: flex;
  flex-flow: row wrap;
  align-items: center;
  justify-content: space-between;
  width: 100%;
  padding: 0.7rem;
  background-color: var(--bg-color-topbar);
  box-shadow: 0 -8px 30px var(--uikit-color-black-8);
}
</style>
