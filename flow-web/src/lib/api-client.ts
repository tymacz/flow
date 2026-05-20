const BASE_URL = process.env.NEXT_PUBLIC_API_URL;

async function request<T>(endpoint: string, options: RequestInit = {}): Promise<T> {
  const url = `${BASE_URL}${endpoint}`;
  
  const headers = new Headers(options.headers);
  if (!headers.has("Content-Type") && !(options.body instanceof FormData)) {
    headers.set("Content-Type", "application/json");
  }

  // Si tu utilises des tokens JWT stockés, tu pourras les ajouter ici :
  // headers.set("Authorization", `Bearer ${token}`);

  const config: RequestInit = {
    ...options,
    headers,
  };

  const response = await fetch(url, config);

  if (!response.ok) {
    const errorData = await response.json().catch(() => ({}));
    throw new Error(errorData.message || `Erreur HTTP: ${response.status}`);
  }
  if (response.status === 204) {
    return {} as T;
  }

  return response.json() as Promise<T>;
}

export const apiClient = {
  get: <T>(endpoint: string, options?: RequestInit) => request<T>(endpoint, { method: "GET", ...options }),
  post: <T>(endpoint: string, body: any, options?: RequestInit) => request<T>(endpoint, { method: "POST", body: JSON.stringify(body), ...options }),
  put: <T>(endpoint: string, body: any, options?: RequestInit) => request<T>(endpoint, { method: "PUT", body: JSON.stringify(body), ...options }),
  patch: <T>(endpoint: string, body: any, options?: RequestInit) => request<T>(endpoint, { method: "PATCH", body: JSON.stringify(body), ...options }),
  delete: <T>(endpoint: string, options?: RequestInit) => request<T>(endpoint, { method: "DELETE", ...options }),
};