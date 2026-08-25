namespace App\Services;

use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Log;

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

    /**
     * Crée un ticket dans GLPI.
     */
    public function createTicket(string $title, string $content, int $urgency = 3, int $priority = 3): ?array
    {
        $sessionToken = $this->initSession();

        if (!$sessionToken) {
            return null;
        }

        try {
            $response = Http::withHeaders([
                'App-Token' => $this->appToken,
                'Session-Token' => $sessionToken,
                'Content-Type' => 'application/json',
            ])->post("{$this->baseUrl}/Ticket", [
                'input' => [
                    'name' => $title,
                    'content' => $content,
                    'urgency' => $urgency,
                    'priority' => $priority,
                ],
            ]);

            if ($response->successful()) {
                return $response->json();
            }

            Log::error('GLPI createTicket error', ['body' => $response->body()]);
            return null;
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
