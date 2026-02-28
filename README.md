# My Portfolio 🚀

A modern, minimalist, single-page professional portfolio built with **Pico.css** (Zero JS) and **Typst**, designed for GitOps deployment on a K3s cluster.

## 📁 Project Structure

- `index.html`: Main landing page built with Pico.css.
- `assets/`: Images and the final generated PDF version of the CV.
- `cv/`: Source directory for the CV.
  - `cv.typ`: The Typst source file for the CV.
- `k8s/`: Kubernetes manifests for deployment on K3s.
- `.github/workflows/`: GitHub Actions for CI/CD.
- `Dockerfile`: Nginx-based Docker image for serving the site.

## 🚀 Development & CV Updates

1. **Update CV Content**:
   Edit `cv/cv.typ`.
2. **Compile to PDF**:
   ```bash
   typst compile cv/cv.typ assets/DungTran_CV.pdf
   ```

## ☸️ Deployment

### GitHub Actions (CI/CD)
The repository is equipped with a GitHub Action (`.github/workflows/deploy.yaml`) that:
1. Compiles the Typst CV into a PDF.
2. Builds a production-ready Docker image.
3. Pushes the image to GitHub Container Registry (GHCR).

### Manual Deployment
1. **Build and Push Image:**
   ```bash
   docker build -t your-registry/portfolio:latest .
   docker push your-registry/portfolio:latest
   ```

2. **Deploy to Cluster:**
   Update the image and hostnames in `k8s/deployment.yaml`, then apply:
   ```bash
   kubectl apply -f k8s/deployment.yaml
   ```

---
*Built with ❤️ and managed via GitOps.*
