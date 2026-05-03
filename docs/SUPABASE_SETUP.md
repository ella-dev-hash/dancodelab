# =====================================
# CONFIGURATION SUPABASE - PORTFOLIO HYBRIDE
# =====================================

## 1. CRÉATION DU PROJET SUPABASE

1. Rendez-vous sur https://supabase.com
2. Cliquez sur "New Project"
3. Remplissez les informations :
   - Name: portfolio-hybride
   - Database Password: (mot de passe fort)
   - Region: choisissez le plus proche (eu-west pour l'Europe)
4. Attendez la création du projet (~2 minutes)

## 2. RÉCUPÉRATION DES CREDENTIALS

Dans le dashboard Supabase :
- Allez dans Settings → API
- Copiez :
  - Project URL → SUPABASE_URL
  - anon/public key → SUPABASE_ANON_KEY
  - service_role key → SUPABASE_SERVICE_ROLE_KEY (garder secret!)

## 3. CONFIGURATION DES TABLES DE BASE DE DONNÉES

Exécutez ce SQL dans l'éditeur SQL de Supabase :

```sql
-- Table des projets
CREATE TABLE projects (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  title TEXT NOT NULL,
  slug TEXT UNIQUE NOT NULL,
  description TEXT NOT NULL,
  type TEXT CHECK (type IN ('web', 'network')) NOT NULL,
  content JSONB DEFAULT '{}',
  image_url TEXT,
  schema_url TEXT,
  live_url TEXT,
  equipment TEXT[],
  objectives TEXT[],
  tags TEXT[],
  featured BOOLEAN DEFAULT false,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Table des compétences/expertises
CREATE TABLE expertise (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  category TEXT CHECK (category IN ('web', 'network')) NOT NULL,
  title TEXT NOT NULL,
  description TEXT,
  icon TEXT,
  level INTEGER CHECK (level BETWEEN 1 AND 5),
  order_index INTEGER DEFAULT 0,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Table des clients (pour espace client sécurisé)
CREATE TABLE clients (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  name TEXT NOT NULL,
  email TEXT,
  access_token UUID UNIQUE DEFAULT gen_random_uuid(),
  company TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  expires_at TIMESTAMP WITH TIME ZONE
);

-- Table des documents clients (livrables)
CREATE TABLE client_documents (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  client_id UUID REFERENCES clients(id) ON DELETE CASCADE,
  title TEXT NOT NULL,
  description TEXT,
  file_url TEXT NOT NULL,
  file_type TEXT,
  file_size INTEGER,
  is_downloadable BOOLEAN DEFAULT true,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Index pour les performances
CREATE INDEX idx_projects_type ON projects(type);
CREATE INDEX idx_projects_featured ON projects(featured);
CREATE INDEX idx_clients_token ON clients(access_token);
CREATE INDEX idx_client_documents_client ON client_documents(client_id);
```

## 4. CONFIGURATION DU STORAGE (STOCKAGE DES FICHIERS)

### 4.1 Création des Buckets

Dans le dashboard Supabase → Storage :

1. **Bucket "projects-web"** (images de projets web)
   - Public: true
   - File size limit: 10MB
   - Allowed MIME types: image/jpeg, image/png, image/webp

2. **Bucket "projects-network"** (schémas réseau)
   - Public: true
   - File size limit: 10MB
   - Allowed MIME types: image/svg+xml, image/png, image/jpeg

3. **Bucket "client-documents"** (documents clients privés)
   - Public: false (privé!)
   - File size limit: 50MB
   - Allowed MIME types: application/pdf, image/*, application/zip

### 4.2 Politiques de Sécurité (RLS)

Activez RLS (Row Level Security) sur chaque bucket :

```sql
-- Bucket projects-web (public en lecture)
CREATE POLICY "Public Access" ON storage.objects FOR SELECT
USING (bucket_id = 'projects-web');

CREATE POLICY "Authenticated Upload" ON storage.objects FOR INSERT
WITH CHECK (bucket_id = 'projects-web' AND auth.role() = 'authenticated');

-- Bucket projects-network (public en lecture)
CREATE POLICY "Public Access" ON storage.objects FOR SELECT
USING (bucket_id = 'projects-network');

CREATE POLICY "Authenticated Upload" ON storage.objects FOR INSERT
WITH CHECK (bucket_id = 'projects-network' AND auth.role() = 'authenticated');

-- Bucket client-documents (privé, accès par token)
CREATE POLICY "Client Document Access" ON storage.objects FOR SELECT
USING (
  bucket_id = 'client-documents' AND 
  EXISTS (
    SELECT 1 FROM client_documents 
    WHERE client_documents.file_url = storage.objects.name
    AND client_documents.is_downloadable = true
  )
);
```

## 5. VARIABLES D'ENVIRONNEMENT

Créez un fichier `.env.local` à la racine du projet :

```env
# Supabase Configuration
NEXT_PUBLIC_SUPABASE_URL=https://votre-projet.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=votre-cle-anon-publique
SUPABASE_SERVICE_ROLE_KEY=votre-cle-service-role-secrete
```

## 6. STRUCTURE DES DOSSIERS STORAGE

Organisez vos fichiers ainsi :

```
projects-web/
├── projet-ecommerce/
│   ├── screenshot-1.png
│   └── mockup.png
└── ...

projects-network/
├── audit-reseau-entreprise/
│   ├── architecture-globale.svg
│   └── vlan-diagram.svg
└── ...

client-documents/
├── {client-id}/
│   ├── rapport-audit-2024.pdf
│   └── schema-reseau-final.svg
└── ...
```

## 7. UPLOAD DE FICHIERS - EXEMPLE DE CODE

```typescript
// lib/supabase/upload.ts
import { createClient } from '@supabase/supabase-js';

export async function uploadProjectImage(
  file: File, 
  projectName: string, 
  type: 'web' | 'network'
) {
  const supabase = createClient(
    process.env.NEXT_PUBLIC_SUPABASE_URL!,
    process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!
  );
  
  const bucket = type === 'web' ? 'projects-web' : 'projects-network';
  const extension = file.name.split('.').pop();
  const fileName = `${projectName}/${Date.now()}.${extension}`;
  
  const { data, error } = await supabase.storage
    .from(bucket)
    .upload(fileName, file, {
      cacheControl: '3600',
      upsert: false,
    });
  
  if (error) throw error;
  
  const { data: { publicUrl } } = supabase.storage
    .from(bucket)
    .getPublicUrl(fileName);
  
  return publicUrl;
}
```

## 8. SÉCURITÉ ET BONNES PRATIQUES

1. **Jamais exposer SUPABASE_SERVICE_ROLE_KEY côté client**
2. Utilisez toujours RLS pour protéger les données
3. Pour l'espace client, générez des tokens uniques par client
4. Mettez en place une expiration pour les tokens clients
5. Validez les types de fichiers uploadés côté serveur
