<template>
    <div class="app-container">
        <header class="app-header">
            <h1>My Vue Application</h1>
            <nav>
                <router-link to="/">Home</router-link> |
                <router-link to="/about">About</router-link>
            </nav>
        </header>

        <main>
            <router-view />
        </main>

        <footer class="app-footer">
            <p>&copy; 2023 My Company</p>
        </footer>
    </div>
</template>

<script setup lang="ts">
// App level logic can go here
</script>

<style scoped>
.app-container {
    max-width: 1200px;
    margin: 0 auto;
    padding: 0 20px;
    font-family: Arial, sans-serif;
}

.app-header {
    padding: 20px 0;
    border-bottom: 1px solid #eee;
}

.app-header h1 {
    margin: 0 0 15px 0;
    color: #2c3e50;
}

nav {
    padding: 10px 0;
}

nav a {
    margin-right: 10px;
    color: #2c3e50;
    text-decoration: none;
}

nav a.router-link-active {
    color: #42b983;
    font-weight: bold;
}

main {
    padding: 20px 0;
    min-height: calc(100vh - 200px);
}

.app-footer {
    padding: 20px 0;
    border-top: 1px solid #eee;
    text-align: center;
    color: #666;
}
</style>
