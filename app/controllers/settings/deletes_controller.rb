# frozen_string_literal: true

class Settings::DeletesController < ApplicationController
  layout 'admin'

  before_action :authenticate_user!

  def show
    @confirmation = Form::DeleteConfirmation.new
  end

  def destroy
    if current_user.valid_password?(delete_params[:password])
      Admin::SuspensionWorker.perform_async(current_user.account_id, true)
      sign_out
      redirect_to new_user_session_path, notice: I18n.t('deletes.success_msg')
    else
      redirect_to settings_delete_path, alert: I18n.t('deletes.bad_password_msg')
    end
  end

  private

  def delete_params
    params.require(:form_delete_confirmation).permit(:password)
  end
end
