# Copilot Instructions for Le Vélo Vert

## Project Overview
**Le Vélo Vert** is a Ruby on Rails 7.0 bike-rental e-commerce platform with public browsing/reservation features and a complete admin management backend.

### Core Purpose
Enable users to browse bikes, itineraries, and news, then make online reservations. Admins manage inventory, routes, news, and reservations through a protected dashboard.

---

## Architecture & Data Flow

### MVC Structure
- **Models**: `app/models/` - Core domain logic (Velo, Reservation, Itineraire, Actualite, Admin)
- **Controllers**: `app/controllers/` - Public routes + `admin/` namespace for admin routes
- **Views**: `app/views/` - ERB templates organized by controller + shared `layouts/`

### Key Entities & Relationships
| Entity | Purpose | Key Fields | Relations |
|--------|---------|-----------|-----------|
| **Velo** | Bike inventory | nom, type_velo, tarif_heure/jour, disponible, image | has_one_attached :image |
| **Reservation** | Booking record | nom, prenom, email, telephone, date_debut/fin, velo_id | belongs_to :velo |
| **Itineraire** | Tour routes | nom, distance_km, duree_minutes, niveau | Standalone |
| **Actualite** | News/events | titre, contenu, date_publication | Standalone |
| **Admin** | User accounts | email, password_digest (bcrypt) | Authenticates via session |

### Request Flow Example (Reservation)
1. User visits `/reservations/new` → `ReservationsController#new` loads available bikes
2. Form posts to `POST /reservations` → `#create` validates & saves
3. Success redirects to `/reservations/:id` → `#show` displays confirmation
4. Admin views all reservations at `/admin/reservations` (requires auth)

---

## Key Development Patterns

### Authentication Pattern
- Admin authentication uses **session-based** with `bcrypt` password hashing
- `ApplicationController#require_admin` before_action guards `/admin/*` routes
- No API tokens; uses Rails session cookies (`session[:admin_id]`)
- **Default credentials** (seeds.rb): `admin@levelopert.fr` / `admin123` (change in production)

