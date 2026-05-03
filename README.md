# Portfolio Hybride - Web & Réseau

Application web de portfolio "Hybride" haute performance pour présenter des services de Développement Web Premium et d'Infrastructure Réseau.

## Stack Technique

- **Framework**: Next.js 14+ (App Router) avec TypeScript
- **Styling**: Tailwind CSS (Dark Mode, Glassmorphism, Bento Grid)
- **Animations**: Framer Motion
- **Base de données & Auth**: Supabase (PostgreSQL + Auth + Storage)
- **CMS**: Sanity.io ou API Supabase

## Thème

- **Fond**: Bleu nuit (#020617)
- **Accent Web**: Cyan (#22d3ee)
- **Accent Réseau**: Émeraude (#10b981)
- **Style**: Cyber-Luxury avec effets glassmorphism

## Structure du Projet

```
portfolio-hybride/
├── app/
│   ├── admin/
│   │   └── page.tsx              # Dashboard admin sécurisé
│   ├── api/
│   │   ├── projects/
│   │   │   └── route.ts          # API endpoints projets
│   │   └── upload/
│   │       └── route.ts          # Upload vers Supabase Storage
│   ├── clients/
│   │   └── [token]/
│   │       └── page.tsx          # Espace client sécurisé
│   ├── projets/
│   │   └── [slug]/
│   │       └── page.tsx          # Pages dynamiques études de cas
│   ├── globals.css               # Styles globaux + Tailwind
│   ├── layout.tsx                # Layout racine
│   └── page.tsx                  # Landing Page (Home)
├── components/
│   ├── ui/
│   │   ├── Button.tsx            # Composant bouton réutilisable
│   │   ├── Card.tsx              # Carte glassmorphism
│   │   └── Section.tsx           # Wrapper de section
│   ├── Hero.tsx                  # Hero Section Dual-Core
│   ├── BentoGrid.tsx             # Grille portfolio dynamique
│   ├── ProjectCard.tsx           # Carte projet (Web/Réseau)
│   ├── NetworkViewer.tsx         # Visualiseur schémas réseau
│   ├── ExpertiseCards.tsx        # Cartes expertise réseau
│   ├── QuoteForm.tsx             # Formulaire de devis intelligent
│   └── Navbar.tsx                # Navigation responsive
├── lib/
│   ├── supabase/
│   │   ├── client.ts             # Client Supabase browser
│   │   ├── server.ts             # Client Supabase server
│   │   └── types.ts              # Types générés Supabase
│   ├── sanity/
│   │   └── client.ts             # Client Sanity (optionnel)
│   └── utils.ts                  # Utilitaires (cn, etc.)
├── public/
│   ├── images/                   # Images statiques
│   └── schemas/                  # Schémas réseau SVG
├── styles/
│   └── theme.ts                  # Configuration thème Tailwind
├── types/
│   └── project.ts                # Types TypeScript projets
├── .env.local.example            # Variables d'environnement exemple
├── next.config.js                # Configuration Next.js
├── tailwind.config.ts            # Configuration Tailwind
├── tsconfig.json                 # Configuration TypeScript
└── package.json                  # Dépendances
```

## Installation

```bash
npm install
```

## Configuration Supabase

1. Créez un projet sur [supabase.com](https://supabase.com)
2. Copiez `.env.local.example` vers `.env.local`
3. Remplissez avec vos credentials Supabase
4. Exécutez le SQL dans `supabase/migrations/` pour créer les tables

## Développement

```bash
npm run dev
```

## Déploiement Vercel

1. Poussez le code sur GitHub
2. Importez le projet sur Vercel
3. Configurez les variables d'environnement
4. Déployez

## License

MIT
