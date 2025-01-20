<template>
  <div class="header">
    <div class="header-container">
      <div class="icon-box">
        <switch-camera :style="{ visibility: localUser.hasVideoStream ? 'visible' : 'hidden' }"/>
        <switch-mirror :style="{ visibility: localUser.hasVideoStream ? 'visible' : 'hidden' }"/>
        <switch-audio-route v-if="isWeChat" />
      </div>
      <room-info class="room-info" ref="roomInfoRef" @show-room-info="emit('show-room-info', $event)" @copy-room-link="emit('copy-room-link', $event)"/>
      <end-control />
    </div>
    <switch-theme :visible="false" />
  </div>
</template>
<script setup lang="ts">
import EndControl from '../../RoomFooter/EndControl';
import SwitchCamera from './SwitchCamera.vue';
import SwitchMirror from './SwitchMirror.vue';
import SwitchAudioRoute from './SwitchAudioRoute.vue';
import RoomInfo from '../RoomInfo';
import SwitchTheme from '../../common/SwitchTheme.vue';
import { isWeChat } from '../../../utils/environment';
import { storeToRefs } from 'pinia';
import { useRoomStore } from '../../../stores/room';
import { ref } from 'vue';

const roomStore = useRoomStore();
const emit = defineEmits(['click', 'show-room-info', 'copy-room-link']);

const roomInfoRef = ref();

const {
  localUser,
} = storeToRefs(roomStore);

defineExpose({
    showRoomInfo() {
        roomInfoRef.value.toggleShowRoomInfoStatus();
    }
})

</script>
<style scoped>
.header {
  height: 100%;
}

.header-container {
  display: flex;
  align-items: center;
  justify-content: space-between;
  height: 100%;
  padding: 0 12px;
}

.icon-box {
  display: flex;
  gap: 5px;
  align-items: center;
}

.room-info {
  overflow: auto;
}
</style>
