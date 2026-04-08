class Users::RegistrationsController < Devise::RegistrationsController

  before_action :configure_permitted_parameters, if: :devise_controller?

  def update
    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)

    if resource.update_without_password(account_update_params)
      set_flash_message :notice, :updated
      bypass_sign_in resource, scope: resource_name
      redirect_to edit_user_registration_path, notice: "Account updated successfully."
    else
      clean_up_passwords resource
      set_minimum_password_length
      render :edit, status: :unprocessable_entity
    end
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:account_update, keys: [:address, :province_id])
  end
end