-- =====================================
-- PORTFOLIO HYBRIDE - SCHÉMA DE BASE DE DONNÉES
-- =====================================

-- Table des projets
CREATE TABLE IF NOT EXISTS projects (
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
CREATE TABLE IF NOT EXISTS expertise (
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
CREATE TABLE IF NOT EXISTS clients (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  name TEXT NOT NULL,
  email TEXT,
  access_token UUID UNIQUE DEFAULT gen_random_uuid(),
  company TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  expires_at TIMESTAMP WITH TIME ZONE
);

-- Table des documents clients (livrables)
CREATE TABLE IF NOT EXISTS client_documents (
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

-- Table des demandes de devis
CREATE TABLE IF NOT EXISTS quote_requests (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  name TEXT NOT NULL,
  email TEXT NOT NULL,
  company TEXT,
  service_type TEXT CHECK (service_type IN ('web', 'network', 'both')) NOT NULL,
  budget_range TEXT,
  deadline DATE,
  description TEXT NOT NULL,
  status TEXT CHECK (status IN ('pending', 'contacted', 'quoted', 'closed')) DEFAULT 'pending',
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Index pour les performances
CREATE INDEX IF NOT EXISTS idx_projects_type ON projects(type);
CREATE INDEX IF NOT EXISTS idx_projects_featured ON projects(featured);
CREATE INDEX IF NOT EXISTS idx_projects_slug ON projects(slug);
CREATE INDEX IF NOT EXISTS idx_expertise_category ON expertise(category);
CREATE INDEX IF NOT EXISTS idx_clients_token ON clients(access_token);
CREATE INDEX IF NOT EXISTS idx_client_documents_client ON client_documents(client_id);
CREATE INDEX IF NOT EXISTS idx_quote_requests_status ON quote_requests(status);

-- Trigger pour mettre à jour updated_at
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_projects_updated_at
  BEFORE UPDATE ON projects
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- Row Level Security (RLS)
ALTER TABLE projects ENABLE ROW LEVEL SECURITY;
ALTER TABLE expertise ENABLE ROW LEVEL SECURITY;
ALTER TABLE clients ENABLE ROW LEVEL SECURITY;
ALTER TABLE client_documents ENABLE ROW LEVEL SECURITY;
ALTER TABLE quote_requests ENABLE ROW LEVEL SECURITY;

-- Politiques pour projects (lecture publique, écriture authentifiée)
CREATE POLICY "Public can view projects" ON projects
  FOR SELECT USING (true);

CREATE POLICY "Authenticated users can insert projects" ON projects
  FOR INSERT WITH CHECK (auth.role() = 'authenticated');

CREATE POLICY "Authenticated users can update projects" ON projects
  FOR UPDATE USING (auth.role() = 'authenticated');

CREATE POLICY "Authenticated users can delete projects" ON projects
  FOR DELETE USING (auth.role() = 'authenticated');

-- Politiques pour expertise (lecture publique, écriture authentifiée)
CREATE POLICY "Public can view expertise" ON expertise
  FOR SELECT USING (true);

CREATE POLICY "Authenticated users can manage expertise" ON expertise
  FOR ALL USING (auth.role() = 'authenticated');

-- Politiques pour clients (accès par token uniquement)
CREATE POLICY "Clients can view their own data" ON clients
  FOR SELECT USING (
    auth.uid() IS NOT NULL OR 
    EXISTS (SELECT 1 FROM clients WHERE access_token = current_setting('app.access_token', true)::uuid)
  );

-- Politiques pour client_documents (accès via client)
CREATE POLICY "Clients can view their documents" ON client_documents
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM clients 
      WHERE clients.id = client_documents.client_id
      AND (clients.access_token = current_setting('app.access_token', true)::uuid OR auth.uid() IS NOT NULL)
    )
  );

-- Politiques pour quote_requests (création publique, gestion admin)
CREATE POLICY "Anyone can create quote requests" ON quote_requests
  FOR INSERT WITH CHECK (true);

CREATE POLICY "Authenticated users can view quote requests" ON quote_requests
  FOR SELECT USING (auth.role() = 'authenticated');

CREATE POLICY "Authenticated users can update quote requests" ON quote_requests
  FOR UPDATE USING (auth.role() = 'authenticated');

-- Données de démo (optionnel - à supprimer en production)
INSERT INTO expertise (category, title, description, icon, level, order_index) VALUES
  ('web', 'Next.js / React', 'Développement d''applications web modernes et performantes', 'code', 5, 1),
  ('web', 'TypeScript', 'Code typé et maintenable pour des projets robustes', 'file-code', 5, 2),
  ('web', 'Tailwind CSS', 'Design responsive et esthétique avec utility-first CSS', 'palette', 5, 3),
  ('web', 'Supabase', 'Base de données PostgreSQL et authentication', 'database', 4, 4),
  ('network', 'Audit Réseau', 'Analyse complète de votre infrastructure existante', 'search', 5, 1),
  ('network', 'Cisco / MikroTik', 'Configuration de routeurs et switches professionnels', 'server', 5, 2),
  ('network', 'Sécurité', 'Firewall, VLAN, VPN et protection des données', 'shield', 5, 3),
  ('network', 'Virtualisation', 'Proxmox, VMware et conteneurisation', 'cpu', 4, 4);
