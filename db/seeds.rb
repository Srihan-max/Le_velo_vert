puts "🌱 Nettoyage de la base de données..."
Reservation.destroy_all
Actualite.destroy_all
Itineraire.destroy_all
Velo.destroy_all
Admin.destroy_all

puts "🚴 Création des vélos..."

# Création des vélos
vtt = Velo.create!(
  nom: "VTT Sport Pro",
  type_velo: "VTT",
  description: "Vélo tout-terrain haut de gamme avec suspension complète, idéal pour les parcours difficiles et les sentiers de montagne. Équipé de 21 vitesses et de freins à disque hydrauliques.",
  tarif_heure: 8.0,
  tarif_jour: 35.0,
  disponible: true
)

ville = Velo.create!(
  nom: "Vélo de Ville Confort",
  type_velo: "Vélo de ville",
  description: "Vélo urbain confortable avec panier avant et garde-boue. Parfait pour vos déplacements quotidiens en ville. Selle ergonomique et position de conduite relaxante.",
  tarif_heure: 5.0,
  tarif_jour: 20.0,
  disponible: true
)

electrique = Velo.create!(
  nom: "E-Bike Urbain",
  type_velo: "Vélo électrique",
  description: "Vélo électrique avec assistance jusqu'à 25 km/h, autonomie de 80 km. Idéal pour les longues distances sans effort. Batterie amovible et rechargeable.",
  tarif_heure: 12.0,
  tarif_jour: 50.0,
  disponible: true
)

enfant = Velo.create!(
  nom: "Vélo Enfant 6-10 ans",
  type_velo: "Vélo enfant",
  description: "Vélo adapté aux enfants de 6 à 10 ans, avec petites roues optionnelles. Coloré et sécurisé avec sonnette et réflecteurs.",
  tarif_heure: 3.0,
  tarif_jour: 12.0,
  disponible: true
)

cargo = Velo.create!(
  nom: "Vélo Cargo Familial",
  type_velo: "Vélo cargo",
  description: "Vélo cargo 3 roues avec grande caisse avant pouvant transporter jusqu'à 100kg. Idéal pour les courses ou transporter les enfants. Très stable.",
  tarif_heure: 10.0,
  tarif_jour: 40.0,
  disponible: true
)

puts "📸 Ajout des images aux vélos..."

# Attachement des images Active Storage
vtt.image.attach(
  io: File.open(Rails.root.join("app/assets/images/velos/vtt.jpg")),
  filename: "vtt.jpg",
  content_type: "image/jpeg"
)

ville.image.attach(
  io: File.open(Rails.root.join("app/assets/images/velos/velo_ville.jpg")),
  filename: "velo_ville.jpg",
  content_type: "image/jpeg"
)

electrique.image.attach(
  io: File.open(Rails.root.join("app/assets/images/velos/electrique.jpg")),
  filename: "electrique.jpg",
  content_type: "image/jpeg"
)

enfant.image.attach(
  io: File.open(Rails.root.join("app/assets/images/velos/enfant.jpg")),
  filename: "enfant.jpg",
  content_type: "image/jpeg"
)

cargo.image.attach(
  io: File.open(Rails.root.join("app/assets/images/velos/cargo.jpg")),
  filename: "cargo.jpg",
  content_type: "image/jpeg"
)

puts "✅ #{Velo.count} vélos créés avec images"

puts "🗺️ Création des itinéraires..."

Itineraire.create!([
  {
    nom: "Balade en centre-ville",
    description: "Découvrez les principaux monuments et sites touristiques...",
    distance_km: 8.5,
    duree_minutes: 60,
    niveau: "Débutant"
  },
  {
    nom: "Sortie nature au bois de Vincennes",
    description: "Échappez à l'agitation urbaine...",
    distance_km: 15.0,
    duree_minutes: 120,
    niveau: "Intermédiaire"
  },
  {
    nom: "Circuit des bords de Seine",
    description: "Longez la Seine sur les quais aménagés...",
    distance_km: 12.0,
    duree_minutes: 90,
    niveau: "Débutant"
  },
  {
    nom: "Parcours sportif vallonné",
    description: "Pour les cyclistes expérimentés !",
    distance_km: 35.0,
    duree_minutes: 180,
    niveau: "Sportif"
  },
  {
    nom: "Tour des châteaux",
    description: "Itinéraire culturel passant par trois châteaux...",
    distance_km: 25.0,
    duree_minutes: 150,
    niveau: "Intermédiaire"
  }
])

puts "✅ #{Itineraire.count} itinéraires créés"

puts "📰 Création des actualités..."

Actualite.create!([
  {
    titre: "Journée sans voiture - 22 septembre 2024",
    contenu: "Le dimanche 22 septembre, Paris célèbre...",
    date_publication: Date.today - 10.days
  },
  {
    titre: "Nouveaux itinéraires découverte",
    contenu: "Nous sommes ravis de vous présenter nos nouveaux itinéraires...",
    date_publication: Date.today - 20.days
  },
  {
    titre: "Atelier entretien vélo - Tous les samedis",
    contenu: "Le Vélo Vert lance ses ateliers...",
    date_publication: Date.today - 5.days
  }
])

puts "✅ #{Actualite.count} actualités créées"

puts "👤 Création du compte administrateur..."

Admin.create!(
  email: "admin@levelopert.fr",
  password: "admin123",
  password_confirmation: "admin123"
)

puts "🎉 Seed terminé avec succès !"
puts "📊 Résumé :"
puts "   - #{Velo.count} vélos"
puts "   - #{Itineraire.count} itinéraires"
puts "   - #{Actualite.count} actualités"
puts "   - #{Admin.count} administrateur"