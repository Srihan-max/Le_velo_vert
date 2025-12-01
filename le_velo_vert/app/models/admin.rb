# Modèle représentant un administrateur du site
class Admin < ApplicationRecord
  # Active Model pour l'authentification sécurisée
  has_secure_password
  
  # Validations
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, length: { minimum: 6 }, if: :password_digest_changed?
end
