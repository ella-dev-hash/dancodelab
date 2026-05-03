# Portfolio Hybride - Résumé de l'Architecture

## 📁 Arborescence Complète du Projet

```
/workspace
├── app/                          # Next.js App Router
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
│
├── components/
│   ├── ui/
│   │   ├── Button.tsx            # Composant bouton réutilisable
│   │   ├── Card.tsx              # Carte glassmorphism
│   │   └── Section.tsx           # Wrapper de section
│   ├── Hero.tsx                  # ✅ Hero Section Dual-Core (COMPLÉTÉ)
│   ├── BentoGrid.tsx             # Grille portfolio dynamique
│   ├── ProjectCard.tsx           # ✅ Carte projet Web/Réseau (COMPLÉTÉ)
│   ├── NetworkViewer.tsx         # Visualiseur schémas réseau
│   ├── ExpertiseCards.tsx        # Cartes expertise réseau
│   ├── QuoteForm.tsx             # Formulaire de devis intelligent
│   └── Navbar.tsx                # Navigation responsive
│
├── lib/
│   ├── supabase/
│   │   ├── client.ts             # ✅ Client Supabase browser (COMPLÉTÉ)
│   │   ├── server.ts             # ✅ Client Supabase server (COMPLÉTÉ)
│   │   └── types.ts              # Types générés Supabase
│   ├── sanity/
│   │   └── client.ts             # Client Sanity (optionnel)
│   └── utils.ts                  # ✅ Utilitaires (cn, formatDate, etc.) (COMPLÉTÉ)
│
├── public/
│   ├── images/                   # Images statiques
│   └── schemas/                  # Schémas réseau SVG
│
├── styles/
│   └── theme.ts                  # Configuration thème Tailwind
│
├── types/
│   └── project.ts                # ✅ Types TypeScript projets (COMPLÉTÉ)
│
├── docs/
│   ├── SUPABASE_SETUP.md         # ✅ Guide configuration Supabase (COMPLÉTÉ)
│   └── VERCEL_DEPLOYMENT.md      # ✅ Guide déploiement Vercel (COMPLÉTÉ)
│
├── supabase/
│   └── migrations/
│       └── 001_initial_schema.sql # ✅ Schéma de base de données (COMPLÉTÉ)
│
├── .env.local.example            # ✅ Variables d'environnement exemple (COMPLÉTÉ)
├── package.json                  # ✅ Dépendances NPM (COMPLÉTÉ)
├── next.config.js                # Configuration Next.js
├── tailwind.config.ts            # Configuration Tailwind
├── tsconfig.json                 # Configuration TypeScript
└── README.md                     # ✅ Documentation principale (COMPLÉTÉ)
```

---

## 🎨 Design System "Cyber-Luxury"

### Couleurs
| Élément | Valeur | Usage |
|---------|--------|-------|
| Fond principal | `#020617` | Background global |
| Accent Web | `#22d3ee` (cyan-400) | Projets web, boutons, hover |
| Accent Réseau | `#10b981` (emerald-400) | Projets réseau, sécurité |
| Texte principal | `#ffffff` | Titres |
| Texte secondaire | `#94a3b8` (slate-400) | Paragraphes |

### Effets
- **Glassmorphism**: `backdrop-blur-xl bg-slate-900/60`
- **Border Gradient**: Animation CSS personnalisée
- **Glow**: Ombres colorées avec `shadow-cyan-500/25`
- **Grille background**: Pattern CSS en arrière-plan

---

## 🗄️ Base de Données Supabase

### Tables Principales

#### `projects`
- Stocke tous les projets (web et réseau)
- Champs: title, slug, description, type, image_url, schema_url, equipment, tags
- RLS: Lecture publique, écriture authentifiée

#### `expertise`
- Compétences affichées sur le site
- Champs: category, title, description, icon, level (1-5)
- RLS: Lecture publique, gestion admin

#### `clients`
- Clients avec token d'accès unique
- Champs: name, email, access_token, company, expires_at
- RLS: Accès par token uniquement

#### `client_documents`
- Livrables privés pour chaque client
- Champs: client_id, title, file_url, is_downloadable
- RLS: Accès via relation client

#### `quote_requests`
- Demandes de devis depuis le formulaire
- Champs: name, email, service_type, budget_range, status
- RLS: Création publique, gestion admin

---

## 📦 Storage Supabase

### Buckets Configurer

| Bucket | Type | Taille Max | MIME Types |
|--------|------|------------|------------|
| `projects-web` | Public | 10MB | image/jpeg, png, webp |
| `projects-network` | Public | 10MB | image/svg+xml, png, jpeg |
| `client-documents` | Privé | 50MB | pdf, images, zip |

---

## 🔐 Sécurité

### Row Level Security (RLS)
- Activé sur toutes les tables
- Politiques granulaires par opération (SELECT, INSERT, UPDATE, DELETE)
- Tokens d'accès temporaires pour les clients

### Bonnes Pratiques
- `SUPABASE_SERVICE_ROLE_KEY` jamais exposé côté client
- Validation des fichiers uploadés (type, taille)
- Expiration des tokens clients
- Headers de sécurité HTTP configurés

---

## 🚀 Prochaines Étapes

### Fichiers à Créer

1. **Configuration Next.js**
   - `next.config.js` - Configuration images remotePatterns
   - `tailwind.config.ts` - Thème personnalisé
   - `tsconfig.json` - Paths et options TypeScript

2. **Layout & Pages**
   - `app/layout.tsx` - Root layout avec providers
   - `app/page.tsx` - Landing page avec Hero + BentoGrid
   - `app/globals.css` - Styles globaux

3. **Composants Manquants**
   - `components/BentoGrid.tsx` - Grille de projets
   - `components/Navbar.tsx` - Navigation
   - `components/QuoteForm.tsx` - Formulaire de devis
   - `components/NetworkViewer.tsx` - Visualiseur SVG

4. **Pages Dynamiques**
   - `app/projets/[slug]/page.tsx` - Étude de cas
   - `app/clients/[token]/page.tsx` - Espace client
   - `app/admin/page.tsx` - Dashboard admin

---

## 📋 Checklist de Déploiement

- [ ] Créer projet Supabase
- [ ] Exécuter migrations SQL
- [ ] Configurer buckets Storage
- [ ] Copier `.env.local.example` → `.env.local`
- [ ] Remplir variables d'environnement
- [ ] Pousser code sur GitHub
- [ ] Importer projet sur Vercel
- [ ] Configurer variables d'environnement Vercel
- [ ] Déployer
- [ ] Tester toutes les fonctionnalités

---

## 🛠️ Commandes Utiles

```bash
# Développement local
npm install
npm run dev

# Build de production
npm run build
npm start

# Vérification TypeScript
npm run type-check

# Linting
npm run lint
```

---

## 📚 Ressources

- [Documentation Next.js 14](https://nextjs.org/docs)
- [Supabase Docs](https://supabase.com/docs)
- [Tailwind CSS](https://tailwindcss.com/docs)
- [Framer Motion](https://www.framer.com/motion/)
- [Vercel Deployment](https://vercel.com/docs)
