class ApplicationController < ActionController::Base
  include Pundit::Authorization

  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  after_action :verify_authorized, except: %i[index], unless: :skip_pundit?
  after_action :verify_policy_scoped, only: %i[index], unless: :skip_pundit?

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: extra_params)
    devise_parameter_sanitizer.permit(:account_update, keys: extra_params)
  end

  private

  def skip_pundit?
    devise_controller? || params[:controller] =~ /(^(rails_)?admin)|(^pages$)/
  end

  def extra_params
    [:first_name, :last_name, :country, :state, :city, :professional_field,
    :field_of_work, :academic_degree, { programming_language: [] },
    :mentor_current_employer, :years_of_experience, :github, :linkedin,
    :personal_site,:other_info, :mentor, :photo, :about_me, :professional_about,
    :transition_about]
  end
end
