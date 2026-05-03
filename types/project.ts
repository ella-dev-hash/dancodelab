// Types TypeScript pour les projets

export type ProjectType = 'web' | 'network';

export interface Project {
  id: string;
  slug: string;
  title: string;
  description: string;
  type: ProjectType;
  content?: ProjectContent;
  image_url?: string;
  schema_url?: string;
  live_url?: string;
  equipment?: string[];
  objectives?: string[];
  tags: string[];
  featured: boolean;
  created_at: string;
  updated_at: string;
}

export interface ProjectContent {
  overview?: string;
  challenges?: string[];
  solutions?: string[];
  results?: string[];
  testimonial?: Testimonial;
  gallery?: GalleryImage[];
}

export interface Testimonial {
  client_name: string;
  client_role: string;
  client_company: string;
  quote: string;
  avatar_url?: string;
}

export interface GalleryImage {
  url: string;
  alt: string;
  caption?: string;
}

export interface Expertise {
  id: string;
  category: ProjectType;
  title: string;
  description?: string;
  icon?: string;
  level: number; // 1-5
  order_index: number;
  created_at: string;
}

export interface Client {
  id: string;
  name: string;
  email?: string;
  access_token: string;
  company?: string;
  created_at: string;
  expires_at?: string;
}

export interface ClientDocument {
  id: string;
  client_id: string;
  title: string;
  description?: string;
  file_url: string;
  file_type?: string;
  file_size?: number;
  is_downloadable: boolean;
  created_at: string;
}

export interface QuoteRequest {
  id?: string;
  name: string;
  email: string;
  company?: string;
  service_type: 'web' | 'network' | 'both';
  budget_range?: string;
  deadline?: string;
  description: string;
  status: 'pending' | 'contacted' | 'quoted' | 'closed';
  created_at?: string;
}
