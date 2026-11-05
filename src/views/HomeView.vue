<script setup lang="ts">
import { onMounted, ref } from 'vue'
import axios from 'axios'

const tasks = ref();
const API_BASE_URL = import.meta.env.VITE_API_BASE_URL;

onMounted(async () => {
  const response = await axios.get(`${API_BASE_URL}/tasks`);
  tasks.value = response.data;
})

</script>

<template>
  <h1>Tasks</h1>
  <ul>
    <li v-for="task in tasks" :key="task.task_id">{{ task.title }}: {{ task.description }}</li>
  </ul>
</template>
