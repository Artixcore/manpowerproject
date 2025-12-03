// Eastern Top Companys Website - Complete JavaScript

(function() {
    'use strict';

    // ============================================
    // Translation System
    // ============================================
    const translations = {
        ar: {
            // Navigation
            'nav-home': 'الرئيسية',
            'nav-about': 'من نحن',
            'nav-services': 'الخدمات',
            'nav-management': 'الإدارة',
            'nav-values': 'قيمنا',
            'nav-personnel': 'الأفراد',
            'nav-clients': 'العملاء',
            'nav-gallery': 'المعرض',
            'nav-contact': 'اتصل بنا',
            'btn-quote': 'احصل على عرض سعر',
            'logo-subtitle': 'مقاولات عامة',
            
            // Top Bar
            'topbar-call': 'اتصل بنا:',
            'topbar-email': 'البريد الإلكتروني:',
            
            // Hero Section
            'hero-label-1': 'توفير العمالة',
            'hero-title-1': 'مصدرك الموثوق للعمالة الموثوقة',
            'hero-label-2': 'تأجير المعدات',
            'hero-title-2': 'معدات ثقيلة لاحتياجات البناء الخاصة بك',
            'carousel-prev': 'السابق',
            'carousel-next': 'التالي',
            
            // Introduction
            'intro-title': 'مقدمة',
            'intro-p1': 'شركة إيسترن توب كومبانيز هي <strong>شركة سعودية 100%</strong> مسجلة في الوزارة وغرفة التجارة رقم السجل التجاري: 7051448806.',
            'intro-p2': 'نحن متخصصون في مجال الإنشاءات الصناعية والتجارية: المدنية، الميكانيكية، الكهروميكانيكية، أنظمة التكييف والتهوية.',
            'intro-p3': 'نحن نتعامل مع جميع أنواع المشاريع المتكاملة.',
            'intro-p4': 'الشركة يديرها فريق إداري مع التركيز الواضح على المسؤولية الفردية ومستوى عالٍ من الخبرة.',
            'intro-p5': 'أشخاص مؤهلون وذوو خبرة يديرون التقدير، الإدارة الهندسية، تخطيط الإنشاءات، مراقبة جودة السلامة، ضمان الجودة والتحكم في التكاليف للمشاريع.',
            'intro-p6': 'نتطلع إلى إقامة علاقات تجارية طويلة الأمد مع جميع عملائنا الكرام.',
            
            // About Us
            'about-title': 'من نحن',
            'about-p1': 'يسعدنا أن نقدم لكم <strong>شركة إيسترن توب كومبانيز</strong>، رائدة في الإنشاءات الصناعية والتجارية.',
            'about-p2': 'نحن شركة مقاولات رائدة في المملكة العربية السعودية.',
            'about-p3': 'نحن نتعامل مع جميع أنواع الإنشاءات الصناعية والتجارية منذ عام 1970.',
            'about-p4': 'أضافت شركة إيسترن توب كومبانيز إلى إنجازاتها بعض الإنشاءات الصناعية والتجارية.',
            'about-p5': 'نوفر خدمات المقاولات ونقوم بمشاريع تجارية وصناعية أيضاً.',
            'about-p6': 'نؤمن باستخدام التقنيات المحدثة وضمان السلامة عند تصميم خطط المشاريع.',
            'about-p7': 'نقدر العمل معكم ونتطلع إلى مشاريع مستقبلية.',
            
            // Management
            'management-title': 'الهيكل الإداري',
            'management-subtitle': 'الرسم التنظيمي للشركة',
            'role-president': 'الرئيس',
            'role-gm': 'المدير العام',
            'role-om': 'مدير العمليات',
            'role-bdm': 'مدير تطوير الأعمال',
            'role-bc': 'منسق الأعمال',
            
            // Vision & Mission
            'vision-title': 'الرؤية والرسالة',
            'vision-heading': 'رؤيتنا',
            'vision-text': '"أن نصبح شركة هندسة وإنشاءات صناعية عالمية المستوى تعمل بشكل عملياتي."',
            'mission-heading': 'الرسالة',
            'mission-text': '"تقديم حلول عالية الجودة وفعالة من حيث التكلفة وموثوقة لعملائنا ومقاول EPC محلي وتصنيع النباتات والمعدات في المملكة."',
            'policy-heading': 'سياستنا',
            'policy-text': 'تلتزم شركة إيسترن توب كومبانيز بتقديم خدمات عالية الجودة للعملاء من خلال معالجة الاحتياجات والتوقعات، وتقديم حلول إبداعية، وأسعار تنافسية، والإنجاز في الوقت المحدد، والوفاء الكامل بمتطلبات العملاء.',
            
            // Values
            'values-title': 'قيمنا',
            'values-desc': 'في <strong>شركة إيسترن توب كومبانيز</strong>، نحافظ على القيم التالية:',
            'value-integrity-title': 'النزاهة',
            'value-integrity-text': 'نحافظ على أعلى المعايير الأخلاقية في جميع تعاملاتنا.',
            'value-teamwork-title': 'العمل الجماعي',
            'value-teamwork-text': 'نعزز بيئة تعاونية حيث يعمل الجميع معاً لتحقيق أهداف مشتركة.',
            'value-customer-title': 'التركيز على العملاء',
            'value-customer-text': 'نحن ملتزمون بفهم وتلبية احتياجات عملائنا.',
            'value-quality-title': 'الجودة',
            'value-quality-text': 'نسعى للتميز في كل ما نقوم به.',
            
            // Services
            'services-title': 'الخدمات المقدمة',
            'service-1': 'توفير العمالة وتأجير المعدات',
            'service-1-desc': 'خدمات شاملة لتوفير العمالة وتأجير المعدات الثقيلة لمشاريع الإنشاءات الصناعية والتجارية.',
            'service-2': 'قسم توريد المواد',
            'service-2-desc': 'خدمات توريد مواد موثوقة تضمن مواد عالية الجودة لجميع مشاريع الإنشاءات والصناعية.',
            'service-3': 'نظام الدعم الفني',
            'service-3-desc': 'خدمات الدعم الفني والاستشارات المتخصصة لجميع احتياجات الإنشاءات والهندسة الخاصة بك.',
            'service-4': 'قسم التجارة الصناعية',
            'service-4-desc': 'خدمات تجارية صناعية شاملة توفر منتجات وحلول عالية الجودة للمشاريع الصناعية.',
            'service-5': 'تصنيع الصلب الإنشائي',
            'service-5-desc': 'خدمات تصنيع الصلب الإنشائي المتخصصة لمشاريع الإنشاءات الصناعية والتجارية.',
            
            // Personnel
            'personnel-title': 'أفراد الإنشاءات',
            'personnel-desc': 'القوى العاملة الحالية - قابلة للتغيير',
            'table-role': 'الدور',
            'table-count': 'العدد',
            'role-admin': 'الموظفون الإداريون',
            'role-eng-mech': 'المهندسون (ميكانيكي)',
            'role-eng-civil': 'المهندسون (مدني)',
            'role-eng-elec': 'المهندسون (كهربائي)',
            'role-draftsman': 'رسام أوتوكاد',
            'role-fm-mech': 'رئيس العمال العام (ميكانيكي)',
            'role-fm-civil': 'رئيس العمال العام (مدني)',
            'role-fm-elec': 'رئيس العمال العام (كهربائي)',
            'role-inst-tech': 'فني الأدوات',
            'role-inst-fit': 'معد الأدوات',
            'role-laminator': 'مطلي',
            'role-fabricator': 'صانع',
            'role-welder': 'لحام',
            'role-pipe-fit': 'معد الأنابيب',
            'role-mech-fit': 'معد ميكانيكي',
            'role-painter': 'رسام',
            'role-mason': 'بناء',
            'role-carpenter': 'نجار',
            'role-steel-fix': 'مثبت الصلب',
            'role-plumber': 'سباك',
            'role-electrician': 'كهربائي',
            'role-hvac': 'فني تكييف وتهوية',
            'role-helper': 'مساعد',
            'role-driver': 'سائق',
            
            // Principles
            'principles-title': 'المبادئ الأساسية',
            'principles-heading': 'التميز في الهندسة والإنشاءات',
            'principle-1': 'خدمة متميزة وفهم تقني تقدمي وقدرات.',
            'principle-2': 'قيم استثنائية للصحة والرفاهية.',
            'principle-3': 'الوضوح، المسؤولية، والضبط في جميع المناطق الأساسية.',
            'principle-4': 'تقدير وتكريم الموظفين وضمان النمو المستمر.',
            
            // Civil Construction
            'civil-title': 'الإنشاءات المدنية الصناعية',
            'civil-p1': 'سجل حافل يشمل مشاريع صناعية رئيسية ومتعددة التخصصات:',
            'civil-p2': 'محطات تحلية المياه، محطات الطاقة، منشآت البتروكيماويات والغاز، مصانع الأسمنت، منشآت المرافق، محطات كهربائية عالية التوتر.',
            'civil-services-heading': 'الخدمات',
            'civil-s1': 'إنشاءات الخرسانة المسلحة',
            'civil-s2': 'تركيب المباني الفولاذية المصممة مسبقاً',
            'civil-s3': 'إنشاءات الخرسانة سابقة الصب / التركيب',
            'civil-s4': 'التشطيب الداخلي / التأثيث',
            'civil-s5': 'أعمال الحفر',
            'civil-s6': 'تركيب الأسوار',
            'civil-s7': 'عمليات الرصف',
            'civil-s8': 'الإنشاءات الميكانيكية + المرافق تحت الأرض',
            'civil-s9': 'الهندسة المدنية / الموقع',
            
            // Electrical Construction
            'electrical-title': 'محطة الإنشاءات الكهربائية',
            'electrical-p1': 'يشمل:',
            'electrical-s1': 'تركيب لوحات الميدان، صناديق التوصيل، مفاتيح الحد، أزرار الضغط',
            'electrical-s2': 'صواني الكابلات والقنوات',
            'electrical-s3': 'مركز تحكم المحرك MV/LV، لوحات PLC/DCS',
            'electrical-s4': 'أنظمة الاتصالات الصناعية',
            'electrical-s5': 'الطاقة والإضاءة للمجمعات الصناعية/التجارية',
            'electrical-s6': 'إنشاء فتحات التفتيش، قنوات الكابلات، الحفر',
            'electrical-s7': 'إضاءة الطرق والمناطق، الكابلات المدفونة والجوية',
            'electrical-s8': 'التأريض والحماية من الصواعق',
            'electrical-s9': 'معدات الحماية الكاثودية (الاختبار، التشغيل)',
            'electrical-s10': 'خدمات صيانة المصنع (قصيرة وطويلة الأجل) عبر التخصصات المدنية والكهربائية والميكانيكية',
            
            // Projects
            'projects-title': 'المشاريع',
            'project-1-title': 'الأعمال الكهربائية',
            'project-1-desc': 'خدمات شاملة للإنشاءات والتركيبات الكهربائية.',
            'project-2-title': 'مشروع الإنشاءات – الدمام',
            'project-2-desc': 'مشاريع إنشاءات رئيسية في منطقة الدمام.',
            'project-3-title': 'مشروع الإنشاءات – الجبيل',
            'project-3-desc': 'مشاريع إنشاءات صناعية وتجارية في الجبيل.',
            'project-4-title': 'مشروع الإنشاءات – الجبيل، المنطقة الصناعية الداعمة',
            'project-4-desc': 'مشاريع إنشاءات المنطقة الصناعية الداعمة في الجبيل.',
            
            // Equipment
            'equipment-title': 'موارد المعدات',
            'equipment-desc': 'نحافظ على أسطول شامل من معدات البناء الحديثة لدعم مشاريعنا.',
            
            // Clients
            'clients-title': 'العملاء الرئيسيون',
            
            // Scrap Business
            'scrap-title': 'تجارة الخردة المعدنية',
            'scrap-p1': 'نتعامل مع أنواع مختلفة من الخردة المعدنية بما في ذلك:',
            'scrap-1': 'خردة النحاس',
            'scrap-2': 'خردة الصلب',
            'scrap-3': 'خردة صناعية مختلطة',
            
            // Gallery
            'gallery-title': 'معرض الصور',
            'gallery-desc': 'عرض مشاريعنا وإنجازاتنا',
            'gallery-modal-title': 'معرض المشاريع',
            
            // Contact
            'contact-title': 'اتصل بنا',
            'contact-desc': 'تواصل معنا لاحتياجات الإنشاءات الخاصة بك',
            'contact-address-title': 'العنوان',
            'contact-phone-title': 'الهاتف',
            'contact-email-title': 'البريد الإلكتروني',
            'contact-website-title': 'الموقع الإلكتروني',
            'contact-reg-title': 'التسجيل',
            
            // Footer
            'footer-about': 'شركة سعودية 100% • رائدة في الإنشاءات الصناعية والتجارية منذ عام 1970. مسجلة في الوزارة وغرفة التجارة رقم السجل التجاري: 7051448806.',
            'footer-quick-links': 'روابط سريعة',
            'footer-services': 'الخدمات',
            'footer-contact': 'اتصل بنا',
            'footer-copyright': 'حقوق النشر ©2025 شركة إيسترن توب كومبانيز. جميع الحقوق محفوظة.'
        },
        en: {
            // English translations (original text)
            'nav-home': 'Home',
            'nav-about': 'About Us',
            'nav-services': 'Services',
            'nav-management': 'Management',
            'nav-values': 'Values',
            'nav-personnel': 'Personnel',
            'nav-clients': 'Clients',
            'nav-gallery': 'Gallery',
            'nav-contact': 'Contact Us',
            'btn-quote': 'GET A QUOTE',
            'logo-subtitle': 'General Contracting Est',
            'topbar-call': 'Call Us:',
            'topbar-email': 'Email:',
            'hero-label-1': 'MANPOWER SUPPLY',
            'hero-title-1': 'Your Trusted Source for Reliable Manpower',
            'hero-label-2': 'EQUIPMENT RENTAL',
            'hero-title-2': 'Heavy Equipment for Your Construction Needs',
            'carousel-prev': 'Previous',
            'carousel-next': 'Next',
            'intro-title': 'Introduction',
            'intro-p1': 'Eastern Top Companys is a <strong>100% Saudi Arabia Company</strong> Registered with ministry and chamber of commerce Commercial Reg. No: 7051448806 <strong></strong>.',
            'intro-p2': 'We are specialized in the field of industrial and commercial constructions: civil, mechanical, electro mechanical, HVAC System.',
            'intro-p3': 'We are handling all types of turnkey projects.',
            'intro-p4': 'The company is controlled by management team with a clear focus on individual responsibility and high level of expertise.',
            'intro-p5': 'Qualified and experienced persons manage estimation, engineering management, planning constructions, safety quality control, quality assurance and cost control of projects.',
            'intro-p6': 'We look forward to having long-standing business relationships with all our esteemed customers.',
            'about-title': 'About Us',
            'about-p1': 'We are pleased to introduce you <strong>Eastern Top Companys</strong>, a pioneer in industrial and commercial construction.',
            'about-p2': 'We are a leading contracting company in Saudi Arabia.',
            'about-p3': 'We handle all types of industrial and commercial construction since 1970.',
            'about-p4': 'Eastern Top Companys has added to its achievements some of the industrial and commercial construction.',
            'about-p5': 'We provide contracting services and undertake commercial and industrial ventures as well.',
            'about-p6': 'We believe in using updated technologies and ensuring safety when designing venture plans.',
            'about-p7': 'We appreciate working with you and look forward to future ventures.',
            'management-title': 'Management Structure',
            'management-subtitle': 'Company Organogram',
            'role-president': 'PRESIDENT',
            'role-gm': 'GENERAL MANAGER',
            'role-om': 'OPERATION MANAGER',
            'role-bdm': 'BUSINESS DEVELOPMENT MANAGER',
            'role-bc': 'BUSINESS COORDINATOR',
            'vision-title': 'Vision & Mission',
            'vision-heading': 'Our Vision',
            'vision-text': '"To become a world-class industrial engineering and construction company operating operationally."',
            'mission-heading': 'Mission',
            'mission-text': '"To provide our customer with quality, cost-effective and reliable solutions and an EPC contractor at home and manufacture of plants and equipment in the kingdom."',
            'policy-heading': 'Our Policy',
            'policy-text': 'Eastern Top Companys is committed to provide quality services to customers by addressing needs and expectations, providing creative solutions, competitive pricing, timely completion, and full fulfillment of customer requirements.',
            'values-title': 'Our Values',
            'values-desc': 'At <strong>Eastern Top Companys</strong>, we uphold the following values:',
            'value-integrity-title': 'Integrity',
            'value-integrity-text': 'We uphold the highest ethical standards in all our dealings.',
            'value-teamwork-title': 'Teamwork',
            'value-teamwork-text': 'We foster a collaborative environment where everyone works together to achieve common goals.',
            'value-customer-title': 'Customer Focus',
            'value-customer-text': 'We are dedicated to understanding and meeting our clients\' needs.',
            'value-quality-title': 'Quality',
            'value-quality-text': 'We strive for excellence in everything we do.',
            'services-title': 'Services Offered',
            'service-1': 'Manpower Supply & Equipment Rental',
            'service-1-desc': 'Comprehensive manpower supply services and heavy equipment rental for industrial and commercial construction projects.',
            'service-2': 'Material Supply Division',
            'service-2-desc': 'Reliable material supply services ensuring quality materials for all construction and industrial projects.',
            'service-3': 'Technical Support System',
            'service-3-desc': 'Expert technical support and consultation services for all your construction and engineering needs.',
            'service-4': 'Industrial Trading Division',
            'service-4-desc': 'Comprehensive industrial trading services providing quality products and solutions for industrial projects.',
            'service-5': 'Structural Steel Fabrication',
            'service-5-desc': 'Expert structural steel fabrication services for industrial and commercial construction projects.',
            'personnel-title': 'Construction Personnel',
            'personnel-desc': 'Current manpower—subject to change',
            'table-role': 'Role',
            'table-count': 'Count',
            'role-admin': 'Admin Staff',
            'role-eng-mech': 'Engineers (Mechanical)',
            'role-eng-civil': 'Engineers (Civil)',
            'role-eng-elec': 'Engineers (Electrical)',
            'role-draftsman': 'AutoCAD Draftsman',
            'role-fm-mech': 'General Foreman (Mechanical)',
            'role-fm-civil': 'General Foreman (Civil)',
            'role-fm-elec': 'General Foreman (Electrical)',
            'role-inst-tech': 'Instrument Technician',
            'role-inst-fit': 'Instrument Fitter',
            'role-laminator': 'Laminator',
            'role-fabricator': 'Fabricators',
            'role-welder': 'Welders',
            'role-pipe-fit': 'Pipe Fitters',
            'role-mech-fit': 'Mechanical Fitters',
            'role-painter': 'Painters',
            'role-mason': 'Masons',
            'role-carpenter': 'Carpenters',
            'role-steel-fix': 'Steel Fixers',
            'role-plumber': 'Plumbers',
            'role-electrician': 'Electricians',
            'role-hvac': 'HAVC Technicians',
            'role-helper': 'Helpers',
            'role-driver': 'Drivers',
            'principles-title': 'Center Principles',
            'principles-heading': 'Engineering and construction excellence',
            'principle-1': 'Outstanding service and progressive technical comprehension and capabilities.',
            'principle-2': 'Exceptional healthiness and wellbeing values.',
            'principle-3': 'Intelligibility, liability, and restraint in all essential regions.',
            'principle-4': 'Esteeming and honoring staff and guaranteeing constant growth.',
            'civil-title': 'Industrial Civil Construction',
            'civil-p1': 'Track record includes major industrial and multi-discipline projects:',
            'civil-p2': 'Desalination plants, power plants, petrochemical and gas installations, cement plants, utility installations, high-tension electrical substations.',
            'civil-services-heading': 'Services',
            'civil-s1': 'Reinforced Concrete Construction',
            'civil-s2': 'Pre-engineered Steel Building Erection',
            'civil-s3': 'Pre-Cast Concrete Construction / Erection',
            'civil-s4': 'Internal Finishing / Furnishing',
            'civil-s5': 'Earth Works',
            'civil-s6': 'Fencing Installations',
            'civil-s7': 'Paving Operations',
            'civil-s8': 'Mechanical Construction + Underground Utilities',
            'civil-s9': 'Site/Civil Engineering',
            'electrical-title': 'Electrical Construction Plant',
            'electrical-p1': 'Includes:',
            'electrical-s1': 'Installation of Field Panels, Junction Boxes, Limit switches, Push Buttons',
            'electrical-s2': 'Cable tray & conduits',
            'electrical-s3': 'MV/LV Motor control center, PLC/DCS panels',
            'electrical-s4': 'Industrial Communication Systems',
            'electrical-s5': 'Power & Lighting for Industrial/Commercial complexes',
            'electrical-s6': 'Construction of Manholes, Duct banks, Pits',
            'electrical-s7': 'Road & Area Lighting, Buried & Aerial Cabling',
            'electrical-s8': 'Grounding & Lightning Protection',
            'electrical-s9': 'Cathodic Protection equipment (testing, commissioning)',
            'electrical-s10': 'Plant maintenance services (short & long term) across Civil, Electrical, Mechanical disciplines',
            'projects-title': 'Projects',
            'project-1-title': 'Electrical Work',
            'project-1-desc': 'Comprehensive electrical construction and installation services.',
            'project-2-title': 'Construction Project – Dammam',
            'project-2-desc': 'Major construction projects in Dammam region.',
            'project-3-title': 'Construction Project – Al Jubail',
            'project-3-desc': 'Industrial and commercial construction projects in Al Jubail.',
            'project-4-title': 'Construction Project – Al Jubail, Support Industrial Area',
            'project-4-desc': 'Support industrial area construction projects in Al Jubail.',
            'equipment-title': 'Equipment Resources',
            'equipment-desc': 'We maintain a comprehensive fleet of modern construction equipment to support our projects.',
            'clients-title': 'Major Clients',
            'scrap-title': 'Scrap Metal Business',
            'scrap-p1': 'We handle various types of scrap metal including:',
            'scrap-1': 'Copper Scrap',
            'scrap-2': 'Steel Scrap',
            'scrap-3': 'Mixed Industrial Scrap',
            'gallery-title': 'Photo Gallery',
            'gallery-desc': 'Showcasing our projects and achievements',
            'gallery-modal-title': 'Project Gallery',
            'contact-title': 'Contact Us',
            'contact-desc': 'Get in touch with us for your construction needs',
            'contact-address-title': 'Address',
            'contact-phone-title': 'Phone',
            'contact-email-title': 'Email',
            'contact-website-title': 'Website',
            'contact-reg-title': 'Registration',
            'footer-about': '100% Saudi Arabia Company • Pioneering industrial and commercial construction since 1970. Registered with Ministry and Chamber of Commerce Commercial Reg. No: 7051448806 .',
            'footer-quick-links': 'QUICK LINKS',
            'footer-services': 'SERVICES',
            'footer-contact': 'CONTACT US',
            'footer-copyright': 'Copyright @2025 Eastern Top Companys. All Rights Reserved.'
        }
    };

    // Current language (default: Arabic)
    let currentLang = localStorage.getItem('siteLanguage') || 'ar';

    // Function to translate the page
    function translatePage(lang) {
        const elements = document.querySelectorAll('[data-translate]');
        elements.forEach(element => {
            const key = element.getAttribute('data-translate');
            if (translations[lang] && translations[lang][key]) {
                // Handle HTML content
                if (element.innerHTML.includes('<strong>') || element.innerHTML.includes('<br>')) {
                    element.innerHTML = translations[lang][key];
                } else {
                    element.textContent = translations[lang][key];
                }
            }
        });

        // Update HTML lang and dir attributes
        document.documentElement.setAttribute('lang', lang);
        document.documentElement.setAttribute('dir', lang === 'ar' ? 'rtl' : 'ltr');

        // Update language toggle button
        const langToggle = document.getElementById('langToggle');
        if (langToggle) {
            const langText = langToggle.querySelector('.lang-text');
            if (langText) {
                langText.textContent = lang === 'ar' ? 'EN' : 'AR';
            }
        }

        // Update body class for RTL/LTR
        document.body.classList.remove('rtl', 'ltr');
        document.body.classList.add(lang === 'ar' ? 'rtl' : 'ltr');

        // Save language preference
        localStorage.setItem('siteLanguage', lang);
        currentLang = lang;
    }

    // Initialize language on page load
    function initLanguage() {
        translatePage(currentLang);
    }

    // Language toggle handler
    function setupLanguageToggle() {
        const langToggle = document.getElementById('langToggle');
        if (langToggle) {
            langToggle.addEventListener('click', function() {
                const newLang = currentLang === 'ar' ? 'en' : 'ar';
                translatePage(newLang);
            });
        }
    }

    // Wait for DOM to be fully loaded
    document.addEventListener('DOMContentLoaded', function() {
        // Initialize language system
        initLanguage();
        setupLanguageToggle();
        
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
                    const offsetTop = target.offsetTop - headerHeight - 20;
                    
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
        // Gallery Lightbox Functionality
        // ============================================
        const galleryItems = document.querySelectorAll('.gallery-item');
        const galleryModal = document.getElementById('galleryModal');
        const modalImage = document.getElementById('modalImage');
        
        if (galleryModal && modalImage) {
            galleryItems.forEach(item => {
                item.addEventListener('click', function() {
                    const img = this.querySelector('img');
                    if (img) {
                        modalImage.src = img.src;
                        modalImage.alt = img.alt;
                    }
                });
            });
        }

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
        document.querySelectorAll('.organogram-card, .value-card, .vision-box, .mission-box, .service-card, .contact-card').forEach(element => {
            fadeInObserver.observe(element);
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
                } else if (window.innerWidth < 992) {
                    carousel.style.minHeight = '500px';
                } else {
                    carousel.style.minHeight = '600px';
                }
            }
        }

        // Initial carousel height setup
        updateCarouselHeight();

        // ============================================
        // Gallery Image Lazy Loading
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
        // Add Loading State
        // ============================================
        window.addEventListener('load', function() {
            document.body.classList.add('loaded');
        });

        // ============================================
        // Console Log (for debugging)
        // ============================================
        console.log('Eastern Top Companys Website - JavaScript Loaded Successfully');
    });

})();
