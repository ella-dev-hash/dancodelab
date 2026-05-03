# =====================================
# DÉPLOIEMENT GRATUIT SUR VERCEL
# =====================================

## PRÉREQUIS

- Compte GitHub (gratuit)
- Compte Vercel (gratuit sur https://vercel.com)
- Projet Next.js fonctionnel localement
- Projet Supabase configuré

---

## ÉTAPE 1 : PRÉPARER LE PROJET POUR GITHUB

### 1.1 Initialiser Git (si ce n'est pas déjà fait)

```bash
cd /workspace
git init
git add .
git commit -m "Initial commit - Portfolio Hybride"
```

### 1.2 Créer un dépôt sur GitHub

1. Rendez-vous sur https://github.com/new
2. Créez un nouveau dépôt (public ou privé)
3. Nommez-le `portfolio-hybride`
4. Ne PAS l'initialiser avec README/.gitignore (déjà fait)

### 1.3 Pousser le code vers GitHub

```bash
# Remplacez par votre URL de dépôt
git remote add origin https://github.com/VOTRE_USERNAME/portfolio-hybride.git
git branch -M main
git push -u origin main
```

---

## ÉTAPE 2 : CONFIGURER VERCEL

### 2.1 Importer le projet

1. Connectez-vous à https://vercel.com/dashboard
2. Cliquez sur **"Add New..."** → **"Project"**
3. Sélectionnez **"Import Git Repository"**
4. Trouvez votre dépôt `portfolio-hybride`
5. Cliquez sur **"Import"**

### 2.2 Configuration du projet

Dans la page de configuration :

- **Framework Preset**: Next.js (détecté automatiquement)
- **Root Directory**: `./` (laisser tel quel)
- **Build Command**: `npm run build` (par défaut)
- **Output Directory**: `.next` (par défaut)
- **Install Command**: `npm install` (par défaut)

### 2.3 Variables d'environnement

Cliquez sur **"Environment Variables"** et ajoutez :

| Name | Value | Environment |
|------|-------|-------------|
| `NEXT_PUBLIC_SUPABASE_URL` | `https://xxx.supabase.co` | Production, Preview, Development |
| `NEXT_PUBLIC_SUPABASE_ANON_KEY` | `eyJhbG...` (votre clef anon) | Production, Preview, Development |
| `SUPABASE_SERVICE_ROLE_KEY` | `eyJhbG...` (votre clef service) | Production uniquement ⚠️ |

⚠️ **Important**: Ne jamais exposer `SUPABASE_SERVICE_ROLE_KEY` côté client !

### 2.4 Lancer le déploiement

Cliquez sur **"Deploy"** et attendez (~2-3 minutes).

---

## ÉTAPE 3 : CONFIGURATION POST-DÉPLOIEMENT

### 3.1 Domaine personnalisé (optionnel)

1. Allez dans **Settings** → **Domains**
2. Ajoutez votre domaine (ex: `monportfolio.com`)
3. Suivez les instructions pour configurer les DNS :
   ```
   Type: CNAME
   Name: www
   Value: cname.vercel-dns.com
   ```

### 3.2 Redirections et Rewrites

Créez un fichier `vercel.json` à la racine :

```json
{
  "rewrites": [
    { "source": "/projets/:slug", "destination": "/projets/[slug]" },
    { "source": "/clients/:token", "destination": "/clients/[token]" }
  ],
  "headers": [
    {
      "source": "/(.*)",
      "headers": [
        {
          "key": "X-Content-Type-Options",
          "value": "nosniff"
        },
        {
          "key": "X-Frame-Options",
          "value": "DENY"
        },
        {
          "key": "X-XSS-Protection",
          "value": "1; mode=block"
        }
      ]
    }
  ]
}
```

### 3.3 Optimisation des images

Dans `next.config.js`, configurez les domaines d'images :

```javascript
/** @type {import('next').NextConfig} */
const nextConfig = {
  images: {
    remotePatterns: [
      {
        protocol: 'https',
        hostname: '*.supabase.co',
      },
      {
        protocol: 'https',
        hostname: '*.sanity.io',
      },
    ],
  },
};

module.exports = nextConfig;
```

---

## ÉTAPE 4 : AUTOMATISATION DES DÉPLOIEMENTS

### 4.1 Déploiements automatiques

Vercel déploie automatiquement à chaque push sur :
- **main** → Production
- **autres branches** → Preview URLs

### 4.2 Ignorer certains déploiements

Créez un fichier `.vercelignore` :

```
node_modules
.env.local
*.md
docs/
.supabase/
```

### 4.3 Prévisualisation des Pull Requests

Activez les previews pour les PRs dans :
**Settings** → **Git** → **Preview Comments** = ON

---

## ÉTAPE 5 : OPTIMISATIONS PERFORMANCES

### 5.1 Activer le caching Next.js

Vercel gère automatiquement le cache, mais vous pouvez optimiser :

```typescript
// Dans vos Server Components
export const revalidate = 3600; // Revalider chaque heure
```

### 5.2 Utiliser Edge Functions (optionnel)

Pour les routes API critiques :

```typescript
// app/api/route.ts
export const runtime = 'edge';
```

### 5.3 Analytics Vercel (gratuit)

1. Allez dans **Analytics** dans le dashboard
2. Activez **Web Analytics**
3. Ajoutez le script dans `app/layout.tsx` :

```typescript
import { Analytics } from '@vercel/analytics/react';

export default function RootLayout({ children }) {
  return (
    <html>
      <body>
        {children}
        <Analytics />
      </body>
    </html>
  );
}
```

---

## ÉTAPE 6 : SÉCURITÉ ET BONNES PRATIQUES

### 6.1 Protection par mot de passe (pour previews)

Dans **Settings** → **Deployment Protection** :
- Activez **Vercel Authentication** pour les previews
- Ou utilisez des mots de passe temporaires

### 6.2 Rate Limiting pour l'API

Installez `@upstash/ratelimit` pour limiter les requêtes :

```typescript
import { Ratelimit } from "@upstash/ratelimit";
import { Redis } from "@upstash/redis";

const ratelimit = new Ratelimit({
  redis: Redis.fromEnv(),
  limiter: Ratelimit.slidingWindow(10, "10 s"),
});
```

### 6.3 Monitoring des erreurs

Activez **Vercel Logs** et **Error Monitoring** dans le dashboard.

---

## ÉTAPE 7 : URL FINALES

Après déploiement réussi, vous aurez :

- **Production**: `https://portfolio-hybride.vercel.app`
- **Preview**: `https://portfolio-hybride-git-main.vercel.app`

---

## DÉPANNAGE COURANT

### Erreur: Module not found

```bash
# Vérifiez que toutes les dépendances sont dans package.json
npm install
git add package.json package-lock.json
git commit -m "Fix dependencies"
git push
```

### Erreur: Environment variables missing

Vérifiez dans **Settings** → **Environment Variables** que toutes les variables sont définies pour **Production**.

### Build trop lent

- Réduisez la taille des images
- Utilisez `next/image` correctement
- Activez le cache de build

### Erreur Supabase CORS

Dans Supabase Dashboard → API Settings :
- Ajoutez votre domaine Vercel aux **Allowed URLs**

---

## LIENS UTILES

- Documentation Vercel: https://vercel.com/docs
- Next.js Deployment: https://nextjs.org/docs/deployment
- Supabase + Vercel: https://supabase.com/docs/guides/getting-started/quickstarts/vercel
- Vercel CLI: `npm i -g vercel` puis `vercel --prod`

---

## PLAN GRATUIT VERCEL - LIMITES

✅ **Inclus gratuitement** :
- Déploiements illimités
- Bande passante: 100 GB/mois
- Fonctions Serverless: 100 GB-heures
- Domaines personnalisés illimités
- SSL automatique
- Analytics de base

⚠️ **Limites** :
- Pas de fonctions edge avancées
- Temps d'exécution max: 10s (serverless)
- Mémoire max: 1024 MB

Pour un portfolio, le plan gratuit est largement suffisant !
