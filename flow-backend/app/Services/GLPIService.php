<?php

namespace App\Services;

use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Log;
use Illuminate\Http\UploadedFile;

class GLPIService
{
    protected string $baseUrl;
    protected string $appToken;
    protected string $userToken;

    public function __construct()
    {
        $this->baseUrl = rtrim(config('services.glpi.url'), '/');
        $this->appToken = config('services.glpi.app_token', '');
        $this->userToken = config('services.glpi.user_token', '');
    }



    /**
     * Initialise une session API et renvoie le session_token.
     */
    protected function initSession(): ?string
    {
        $response = Http::withHeaders([
            'App-Token' => $this->appToken,
            'Authorization' => 'user_token ' . $this->userToken,
        ])->get("{$this->baseUrl}/initSession");

        if ($response->successful()) {
            return $response->json('session_token');
        }

        Log::error('GLPI initSession error', ['body' => $response->body()]);
        return null;
    }

    /**
     * Ferme la session API active.
     */
    protected function killSession(string $sessionToken): void
    {
        Http::withHeaders([
            'App-Token' => $this->appToken,
            'Session-Token' => $sessionToken,
        ])->get("{$this->baseUrl}/killSession");
    }

    protected function uploadDocument(UploadedFile $file, string $sessionToken): ?int
    {
        $manifest = json_encode([
            'input' => [
                'name' => $file->getClientOriginalName(),
                '_filename' => [$file->getClientOriginalName()],
            ]
        ]);
    
        $response = Http::withHeaders([
            'App-Token' => $this->appToken,
            'Session-Token' => $sessionToken,
        ])
        ->attach('uploadManifest', $manifest)
        ->attach('filename[0]', file_get_contents($file->getRealPath()), $file->getClientOriginalName())
        ->post("{$this->baseUrl}/Document");
    
        if ($response->successful()) {
            return $response->json('id');
        }
    
        Log::error('GLPI uploadDocument error', ['body' => $response->body()]);
        return null;
    }

    /**
     * Crée un ticket dans GLPI.
     */
    public function createTicket(string $title, string $content, int $urgency = 3, array $files = []): ?array
    {
        $sessionToken = $this->initSession();
    
        if (!$sessionToken) {
            return null;
        }
    
        try {
            // Upload de chaque fichier et récupération des IDs
            $documentIds = [];
            foreach ($files as $file) {
                if ($file instanceof UploadedFile) {
                    $docId = $this->uploadDocument($file, $sessionToken);
                    if ($docId) {
                        $documentIds[] = $docId;
                    }
                }
            }
    
            $input = [
                'name' => $title,
                'content' => $content,
                'urgency' => $urgency,
                'priority' => $urgency,
            ];
    
            // Liaison des documents créés au ticket
            if (!empty($documentIds)) {
                $input['_documents_id'] = $documentIds;
            }
    
            $response = Http::withHeaders([
                'App-Token' => $this->appToken,
                'Session-Token' => $sessionToken,
                'Content-Type' => 'application/json',
            ])->post("{$this->baseUrl}/Ticket", ['input' => $input]);
    
            return $response->successful() ? $response->json() : null;
        } finally {
            $this->killSession($sessionToken);
        }
    }

    /**
     * Récupère un ticket par son ID.
     */
    public function getTicket(int $ticketId): ?array
    {
        $sessionToken = $this->initSession();

        if (!$sessionToken) {
            return null;
        }

        try {
            $response = Http::withHeaders([
                'App-Token' => $this->appToken,
                'Session-Token' => $sessionToken,
            ])->get("{$this->baseUrl}/Ticket/{$ticketId}");

            return $response->successful() ? $response->json() : null;
        } finally {
            $this->killSession($sessionToken);
        }
    }
}
