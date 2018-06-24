class Admin::FamilyController < Admin::AdminController
  before_action :create_params, only: [:show, :edit, :update]
  def index
    @users = User.where(is_family: true)
  end

  def show
    @requests = EmailQueue.where(
        email_type: Settings.email_type.request,
        to_address: @user.contact.email_pc
    )
  end

  def new
    # TODO: user.timestamp発行機能
  end

  def edit
  end

  def update
    if @user.update(family_params) and
       @user.contact.update(contact_params) and
       @user.location.update(location_params) and
       @user.profile_family.update(profile_family_params) and
       @mother.update(mother_params) and
       @father.update(father_params)
      redirect_to edit_admin_family_path(params[:id]), notice: '更新成功'
    else
      redirect_to edit_admin_family_path(params[:id]), alert: '更新失敗'
    end
  end

  def destroy
    @user = User.find(params[:id])
    if @user.destroy
      redirect_to admin_family_index_path, notice: '削除成功'
    else
      redirect_to admin_family_index_path, notice: '削除失敗'
    end
  end

  private

  def create_params
    @user = User.find(params[:id])
    @mother = @user.profile_family&.profile_individuals&.find_by(role: 'mother')
    @father = @user.profile_family&.profile_individuals&.find_by(role: 'father')
  end

  def family_params
    p = params.permit(:name, :kana, :gender)
    p[:gender] = p[:gender].to_i
    p
  end

  def location_params
    params.permit(:address)
  end

  def contact_params
    params.permit(:email_pc, :email_phone, :phone_number)
  end

  def profile_family_params
    p = params.permit(
      :job_style, :first_childbirth_mother_age,
      :married_mother_age, :number_of_children, :child_birthday,
      :has_time_shortening_experience,
      :has_childcare_leave_experience,
      :has_job_change_experience,
      :is_photo_ok, :is_report_ok, :is_male_ok,
      :opinion_or_question
    )
    p[:job_style] = p[:job_style].to_i
    p
  end

  def mother_params
    individual_params(
      :birthday_mother_submit, :job_domain_mother,
      :hometown_mother, :company_mother,
      :career_mother, :is_abroad_mother
    )
  end

  def father_params
    individual_params(
      :birthday_father_submit, :job_domain_father,
      :hometown_father, :company_father,
      :career_father, :is_abroad_father
    )
  end

  def individual_params(birthday, job_domain, hometown, company, career, is_abroad)
    p = params.permit(birthday, hometown, job_domain, company, career, is_abroad)

    # TODO: 指定フォーマットに変換
    p[birthday]
    p[:birthday] = p[birthday]
    p[:job_domain] = JobDomain.find(p[job_domain])
    p[:hometown] = p[hometown]
    p[:company] = p[company]
    p[:career] = p[career]
    p[:has_experience_abroad] = p[is_abroad]

    p.delete(birthday)
    p.delete(job_domain)
    p.delete(hometown)
    p.delete(company)
    p.delete(career)
    p.delete(is_abroad)
    p
  end

end
