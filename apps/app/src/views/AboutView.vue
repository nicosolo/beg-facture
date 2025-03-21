<template>
    <div class="about-view">
        <h1>About Our Company</h1>

        <section class="company-info">
            <div class="company-description">
                <h2>Our Mission</h2>
                <p>
                    Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam vel justo vel
                    nisi convallis posuere. Integer fringilla tortor ac ligula interdum, in finibus
                    leo cursus. Vivamus feugiat, magna eget congue feugiat, mauris dui ultricies
                    quam, non aliquet nunc libero nec magna.
                </p>

                <h2>Our Story</h2>
                <p>
                    Fusce dictum, odio non pharetra varius, arcu orci dignissim lorem, in sodales
                    magna eros vel nulla. Sed vehicula egestas metus eu efficitur. Donec ultrices
                    risus justo, at bibendum quam feugiat ac. Integer at enim ut leo congue
                    bibendum.
                </p>
            </div>

            <div class="company-stats">
                <div class="stat">
                    <span class="stat-number">2015</span>
                    <span class="stat-label">Founded</span>
                </div>
                <div class="stat">
                    <span class="stat-number">50+</span>
                    <span class="stat-label">Employees</span>
                </div>
                <div class="stat">
                    <span class="stat-number">10k+</span>
                    <span class="stat-label">Customers</span>
                </div>
                <div class="stat">
                    <span class="stat-number">15</span>
                    <span class="stat-label">Countries</span>
                </div>
            </div>
        </section>

        <section class="team">
            <h2>Our Team</h2>
            <div class="team-members">
                <div class="team-member">
                    <div class="member-photo placeholder"></div>
                    <h3>John Doe</h3>
                    <p>CEO & Founder</p>
                </div>
                <div class="team-member">
                    <div class="member-photo placeholder"></div>
                    <h3>Jane Smith</h3>
                    <p>CTO</p>
                </div>
                <div class="team-member">
                    <div class="member-photo placeholder"></div>
                    <h3>Michael Johnson</h3>
                    <p>Head of Design</p>
                </div>
            </div>
        </section>
    </div>
</template>

<script setup lang="ts">
// About view component logic
</script>

<style scoped>
.about-view {
    padding: 20px 0;
}

h1 {
    margin-bottom: 30px;
    color: #2c3e50;
    text-align: center;
}

.company-info {
    display: grid;
    grid-template-columns: 3fr 1fr;
    gap: 40px;
    margin-bottom: 50px;
}

@media (max-width: 768px) {
    .company-info {
        grid-template-columns: 1fr;
    }
}

.company-description h2 {
    color: #42b983;
    margin-top: 0;
    margin-bottom: 15px;
}

.company-description p {
    margin-bottom: 30px;
    line-height: 1.6;
}

.company-stats {
    display: grid;
    grid-template-columns: repeat(2, 1fr);
    gap: 20px;
    padding: 20px;
    background-color: #f8f9fa;
    border-radius: 8px;
    height: fit-content;
}

.stat {
    text-align: center;
    padding: 15px;
}

.stat-number {
    display: block;
    font-size: 24px;
    font-weight: bold;
    color: #42b983;
}

.stat-label {
    display: block;
    font-size: 14px;
    color: #666;
}

.team {
    margin-top: 40px;
}

.team h2 {
    text-align: center;
    margin-bottom: 30px;
    color: #2c3e50;
}

.team-members {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
    gap: 30px;
}

.team-member {
    text-align: center;
    padding: 20px;
    border-radius: 8px;
    background-color: #f8f9fa;
    box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
}

.member-photo.placeholder {
    width: 120px;
    height: 120px;
    background-color: #ddd;
    border-radius: 50%;
    margin: 0 auto 15px;
}

.team-member h3 {
    margin: 0 0 5px;
    color: #2c3e50;
}

.team-member p {
    margin: 0;
    color: #666;
}
</style>
