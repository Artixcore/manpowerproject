# Eastern Top Companys Website

A responsive single-page website for Eastern Top Companys, built with Bootstrap 5.3.

## Features

- **Responsive Design**: Mobile-first approach with Bootstrap 5.3 grid system
- **Modern UI**: Clean and professional design matching the original website
- **Smooth Navigation**: Fixed navbar with smooth scrolling
- **Service Showcase**: 6 service cards with hover effects
- **Quality Section**: Highlighting company values and quality standards
- **Image Gallery**: Responsive grid layout for project showcase
- **Contact Footer**: Complete footer with quick links and contact information

## Technologies Used

- **Bootstrap 5.3.8**: Latest version via CDN
- **Bootstrap Icons**: For iconography
- **HTML5**: Semantic markup
- **CSS3**: Custom styling
- **JavaScript**: Smooth scrolling and interactive features

## Project Structure

```
manpowerproject/
├── index.html          # Main HTML file
├── css/
│   └── style.css      # Custom styles
├── js/
│   └── main.js        # JavaScript functionality
├── setup.sh           # Apache2 setup script for AWS Lightsail
├── DEPLOYMENT.md      # Detailed deployment guide
├── QUICK_START.md     # Quick start guide
└── README.md          # Project documentation
```

## Getting Started

### Local Development

1. Clone or download this repository
2. Open `index.html` in a web browser
3. No build process or dependencies required - it's a static website using CDN resources

### AWS Lightsail Deployment

For automated deployment on AWS Lightsail:

1. **Upload files to your Lightsail instance:**
   ```bash
   scp -r index.html css/ js/ setup.sh ubuntu@your-instance-ip:/home/ubuntu/manpowerproject/
   ```

2. **SSH into your instance and run setup:**
   ```bash
   ssh ubuntu@your-instance-ip
   cd /home/ubuntu/manpowerproject
   sudo bash setup.sh
   ```

3. **Access your website:**
   - Open browser: `http://your-instance-public-ip`

For detailed deployment instructions, see [DEPLOYMENT.md](DEPLOYMENT.md) or [QUICK_START.md](QUICK_START.md)

## Sections

- **Hero Section**: Welcome message and company introduction
- **Services**: 6 service offerings in a responsive grid
- **Quality**: Company quality standards and values
- **Why Choose Us**: 4 core values (Integrity, Teamwork, Customer Focus, Quality)
- **Gallery**: Project showcase with image grid
- **Footer**: Quick links, services list, and contact information

## Customization

### Colors
Edit CSS variables in `css/style.css`:
```css
:root {
    --primary-color: #0066cc;
    --secondary-color: #004499;
    --text-dark: #333;
    --text-light: #666;
    --bg-light: #f8f9fa;
}
```

### Content
All content can be modified directly in `index.html`. Replace placeholder images with actual project images.

## Browser Support

- Chrome (latest)
- Firefox (latest)
- Safari (latest)
- Edge (latest)

## License

This project is a clone/recreation for educational purposes.

## Contact

For more information, visit: https://www.easterntopcompanys.com/

