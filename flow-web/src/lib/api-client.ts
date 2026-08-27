import { getSession } from "next-auth/react";

const BASE_URL = process.env.NEXT_PUBLIC_API_URL ?? "http://192.168.1.3:8000";

async function request<T>(
  endpoint: string,
  options: RequestInit = {},
): Promise<T> {
  const url = `${BASE_URL}${endpoint}`;

  const headers = new Headers(options.headers);
  headers.set("Accept", "application/json");

  if (!headers.has("Content-Type") && !(options.body instanceof FormData)) {
    headers.set("Content-Type", "application/json");
  }

  // --- RÉCUPÉRATION DU TOKEN SANCTUM ---
  // On récupère la session actuelle de NextAuth côté client
  try {
    const session = await getSession();
    console.log("Token envoyé :", session?.user?.accessToken);
    // Si l'utilisateur est connecté et possède un jeton, on l'ajoute aux Headers
    if (session?.user?.accessToken) {
      headers.set("Authorization", `Bearer ${session.user.accessToken}`);
    }
  } catch (error) {
    console.warn(
      "Impossible de récupérer la session NextAuth pour le token.",
      error,
    );
  }
  // -------------------------------------

  const response = await fetch(url, { ...options, headers });

  if (!response.ok) {
    const errorData = await response.json().catch(() => ({}));
    throw new Error(errorData.message ?? `Erreur API: ${response.status}`);
  }

  // Si c'est une réponse vide (ex: un DELETE réussi qui renvoie 204 No Content)
  if (response.status === 204) return {} as T;

  return response.json() as Promise<T>;
}

export const apiClient = {
  get: <T>(endpoint: string, options?: RequestInit) =>
    request<T>(endpoint, { method: "GET", ...options }),

  post: <T>(endpoint: string, body: any, options?: RequestInit) =>
    request<T>(endpoint, {
      method: "POST",
      body: JSON.stringify(body),
      ...options,
    }),

  put: <T>(endpoint: string, body: any, options?: RequestInit) =>
    request<T>(endpoint, {
      method: "PUT",
      body: JSON.stringify(body),
      ...options,
    }),

  delete: <T>(endpoint: string, options?: RequestInit) =>
    request<T>(endpoint, { method: "DELETE", ...options }),
};
