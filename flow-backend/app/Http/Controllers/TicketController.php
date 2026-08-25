<?php

namespace App\Http\Controllers;

use App\Http\Controllers\Controller;
use App\Services\GLPIService;
use Illuminate\Http\Request;

class TicketController extends Controller
{
    public function store(Request $request, GLPIService $glpiService)
{
    $validated = $request->validate([
        'title' => 'required|string|max:255',
        'description' => 'required|string',
        'urgency' => 'nullable|integer|between:1,5',
        'attachments.*' => 'nullable|file|max:10240', // Max 10 Mo par fichier
    ]);

    $files = $request->file('attachments', []);

    $ticket = $glpiService->createTicket(
        $validated['title'],
        $validated['description'],
        (int) ($validated['urgency'] ?? 3),
        $files
    );

    if (!$ticket) {
        return response()->json(['message' => 'Erreur lors de la création du ticket GLPI'], 500);
    }

    return response()->json([
        'message' => 'Ticket et fichiers transmis avec succès',
        'glpi_id' => $ticket['id'],
    ], 201);
}
}
