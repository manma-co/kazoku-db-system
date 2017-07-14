class Admin::ParticipantsController < Admin::AdminController
  def index
    @participant_list = Participant.all
  end

  def show
  end
end
