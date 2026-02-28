#import "@preview/modern-cv:0.9.0": *

#show: resume.with(
  author: (
      firstname: "Dung Tran",
      lastname: "",
      email: "trdung.8398@gmail.com",
      phone: "+84-838-862-789",
      github: "tdusnewbie",
      linkedin: "dung-tran-145952186",
      positions: (
        "Senior DevOps Engineer",
      )
  ),
  profile-picture: none,
  date: datetime.today().display(),
  paper-size: "a4"
)

#v(0.5em)

#resume-item[
  Senior DevOps Engineer with 6+ years of experience specializing in *Platform Engineering* and *Cloud-Native Architecture*. I have a proven track record of building high-scale, secure infrastructure on AWS and Azure. I focus on *FinOps (Cost Optimization)*, *GitOps*, and creating self-service platforms that allow developers to deploy hundreds of microservices safely and independently.
]

#v(0.5em)

= Professional Experience

#resume-entry(
  title: "Vietnam Silicon",
  location: "Senior DevOps Engineer / Platform Lead",
  date: "Apr 2025 – Present",
  description: "Ho Chi Minh City, Vietnam"
)

#resume-item[
  - *Enterprise Cloud Architecture:* Architected a multi-account AWS environment using *AWS Organizations* and specialized *Organizational Units* to meet strict enterprise compliance and security standards.
  - *High-Scale Infrastructure Scaling:* Optimized resource management for heavy AI and data workloads using *Karpenter* and *KEDA*, ensuring system stability and high availability across 10+ AWS accounts.
  - *Internal Developer Platform (IDP):* Designed and built a self-service deployment framework (using Makefile, yq, and envsubst). This allowed developers to manage *200+ microservices* independently while maintaining 100% compliance with production standards.
  - *High-Scale GitOps:* Standardized deployment workflows across multiple clusters using *Argo CD* (App-of-Apps pattern). This improved the reliability of global deployments and reduced infrastructure provisioning time by *70%*.
  - *Modular CI/CD Design:* Engineered a centralized *Reusable Workflow* architecture in GitHub Actions. This standardized pipelines across both *monorepo and multi-repo* setups, significantly improving scalability.
  - *Zero-Trust Security:* Modernized the security stack by moving to *HashiCorp Vault* for dynamic secrets and *SOPS* for encrypted Git-based configurations. Integrated *Bank-Vaults* for sidecar-less secret injection into production pods.
  - *Cloud Observability:* Orchestrated a centralized monitoring pipeline using the *Grafana LGTM stack* (Alloy, Mimir, Loki, Tempo). This unified logs, metrics, and traces, reducing the *Mean Time To Resolution (MTTR)* for production incidents by 40%.
]

#v(0.5em)
#resume-entry(
  title: "Talentnet Corp",
  location: "Senior DevOps Engineer",
  date: "Mar 2023 – Apr 2025",
  description: "Ho Chi Minh City, Vietnam"
)

#resume-item[
  - *Hybrid CI/CD Architect:* Designed high-availability CI/CD models for *Azure Cloud* and *On-Premise* HR Tech systems. Standardized infrastructure across Dev, Staging, and Production to ensure 100% environment parity.
  - *Modern IaC Research:* Led a technical migration study to move legacy Terraform stacks to *Pulumi TypeScript*, improving type safety and infrastructure testing capabilities.
  - *Reliability Engineering:* Integrated *k6* for automated performance testing and designed *Disaster Recovery (DR)* strategies for critical payroll systems to ensure zero business interruption.
]

#block(breakable: false)[
#v(0.5em)
#resume-entry(
  title: "KMS Technology",
  location: "Software / Senior DevOps Engineer",
  date: "May 2019 – Mar 2023",
  description: "Ho Chi Minh City, Vietnam"
)

#resume-item[
  - *High-Security Pipelines:* Built secure CI/CD workflows for Healthcare applications, focusing on automated compliance auditing and data protection.
  - *Engineering Efficiency:* Developed a custom test orchestration engine using *Docker* and *Python*, reducing large-scale test execution time by 50%.
  - *Internal Platform:* Built a TypeScript-based developer portal integrated with Google APIs to improve team transparency and automated process tracking.
]
]

#block(breakable: false)[
#v(0.5em)
= Technical Innovation & Personal Projects

#resume-entry(
  title: "Hybrid-Cloud Enterprise Homelab",
  location: "Personal Project",
  date: "Ongoing R&D",
  description: "DevOps & Infrastructure"
)

#resume-item[
  - *High-Availability & Networking:* Achieved full redundancy using *Keepalived* and a *Technitium DNS cluster*. Designed a multi-layer traffic flow (NLB to ALB architecture) forwarding from *Nginx Proxy Manager* to a *Traefik Ingress* controller.
  - *Hybrid-Cloud Infrastructure:* Managed a 2-node *Proxmox VE* cluster with a cloud witness node (OCI) via *Tailscale* and *Corosync QDevice* to ensure quorum across a multi-provider environment.
  - *Infrastructure Automation:* Used *Ansible* to automate the entire system lifecycle, from OS hardening and LXC/VM provisioning to the deployment of a production-ready *K3s (Kubernetes)* cluster.
  - *GitOps & Storage:* Implemented an *ArgoCD* "Root App" pattern for declarative cluster management. Orchestrated *Longhorn* for distributed block storage and *MetalLB* for bare-metal LoadBalancer support.
]
]

= Skills & Technical Stack

#resume-item[
  - *Orchestration:* Kubernetes (EKS/AKS/K3s), ArgoCD, Helm, Karpenter, KEDA, Traefik, Longhorn
  - *IaaC & Automation:* Terragrunt, Terraform, Ansible, Pulumi, GitHub Actions, Makefile, Bash
  - *Observability:* Grafana, Prometheus, Alloy, Mimir, Loki, Tempo, Vector
  - *Security & Ops:* HashiCorp Vault, Bank-Vaults, Teleport, SOPS, GitHub OIDC
]

= Certifications & Languages

#resume-item[
  - *AWS Certified Solutions Architect – Associate*
  - *Duolingo English Test – Proficient (CEFR C1/C2)*
]

= Education

#resume-entry(
  title: "HCM University of Science",
  location: "Information Technology",
  date: "2016 - 2020",
  description: "Ho Chi Minh City, Vietnam"
)
