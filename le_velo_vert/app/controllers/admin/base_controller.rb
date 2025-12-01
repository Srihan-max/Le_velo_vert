# Contrôleur de base pour toute la zone admin
# Toutes les pages admin héritent de ce contrôleur
class Admin::BaseController < ApplicationController
  before_action :require_admin
  
  layout 'admin'
end
