import Link from "next/link";
import {
  Card,
  CardContent,
  CardDescription,
  CardHeader,
  CardTitle,
} from "@/components/ui/card";
import { Button } from "@/components/ui/button";

// Fausses données en attendant le branchement à l'API
const mockExercices = [
  { id: 1, titre: "Séance de Mobilité", duree: "15 min", categorie: "Récupération" },
  { id: 2, titre: "Cardio Haute Intensité", duree: "30 min", categorie: "HIIT" },
  { id: 3, titre: "Renforcement Ceinture Abdominale", duree: "20 min", categorie: "Force" },
];

const mockArticles = [
  { id: 1, titre: "L'importance de la récupération active", lecture: "5 min" },
  { id: 2, titre: "Comment bien structurer sa semaine d'entraînement", lecture: "8 min" },
  { id: 3, titre: "Nutrition : Que manger avant l'effort ?", lecture: "6 min" },
];

export default function HomePage() {
  return (
    <div className="container mx-auto max-w-7xl px-4 py-8 sm:px-6 lg:px-8 space-y-12">
      
      {/* En-tête de la page */}
      <section className="flex flex-col gap-2">
        <h1 className="text-3xl font-bold tracking-tight sm:text-4xl">
          Bonjour, prêt pour la session d&apos;aujourd&apos;hui ?
        </h1>
        <p className="text-muted-foreground text-lg">
          Retrouve ton programme et tes derniers articles pour rester motivé.
        </p>
      </section>

      {/* Section Exercices */}
      <section className="space-y-6">
        <div className="flex items-center justify-between">
          <h2 className="text-2xl font-semibold tracking-tight">Exercices recommandés</h2>
          <Button variant="ghost" asChild>
            <Link href="/exercices" className="text-primary hover:text-primary/80">
              Voir tout
            </Link>
          </Button>
        </div>
        
        {/* La Grille : 1 col sur mobile, 2 sur tablette, 3 sur bureau */}
        <div className="grid grid-cols-1 gap-6 sm:grid-cols-2 lg:grid-cols-3">
          {mockExercices.map((exo) => (
            <Link key={exo.id} href={`/exercices/${exo.id}`}>
              <Card className="group h-full transition-all duration-300 hover:-translate-y-1 hover:shadow-lg hover:border-primary/50 cursor-pointer">
                <CardHeader>
                  <div className="flex items-center justify-between mb-2">
                    <span className="inline-flex items-center rounded-full bg-primary/10 px-2.5 py-0.5 text-xs font-semibold text-primary">
                      {exo.categorie}
                    </span>
                    <span className="text-sm text-muted-foreground font-medium">
                      {exo.duree}
                    </span>
                  </div>
                  <CardTitle className="group-hover:text-primary transition-colors">
                    {exo.titre}
                  </CardTitle>
                </CardHeader>
                <CardContent>
                  <div className="aspect-video w-full rounded-md bg-muted flex items-center justify-center relative overflow-hidden">
                    {/* Espace réservé pour la miniature vidéo/image de l'exercice */}
                    <span className="text-muted-foreground text-sm flex items-center gap-2">
                      <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" className="lucide lucide-play-circle"><circle cx="12" cy="12" r="10"/><polygon points="10 8 16 12 10 16 10 8"/></svg>
                      Aperçu
                    </span>
                  </div>
                </CardContent>
              </Card>
            </Link>
          ))}
        </div>
      </section>

      {/* Section Articles */}
      <section className="space-y-6">
        <div className="flex items-center justify-between">
          <h2 className="text-2xl font-semibold tracking-tight">Derniers articles</h2>
          <Button variant="ghost" asChild>
            <Link href="/articles" className="text-primary hover:text-primary/80">
              Voir tout
            </Link>
          </Button>
        </div>
        
        <div className="grid grid-cols-1 gap-6 sm:grid-cols-2 lg:grid-cols-3">
          {mockArticles.map((article) => (
            <Link key={article.id} href={`/articles/${article.id}`}>
              <Card className="group h-full transition-all duration-300 hover:-translate-y-1 hover:shadow-md cursor-pointer flex flex-col justify-between">
                <CardHeader>
                  <CardTitle className="text-xl group-hover:text-primary transition-colors line-clamp-2">
                    {article.titre}
                  </CardTitle>
                  <CardDescription className="flex items-center gap-1 mt-2">
                    <svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" className="lucide lucide-clock"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg>
                    Lecture : {article.lecture}
                  </CardDescription>
                </CardHeader>
              </Card>
            </Link>
          ))}
        </div>
      </section>

    </div>
  );
}