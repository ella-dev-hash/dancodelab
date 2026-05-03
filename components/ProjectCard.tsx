'use client';

import { motion } from 'framer-motion';
import { ExternalLink, Server, Code2, ArrowRight } from 'lucide-react';
import Image from 'next/image';

interface Project {
  id: string;
  slug: string;
  title: string;
  description: string;
  type: 'web' | 'network';
  image?: string;
  schema?: string;
  tags: string[];
  liveUrl?: string;
  equipment?: string[];
  objectives?: string[];
}

interface ProjectCardProps {
  project: Project;
}

export default function ProjectCard({ project }: ProjectCardProps) {
  const isWeb = project.type === 'web';
  const accentColor = isWeb ? 'cyan' : 'emerald';
  const Icon = isWeb ? Code2 : Server;

  return (
    <motion.div
      initial={{ opacity: 0, y: 20 }}
      whileInView={{ opacity: 1, y: 0 }}
      viewport={{ once: true, margin: "-50px" }}
      whileHover={{ y: -8 }}
      transition={{ duration: 0.3 }}
      className="group relative"
    >
      {/* Glow Effect */}
      <div 
        className={`absolute inset-0 bg-gradient-to-r from-${accentColor}-500/20 to-${accentColor}-500/10 rounded-2xl blur-xl group-hover:blur-2xl transition-all duration-300 opacity-0 group-hover:opacity-100`}
      />
      
      {/* Card Container */}
      <div className={`relative backdrop-blur-xl bg-slate-900/60 border border-${accentColor}-500/30 rounded-2xl overflow-hidden h-full flex flex-col`}>
        {/* Image/Schema Preview */}
        <div className="relative h-48 overflow-hidden">
          {project.image || project.schema ? (
            <Image
              src={isWeb ? project.image! : project.schema!}
              alt={project.title}
              fill
              className="object-cover transition-transform duration-500 group-hover:scale-110"
            />
          ) : (
            <div className={`w-full h-full bg-gradient-to-br from-${accentColor}-500/20 to-slate-800 flex items-center justify-center`}>
              <Icon className={`w-16 h-16 text-${accentColor}-400/50`} />
            </div>
          )}
          
          {/* Type Badge */}
          <div className={`absolute top-3 right-3 px-3 py-1 bg-${accentColor}-500/90 backdrop-blur-sm rounded-full text-xs font-semibold text-white`}>
            {isWeb ? 'Web' : 'Réseau'}
          </div>
        </div>

        {/* Content */}
        <div className="p-6 flex-1 flex flex-col">
          <h3 className="text-xl font-bold text-white mb-2 group-hover:text-cyan-400 transition-colors">
            {project.title}
          </h3>
          
          <p className="text-slate-400 text-sm mb-4 line-clamp-2 flex-1">
            {project.description}
          </p>

          {/* Tags */}
          <div className="flex flex-wrap gap-2 mb-4">
            {project.tags.slice(0, 3).map((tag, index) => (
              <span
                key={index}
                className={`px-2 py-1 bg-${accentColor}-500/10 border border-${accentColor}-500/20 rounded-lg text-xs text-${accentColor}-400`}
              >
                {tag}
              </span>
            ))}
          </div>

          {/* Network Equipment (if applicable) */}
          {project.equipment && project.equipment.length > 0 && (
            <div className="mb-4 p-3 bg-slate-800/50 rounded-lg">
              <p className="text-xs text-slate-500 mb-1">Équipements:</p>
              <div className="flex flex-wrap gap-1">
                {project.equipment.slice(0, 3).map((eq, index) => (
                  <span key={index} className="text-xs text-slate-300">
                    {eq}{index < Math.min(project.equipment!.length - 1, 2) && ','}
                  </span>
                ))}
                {project.equipment.length > 3 && (
                  <span className="text-xs text-slate-500">+{project.equipment.length - 3}</span>
                )}
              </div>
            </div>
          )}

          {/* Action Button */}
          <a
            href={`/projets/${project.slug}`}
            className={`w-full py-3 px-4 bg-gradient-to-r from-${accentColor}-500 to-${accentColor}-600 hover:from-${accentColor}-400 hover:to-${accentColor}-500 text-white font-medium rounded-xl flex items-center justify-center gap-2 transition-all duration-300 group/btn`}
          >
            Voir l'étude de cas
            <ArrowRight className="w-4 h-4 group-hover/btn:translate-x-1 transition-transform" />
          </a>

          {/* Live Link (for web projects) */}
          {project.liveUrl && (
            <a
              href={project.liveUrl}
              target="_blank"
              rel="noopener noreferrer"
              className="mt-2 text-sm text-slate-400 hover:text-cyan-400 flex items-center gap-1 transition-colors"
            >
              <ExternalLink className="w-3 h-3" />
              Site en ligne
            </a>
          )}
        </div>

        {/* Animated Border on Hover */}
        <div className={`absolute inset-0 rounded-2xl opacity-0 group-hover:opacity-100 transition-opacity duration-300 pointer-events-none`}
          style={{
            background: `linear-gradient(45deg, transparent 48%, ${isWeb ? '#22d3ee' : '#10b981'} 50%, transparent 52%)`,
            backgroundSize: '200% 200%',
            animation: 'border-flow 2s linear infinite',
          }}
        />
      </div>

      <style jsx>{`
        @keyframes border-flow {
          0% { background-position: 0% 50%; }
          100% { background-position: 100% 50%; }
        }
      `}</style>
    </motion.div>
  );
}
