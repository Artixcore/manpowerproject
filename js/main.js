// Maali Hermes PROFILE PDF Clone - JavaScript

(function() {
    'use strict';

    // Wait for DOM to be fully loaded
    document.addEventListener('DOMContentLoaded', function() {
        
        // ============================================
        // Smooth Scrolling for Anchor Links
        // ============================================
        document.querySelectorAll('a[href^="#"]').forEach(anchor => {
            anchor.addEventListener('click', function(e) {
                const href = this.getAttribute('href');
                
                // Skip if it's just "#" or empty
                if (href === '#' || href === '') {
                    return;
                }
                
                const target = document.querySelector(href);
                if (target) {
                    e.preventDefault();
                    
                    // Calculate offset (for fixed headers if any)
                    const offsetTop = target.offsetTop - 20;
                    
                    window.scrollTo({
                        top: offsetTop,
                        behavior: 'smooth'
                    });
                }
            });
        });

        // ============================================
        // Intersection Observer for Fade-in Animations
        // ============================================
        const observerOptions = {
            threshold: 0.1,
            rootMargin: '0px 0px -50px 0px'
        };

        const fadeInObserver = new IntersectionObserver(function(entries) {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    entry.target.classList.add('fade-in');
                    // Unobserve after animation to improve performance
                    fadeInObserver.unobserve(entry.target);
                }
            });
        }, observerOptions);

        // Observe cards and sections
        document.querySelectorAll('.organogram-card, .value-card, .vision-box, .mission-box').forEach(element => {
            fadeInObserver.observe(element);
        });

        // ============================================
        // Add fade-in animation CSS dynamically
        // ============================================
        const style = document.createElement('style');
        style.textContent = `
            .organogram-card,
            .value-card,
            .vision-box,
            .mission-box {
                opacity: 0;
                transform: translateY(20px);
                transition: opacity 0.6s ease, transform 0.6s ease;
            }
            
            .organogram-card.fade-in,
            .value-card.fade-in,
            .vision-box.fade-in,
            .mission-box.fade-in {
                opacity: 1;
                transform: translateY(0);
            }
        `;
        document.head.appendChild(style);

        // ============================================
        // Handle Window Resize
        // ============================================
        let resizeTimer;
        window.addEventListener('resize', function() {
            clearTimeout(resizeTimer);
            resizeTimer = setTimeout(function() {
                // Recalculate layouts if needed
                console.log('Window resized');
            }, 250);
        });

        // ============================================
        // Console Log (for debugging)
        // ============================================
        console.log('Maali Hermes PROFILE - JavaScript Loaded Successfully');
    });

})();
