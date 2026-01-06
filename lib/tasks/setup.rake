namespace :setup do
  desc "Configuration complète du projet (db:create, migrate, seed)"
  task :all => :environment do
    puts "🚀 Démarrage de la configuration..."
    
    Rake::Task["db:create"].invoke
    Rake::Task["db:migrate"].invoke
    Rake::Task["db:seed"].invoke
    
    puts "✅ Configuration terminée !"
  end

  desc "Réinitialiser la base (destroy, create, migrate, seed)"
  task :reset => :environment do
    puts "🔄 Réinitialisation complète..."
    
    Rake::Task["db:drop"].invoke
    Rake::Task["db:create"].invoke
    Rake::Task["db:migrate"].invoke
    Rake::Task["db:seed"].invoke
    
    puts "✅ Base réinitialisée !"
  end
end
