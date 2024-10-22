<template>
    <div id="edit-profile" class="bg-frame rounded-xl p-5 w-[100%] flex justify-center flex-col">
        <h2>Profile</h2>
        <div class="flex flex-col items-center">
            <label for="username">Username:</label>
            <input type="text" id="username" name="username">
            <label for="email">Email:</label>
            <input type="email" id="email" name="email">
            <label for="password">Password:</label>
            <input type="password" id="password" name="password">
            <button @click="" class="rounded-lg border-2 border-secondary bg-transparent mt-2 w-fit">Submit</button>
        </div>
    </div>
</template>

<script>
export default {
    name: 'EditProfile',
    data() {
        return {
        };
    },
    methods: {
    },
    computed: {
    },
    mounted() {
    }
};
</script>

<style scoped>
</style>