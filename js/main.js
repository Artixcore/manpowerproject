// Complete JavaScript for Maali Hermes Website Clone

(function() {
    'use strict';

    // Wait for DOM to be fully loaded
    document.addEventListener('DOMContentLoaded', function() {
        
        // ============================================
        // Initialize Carousel
        // ============================================
        const heroCarousel = document.querySelector('#heroCarousel');
        if (heroCarousel) {
            const carousel = new bootstrap.Carousel(heroCarousel, {
                interval: 5000,
                wrap: true,
                pause: 'hover'
            });
        }

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
                    
                    // Calculate offset (header height + some padding)
                    const headerHeight = document.querySelector('.header-area').offsetHeight;
                    const offsetTop = target.offsetTop - headerHeight;
                    
                    window.scrollTo({
                        top: offsetTop,
                        behavior: 'smooth'
                    });
                    
                    // Close mobile menu if open
                    const navbarCollapse = document.querySelector('.navbar-collapse');
                    if (navbarCollapse && navbarCollapse.classList.contains('show')) {
                        const bsCollapse = bootstrap.Collapse.getInstance(navbarCollapse);
                        if (bsCollapse) {
                            bsCollapse.hide();
                        }
                    }
                    
                    // Update active nav link
                    updateActiveNavLink(href);
                }
            });
        });

        // ============================================
        // Sticky Header with Scroll Effect
        // ============================================
        const headerArea = document.querySelector('.header-area');
        let lastScroll = 0;
        const scrollThreshold = 50;

        window.addEventListener('scroll', function() {
            const currentScroll = window.pageYOffset || document.documentElement.scrollTop;
            
            if (currentScroll > scrollThreshold) {
                headerArea.classList.add('scrolled');
            } else {
                headerArea.classList.remove('scrolled');
            }
            
            lastScroll = currentScroll;
        }, { passive: true });

        // ============================================
        // Update Active Navigation Link on Scroll
        // ============================================
        function updateActiveNavLink(hash) {
            // Remove active class from all nav links
            document.querySelectorAll('.nav-link').forEach(link => {
                link.classList.remove('active');
            });
            
            // Add active class to current link
            const activeLink = document.querySelector(`.nav-link[href="${hash}"]`);
            if (activeLink) {
                activeLink.classList.add('active');
            }
        }

        // Update active nav on scroll
        const sections = document.querySelectorAll('section[id]');
        const navLinks = document.querySelectorAll('.nav-link[href^="#"]');
        
        function updateActiveNavOnScroll() {
            const scrollPosition = window.pageYOffset + 150;
            
            sections.forEach(section => {
                const sectionTop = section.offsetTop;
                const sectionHeight = section.offsetHeight;
                const sectionId = section.getAttribute('id');
                
                if (scrollPosition >= sectionTop && scrollPosition < sectionTop + sectionHeight) {
                    navLinks.forEach(link => {
                        link.classList.remove('active');
                        if (link.getAttribute('href') === `#${sectionId}`) {
                            link.classList.add('active');
                        }
                    });
                }
            });
        }

        window.addEventListener('scroll', updateActiveNavOnScroll, { passive: true });

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

        // Observe service cards and value cards
        document.querySelectorAll('.service-card, .value-card').forEach(card => {
            fadeInObserver.observe(card);
        });

        // ============================================
        // Mobile Menu Close on Link Click
        // ============================================
        const mobileMenuLinks = document.querySelectorAll('.navbar-nav .nav-link, .dropdown-item');
        const navbarCollapse = document.querySelector('.navbar-collapse');
        
        mobileMenuLinks.forEach(link => {
            link.addEventListener('click', function() {
                if (window.innerWidth < 992) {
                    const bsCollapse = bootstrap.Collapse.getInstance(navbarCollapse);
                    if (bsCollapse && navbarCollapse.classList.contains('show')) {
                        bsCollapse.hide();
                    }
                }
            });
        });

        // ============================================
        // Handle Window Resize
        // ============================================
        let resizeTimer;
        window.addEventListener('resize', function() {
            clearTimeout(resizeTimer);
            resizeTimer = setTimeout(function() {
                // Recalculate heights if needed
                updateCarouselHeight();
            }, 250);
        });

        // ============================================
        // Update Carousel Height on Load/Resize
        // ============================================
        function updateCarouselHeight() {
            const carousel = document.querySelector('.hero-slider-section .carousel');
            if (carousel) {
                if (window.innerWidth < 768) {
                    carousel.style.minHeight = '400px';
                } else {
                    carousel.style.minHeight = '600px';
                }
            }
        }

        // Initial carousel height setup
        updateCarouselHeight();

        // ============================================
        // Gallery Image Lazy Loading (if needed)
        // ============================================
        if ('loading' in HTMLImageElement.prototype) {
            const images = document.querySelectorAll('.gallery-item img');
            images.forEach(img => {
                img.loading = 'lazy';
            });
        } else {
            // Fallback for browsers that don't support lazy loading
            const imageObserver = new IntersectionObserver((entries, observer) => {
                entries.forEach(entry => {
                    if (entry.isIntersecting) {
                        const img = entry.target;
                        img.src = img.dataset.src || img.src;
                        observer.unobserve(img);
                    }
                });
            });

            document.querySelectorAll('.gallery-item img').forEach(img => {
                imageObserver.observe(img);
            });
        }

        // ============================================
        // Prevent Default for Dropdown Links
        // ============================================
        document.querySelectorAll('.dropdown-item').forEach(item => {
            item.addEventListener('click', function(e) {
                const href = this.getAttribute('href');
                if (href && href.startsWith('#')) {
                    // Let smooth scroll handle it
                    return;
                }
            });
        });

        // ============================================
        // Add Loading State (Optional)
        // ============================================
        window.addEventListener('load', function() {
            document.body.classList.add('loaded');
        });

        // ============================================
        // Console Log (for debugging - remove in production)
        // ============================================
        console.log('Maali Hermes Website - JavaScript Loaded Successfully');
    });

})();
