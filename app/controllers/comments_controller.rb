# frozen_string_literal: true

class CommentsController < ApplicationController
  def create
    @comment = Comment.new(comment_params)
    if @comment.save
      redirect_to @comment.bug_report, notice: 'Comment created successfully.'
    else
      redirect_back fallback_location: root_path, alert: 'Content is too long (maximum is 1000 characters)'
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:content, :user_id, :bug_report_id)
  end
end
