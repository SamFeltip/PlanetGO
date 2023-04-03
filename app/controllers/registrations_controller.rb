class RegistrationsController < Devise::RegistrationsController
  def new
    @outing = Outing.find_by_invite_token(params[:invite_token]) if params[:invite_token]
    super
  end

  def create
    super
    if resource.save && params[:user].key?(:invite_token)
      outing = Outing.find_by_invite_token(params[:user][:invite_token])
      Participant.create(outing: outing, user: resource)
    end
  end
end