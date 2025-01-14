Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'welcome#index'


  get '/admin', to: 'admins#dashboard'

  get '/admin/merchants',                   to: 'admin_merchants#index'
  get '/admin/merchants/new',               to: 'admin_merchants#new'
  post '/admin/merchants',                  to: 'admin_merchants#create'
  patch '/admin/merchants/:merchant_id',    to: 'admin_merchants#update'
  get '/admin/merchants/:merchant_id/edit', to: 'admin_merchants#edit'
  get '/admin/merchants/:merchant_id',      to: 'admin_merchants#show'

  get '/admin/invoices',               to: 'admin_invoices#index'
  get '/admin/invoices/:invoice_id',   to: 'admin_invoices#show'
  patch '/admin/invoices/:invoice_id', to: 'admin_invoices#update'

  get '/merchants/:merchant_id/discounts', to: 'merchant_discounts#index'
  get '/merchants/:merchant_id/discounts/new', to: 'merchant_discounts#new'
  get '/merchants/:merchant_id/discounts/:discount_id', to: 'merchant_discounts#show'
  post '/merchants/:merchant_id/discounts', to: 'merchant_discounts#create'
  delete '/merchants/:merchant_id/discounts/:discount_id/destroy', to: 'merchant_discounts#destroy'
  get '/merchants/:merchant_id/discounts/:discount_id/edit', to: 'merchant_discounts#edit'
  patch '/merchants/:merchant_id/discounts/:discount_id', to: 'merchant_discounts#update'

  resources :merchants, only: [:show] do
    resources :dashboard, only: [:index]
    resources :items, except: [:destroy], controller: :merchant_items
    resources :item_status, only: [:update]
    resources :invoices, only: [:index, :show, :update], controller: :merchant_invoices
  end
end
