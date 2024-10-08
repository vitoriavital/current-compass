class ProfilesController < ApplicationController
  before_action :redirect_to_root, only: %i[index], if: -> { current_user.mentor? }

  def index
    @users = policy_scope(User)
    redirect_to profile_matches_path(current_user) if Match.where(mentee_id: current_user.id).exists?
    @mentors = helpers.match(current_user)
  end

  def show
    @user = User.find(params[:id])
    @match = Match.new

    if current_user.mentor?
      fetch_mentor_matched
      @matched.nil? && current_user != @user ? redirect_to_root : @matched
    elsif current_user.mentor == false
      fetch_mentee_matched
      !current_match.nil? && @matched.nil? && current_user != @user ? redirect_to_root : @matched
    end

    authorize @user
  end

  private

  def redirect_to_root
    redirect_to root_path
  end

  def fetch_mentor_matched
    @matched = Match.where(mentor_id: current_user.id, mentee_id: @user.id).first
  end

  def fetch_mentee_matched
    current_match = Match.where(mentee_id: current_user.id).first
    @matched = Match.where(mentor_id: @user.id, mentee_id: current_user.id).first
  end
end