### Validation Pattern
- Use ActiveRecord `validates` in models (presence, format, numericality)
- Custom validations for business logic: e.g., `date_fin_apres_date_debut` in Reservation
- Render `:new` with `status: :unprocessable_entity` on validation failure (see ReservationsController#create)

### Scope Pattern
```ruby
# Reservation model examples
scope :recentes, -> { order(created_at: :desc) }
scope :a_venir, -> { where('date_debut > ?', Date.today) }
scope :en_cours, -> { where('date_debut <= ? AND date_fin >= ?', Date.today, Date.today) }
```

### Admin Controller Structure
All admin controllers inherit from `Admin::BaseController` which:
- Enforces `before_action :require_admin`
- Uses `layout 'admin'` (separate from public layout)
- Provides CRUD routes via `resources :velos` etc. in routes.rb

---

## Workflow & Commands

### Local Development
```bash
bundle install           # Install gems from Gemfile
rails db:create         # Create SQLite database
rails db:migrate        # Run migrations in db/migrate/
rails db:seed           # Load sample data (bikes, routes, news)
rails server            # Start Puma at http://localhost:3000
```

### File Structure Conventions
- **Models**: Singular (`velo.rb`, `reservation.rb`)
- **Controllers**: Plural (`velos_controller.rb`); admin nested under `admin/`
- **Views**: Plural folder matching controller (`/velos/show.html.erb`)
- **Migrations**: Numbered timestamp prefix; add features to existing tables carefully

### Database Changes
1. Create migration: `rails generate migration AddFieldNameToTableName field_name:type`
2. Edit migration file in `db/migrate/`
3. Run: `rails db:migrate`
4. Update model validations and associations accordingly
5. Regenerate schema with `rails db:schema:load`

### Testing Approach
- Primarily manual testing via Rails console: `rails console`
- Check models in console: `Velo.all`, `Reservation.find(1)`
- Validate logic: `reservation.valid?`, `reservation.errors.full_messages`

---

## Project-Specific Conventions

### Locale & Naming
- **Language**: French (routes, model attributes, error messages)
- **Naming**: French column names (`nom`, `prenom`, `date_debut`, `tarif_heure`)
- **Locale file**: `config/locales/fr.yml` for i18n

### Date Handling
- Reservations use `date_debut` and `date_fin` (not datetimes; dates only)
- Duration calculation: `(date_fin - date_debut).to_i + 1` (inclusive, adds 1 day)
- Scopes filter by `Date.today` for "upcoming" and "ongoing" reservations

### Bike Types Enumeration
```ruby
# app/models/velo.rb
TYPES = ['VTT', 'Vélo de ville', 'Vélo électrique', 'Vélo enfant', 'Vélo cargo'].freeze
```
Always validate `type_velo` against this list when creating bikes.

### Image Storage
- Uses **Active Storage** (Rails built-in)
- Velos have `has_one_attached :image`
- Images stored via `config/storage.yml` (defaults to local `storage/` folder)

### Admin Layout
- Public pages use `app/views/layouts/application.html.erb`
- Admin pages use `app/views/layouts/admin.html.erb` (different styling/nav)
- Admin views organized parallel to public: `app/views/admin/velos/`, etc.

---

## Critical Integration Points

### Database Migrations
- Located in `db/migrate/` with timestamp naming
- Managed via Rails migrations system (`db:create`, `db:migrate`, `db:rollback`)
- Schema auto-generated to `db/schema.rb` — never edit manually

### Helper Methods (ApplicationHelper)
- Shared across all views via `app/helpers/application_helper.rb`
- Extend with formatting helpers if needed (e.g., price formatting)

### Asset Pipeline
- CSS: `app/assets/stylesheets/application.css` (simple single file, not SCSS)
- Images: `app/assets/images/velos/` for bike photos
- Manifest: `app/assets/config/manifest.js`

### Error Handling Pattern
```ruby
# Standard pattern in controllers (see ReservationsController#show)
@reservation = Reservation.find(params[:id])
rescue ActiveRecord::RecordNotFound
  flash[:alert] = "Réservation non trouvée."
  redirect_to root_path
```

---

## Common Tasks for AI Agents

### Adding a New Feature
1. Create migration for any new tables/columns
2. Define model with validations and scopes
3. Add controller with RESTful actions (public and/or admin)
4. Create views using ERB (follow existing layout)
5. Add routes in `config/routes.rb`
6. Test via Rails console and browser

### Modifying Bike Data Model
- Update `app/models/velo.rb` validations
- Create migration for schema changes
- Regenerate schema
- Update admin views (`app/views/admin/velos/{new,edit}.html.erb`)

### Admin Authentication Issues
- Check `session[:admin_id]` is set after login (`admin/sessions_controller.rb`)
- Ensure `before_action :require_admin` is called
- Verify `Admin` model exists with bcrypt password validation

### Fixing Reservations
- Validate date logic: ensure `date_fin >= date_debut`
- Check `velo_id` exists and bike is `disponible: true`
- Duration calculation: inclusive range (`duree_jours` method)
- Email validation: uses `URI::MailTo::EMAIL_REGEXP`

---

## Dependencies & External Services
- **Framework**: Rails 7.0, Ruby 3.4.0
- **Database**: SQLite3 (development/test)
- **Auth**: bcrypt (password hashing only)
- **Styling**: Plain CSS (no framework like Bootstrap)
- **Storage**: Active Storage (local disk in dev)
- **No external APIs**: Self-contained application

---

## Red Flags & Gotchas
- **Admin authentication**: Session-based only; no token auth for APIs
- **Date-only fields**: Reservations use `date` not `datetime` (no time zones)
- **Bike images**: Require `has_one_attached` in Velo model; only one image per bike
- **French conventions**: Model attributes in French; adjust queries accordingly
- **No password recovery**: Admin must manually reset via Rails console if locked out
