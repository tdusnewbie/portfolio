# Portfolio Repository 🌐
This portfolio is built using **MkDocs** and the **Material theme**, ideal for a Python developer.

## Features
- **Markdown-driven**: Easy to maintain CV and project pages.
- **Python-powered**: Flexible and extensible.
- **Homelab hosting**: Designed to be served from your on-prem server.

## Getting Started
1. **Install dependencies**:
   ```bash
   pip install -r requirements.txt
   ```
2. **Run locally**:
   ```bash
   mkdocs serve
   ```
3. **Build for hosting**:
   ```bash
   mkdocs build
   ```
   Copy the `site/` directory to your web server (e.g., Nginx, Apache).

## Hosting on Homelab
- **Docker**: Use the `squidfunk/mkdocs-material` image.
- **Static files**: Serve the `site/` directory directly.
