namespace :admin do
  desc "Créer un nouvel administrateur"
  task :create => :environment do
    puts "Email :"
    email = STDIN.gets.chomp
    puts "Mot de passe :"
    password = STDIN.gets.chomp
    
    admin = Admin.create(email: email, password: password)
    if admin.valid?
      puts "✅ Admin créé : #{admin.email}"
    else
      puts "❌ Erreur : #{admin.errors.full_messages.join(', ')}"
    end
  end

  desc "Lister tous les admins"
  task :list => :environment do
    Admin.all.each do |admin|
      puts "📧 #{admin.email} (créé le #{admin.created_at.strftime('%d/%m/%Y')})"
    end
  end

  desc "Supprimer un admin par email"
  task :delete => :environment do
    puts "Email de l'admin à supprimer :"
    email = STDIN.gets.chomp
    
    admin = Admin.find_by(email: email)
    if admin
      admin.destroy
      puts "✅ Admin supprimé : #{email}"
    else
      puts "❌ Admin introuvable : #{email}"
    end
  end
end
