class Admin::ParticipantsController < Admin::AdminController
  before_action :create_params, only: [:show, :edit, :update, :destroy]
  def index
    @participant_list = Participant.all
  end

  def show
  end

  def edit
  end

  def update
    if @participant.update(participant_params)
      redirect_to edit_admin_participant_path(params[:id]), notice: '更新成功'
    else
      redirect_to edit_admin_participant_path(params[:id]), alert: '更新失敗'
    end
  end

  def destroy
    if Participant.destroy(@participant)
      redirect_to admin_participants_path, notice: '削除成功'
    else
      redirect_to edit_admin_participant_path(params[:id]), notice: '削除失敗'
    end
  end

  private

  def create_params
    @participant = Participant.find(params[:id])
  end

  def participant_params
    params.permit(:name, :kana, :email, :belong)
  end
end
