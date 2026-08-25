'use client';

import { useState } from 'react';

export default function TicketForm() {
  const [title, setTitle] = useState('');
  const [description, setDescription] = useState('');
  const [urgency, setUrgency] = useState('3');
  const [files, setFiles] = useState<FileList | null>(null);
  const [loading, setLoading] = useState(false);
  const [status, setStatus] = useState<{ type: 'success' | 'error'; message: string } | null>(null);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setLoading(true);
    setStatus(null);

    // Construction du FormData
    const formData = new FormData();
    formData.append('title', title);
    formData.append('description', description);
    formData.append('urgency', urgency);

    if (files) {
      Array.from(files).forEach((file) => {
        formData.append('attachments[]', file);
      });
    }

    try {
      const response = await fetch('/api/tickets', {
        method: 'POST',
        body: formData, // Pas de Content-Type header manuel, le navigateur le gère avec le boundary
      });

      const data = await response.json();

      if (!response.ok) {
        throw new Error(data.message || 'Une erreur est survenue.');
      }

      setStatus({
        type: 'success',
        message: `Ticket #${data.glpi_id ?? ''} créé avec succès !`,
      });
      setTitle('');
      setDescription('');
      setUrgency('3');
      setFiles(null);
    } catch (err: any) {
      setStatus({
        type: 'error',
        message: err.message || 'Impossible d\'envoyer le ticket.',
      });
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="max-w-xl mx-auto p-6 bg-white dark:bg-slate-900 rounded-xl shadow-md border border-slate-200 dark:border-slate-800">
      <h2 className="text-2xl font-bold text-slate-900 dark:text-white mb-6">
        Ouvrir un ticket d'assistance
      </h2>

      {status && (
        <div
          className={`p-4 mb-6 rounded-lg text-sm font-medium ${
            status.type === 'success'
              ? 'bg-emerald-50 text-emerald-800 dark:bg-emerald-950/50 dark:text-emerald-300'
              : 'bg-rose-50 text-rose-800 dark:bg-rose-950/50 dark:text-rose-300'
          }`}
        >
          {status.message}
        </div>
      )}

      <form onSubmit={handleSubmit} className="space-y-5">
        <div>
          <label className="block text-sm font-medium text-slate-700 dark:text-slate-300 mb-1">
            Sujet du ticket
          </label>
          <input
            type="text"
            required
            value={title}
            onChange={(e) => setTitle(e.target.value)}
            placeholder="ex: Problème d'accès au module..."
            className="w-full px-4 py-2 rounded-lg border border-slate-300 dark:border-slate-700 bg-white dark:bg-slate-800 text-slate-900 dark:text-white focus:ring-2 focus:ring-indigo-500 outline-none transition"
          />
        </div>

        <div>
          <label className="block text-sm font-medium text-slate-700 dark:text-slate-300 mb-1">
            Urgence
          </label>
          <select
            value={urgency}
            onChange={(e) => setUrgency(e.target.value)}
            className="w-full px-4 py-2 rounded-lg border border-slate-300 dark:border-slate-700 bg-white dark:bg-slate-800 text-slate-900 dark:text-white focus:ring-2 focus:ring-indigo-500 outline-none transition"
          >
            <option value="1">Très basse</option>
            <option value="2">Basse</option>
            <option value="3">Moyenne</option>
            <option value="4">Haute</option>
            <option value="5">Très haute</option>
          </select>
        </div>

        <div>
          <label className="block text-sm font-medium text-slate-700 dark:text-slate-300 mb-1">
            Description détaillée
          </label>
          <textarea
            required
            rows={5}
            value={description}
            onChange={(e) => setDescription(e.target.value)}
            placeholder="Décrivez précisément votre problème..."
            className="w-full px-4 py-2 rounded-lg border border-slate-300 dark:border-slate-700 bg-white dark:bg-slate-800 text-slate-900 dark:text-white focus:ring-2 focus:ring-indigo-500 outline-none transition resize-none"
          />
        </div>

        <div>
          <label className="block text-sm font-medium text-slate-700 dark:text-slate-300 mb-1">
            Pièces jointes
          </label>
          <input
            type="file"
            multiple
            onChange={(e) => setFiles(e.target.files)}
            className="w-full text-sm text-slate-500 dark:text-slate-400 file:mr-4 file:py-2 file:px-4 file:rounded-lg file:border-0 file:text-sm file:font-semibold file:bg-indigo-50 file:text-indigo-700 hover:file:bg-indigo-100 dark:file:bg-slate-800 dark:file:text-indigo-400"
          />
        </div>

        <button
          type="submit"
          disabled={loading}
          className="w-full py-3 px-4 bg-indigo-600 hover:bg-indigo-700 disabled:opacity-50 text-white font-semibold rounded-lg shadow transition flex items-center justify-center"
        >
          {loading ? (
            <span className="inline-block animate-spin rounded-full h-5 w-5 border-2 border-white border-t-transparent" />
          ) : (
            'Envoyer le ticket'
          )}
        </button>
      </form>
    </div>
  );
}
