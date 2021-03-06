class Accounts::RegistrationsController < Devise::RegistrationsController
# before_action :configure_sign_up_params, only: [:create]
# before_action :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  def new
    @teacher = Teacher.new
    @teacher.build_account
    @teacher.build_school_teacher
  end

  # POST /resource
  def create
    @teacher = Teacher.new(teacher_params)
    if @teacher.save
      SchoolTeacherMailer.new_teacher(@teacher.school_teacher).deliver_later
      flash[:notice] = 'Un message contenant un lien de confirmation a été envoyé à votre adresse email. Ouvrez ce lien pour activer votre compte.'
      redirect_to root_url
    else
      set_minimum_password_length
      render :new
    end
  end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  def destroy
    if current_account.role == 'teacher'
      super
    else
      redirect_to root_url
    end
  end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  # protected

  def teacher_params
    params.require(:teacher).permit(
      :school_id, account_attributes: [
        :first_name, :last_name, :email, :password, :password_confirmation
      ], school_teacher_attributes: [:school_id]
    )
  end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
  # end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end
