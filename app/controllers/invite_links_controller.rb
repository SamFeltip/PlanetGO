class InviteLinksController < ApplicationController
    def show
        @outing = Outing.find_by_invite_token(params[:outing_invite_token])
        @outing.regenerate_invite_token
        @invite_link = new_outing_participant_url(@outing)
        respond_to do |format|
          format.html
          format.json { render json: { link: @invite_link, invite_token: @outing.invite_token } }
        end
      end
    end
end