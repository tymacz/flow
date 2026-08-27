"use client";

import { useState } from "react";

export default function TicketForm() {
  const [title, setTitle] = useState("");
  const [description, setDescription] = useState("");
  const [urgency, setUrgency] = useState("3");
  const [files, setFiles] = useState<FileList | null>(null);
  const [loading, setLoading] = useState(false);
  const [status, setStatus] = useState<{
    type: "success" | "error";
    message: string;
  } | null>(null);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setLoading(true);
    setStatus(null);

    // Construction du FormData
    const formData = new FormData();
    formData.append("title", title);
    formData.append("description", description);
    formData.append("urgency", urgency);

    if (files) {
      Array.from(files).forEach((file) => {
        formData.append("attachments[]", file);
      });
    }

    try {
      const response = await fetch("/api/tickets", {
        method: "POST",
        body: formData, // Pas de Content-Type header manuel, le navigateur le gère avec le boundary
      });

      const data = await response.json();

      if (!response.ok) {
        throw new Error(data.message ?? "Une erreur est survenue.");
      }

      setStatus({
        type: "success",
        message: `Ticket #${data.glpi_id ?? ""} créé avec succès !`,
      });
      setTitle("");
      setDescription("");
      setUrgency("3");
      setFiles(null);
    } catch (err: any) {
      setStatus({
        type: "error",
        message: err.message ?? "Impossible d'envoyer le ticket.",
      });
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="mx-auto max-w-xl rounded-xl border border-slate-200 bg-white p-6 shadow-md dark:border-slate-800 dark:bg-slate-900">
      <h2 className="mb-6 text-2xl font-bold text-slate-900 dark:text-white">
        Ouvrir un ticket d&apos;assistance
      </h2>

      {status && (
        <div
          className={`mb-6 rounded-lg p-4 text-sm font-medium ${
            status.type === "success"
              ? "bg-emerald-50 text-emerald-800 dark:bg-emerald-950/50 dark:text-emerald-300"
              : "bg-rose-50 text-rose-800 dark:bg-rose-950/50 dark:text-rose-300"
          }`}
        >
          {status.message}
        </div>
      )}

      <form onSubmit={handleSubmit} className="space-y-5">
        <div>
          <label className="mb-1 block text-sm font-medium text-slate-700 dark:text-slate-300">
            Sujet du ticket
          </label>
          <input
            type="text"
            required
            value={title}
            onChange={(e) => setTitle(e.target.value)}
            placeholder="ex: Problème d'accès au module..."
            className="w-full rounded-lg border border-slate-300 bg-white px-4 py-2 text-slate-900 transition outline-none focus:ring-2 focus:ring-indigo-500 dark:border-slate-700 dark:bg-slate-800 dark:text-white"
          />
        </div>

        <div>
          <label className="mb-1 block text-sm font-medium text-slate-700 dark:text-slate-300">
            Urgence
          </label>
          <select
            value={urgency}
            onChange={(e) => setUrgency(e.target.value)}
            className="w-full rounded-lg border border-slate-300 bg-white px-4 py-2 text-slate-900 transition outline-none focus:ring-2 focus:ring-indigo-500 dark:border-slate-700 dark:bg-slate-800 dark:text-white"
          >
            <option value="1">Très basse</option>
            <option value="2">Basse</option>
            <option value="3">Moyenne</option>
            <option value="4">Haute</option>
            <option value="5">Très haute</option>
          </select>
        </div>

        <div>
          <label className="mb-1 block text-sm font-medium text-slate-700 dark:text-slate-300">
            Description détaillée
          </label>
          <textarea
            required
            rows={5}
            value={description}
            onChange={(e) => setDescription(e.target.value)}
            placeholder="Décrivez précisément votre problème..."
            className="w-full resize-none rounded-lg border border-slate-300 bg-white px-4 py-2 text-slate-900 transition outline-none focus:ring-2 focus:ring-indigo-500 dark:border-slate-700 dark:bg-slate-800 dark:text-white"
          />
        </div>

        <div>
          <label className="mb-1 block text-sm font-medium text-slate-700 dark:text-slate-300">
            Pièces jointes
          </label>
          <input
            type="file"
            multiple
            onChange={(e) => setFiles(e.target.files)}
            className="w-full text-sm text-slate-500 file:mr-4 file:rounded-lg file:border-0 file:bg-indigo-50 file:px-4 file:py-2 file:text-sm file:font-semibold file:text-indigo-700 hover:file:bg-indigo-100 dark:text-slate-400 dark:file:bg-slate-800 dark:file:text-indigo-400"
          />
        </div>

        <button
          type="submit"
          disabled={loading}
          className="flex w-full items-center justify-center rounded-lg bg-indigo-600 px-4 py-3 font-semibold text-white shadow transition hover:bg-indigo-700 disabled:opacity-50"
        >
          {loading ? (
            <span className="inline-block h-5 w-5 animate-spin rounded-full border-2 border-white border-t-transparent" />
          ) : (
            "Envoyer le ticket"
          )}
        </button>
      </form>
    </div>
  );
}
