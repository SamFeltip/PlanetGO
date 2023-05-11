# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    # Guard check to make sure user exists

    can %i[show search read], Event

    return if user.blank?

    if user.admin?
      admin_permissions(user)
      reporter_permissions
      advertiser_permissions(user)
      user_permissions(user)
    elsif user.reporter?
      reporter_permissions
    elsif user.advertiser?
      advertiser_permissions(user)
    elsif user.user?
      user_permissions(user)
    end
  end

  def user_permissions(user)
    commercial_permissions(user)
  end

  def advertiser_permissions(user)
    commercial_permissions(user)
  end

  def commercial_permissions(user)
    can :read, User
    can %i[create show like search read], Event
    can %i[edit read update destroy manage], Event, user_id: user.id
    can :create, Outing
    can %i[index show edit read update destroy set_details send_invites stop_count], Outing, creator_id: user.id
    can %i[index show read vote], Outing, participants: { user_id: user.id, status: 'confirmed' }
    can %i[index], Outing, participants: { user_id: user.id }
    can %i[index search requests follow unfollow accept decline cancel], :friend
    can %i[index set_interest], CategoryInterest, user_id: user.id

    can %i[destroy update read edit], ProposedEvent, outing: { creator_id: user.id }

    can :create, BugReport
    can %i[edit read update], BugReport, user_id: user.id
    can :destroy, BugReport, user_id: user.id, resolved: false

    return unless user.suspended

    cannot %i[create update destroy], Event
    cannot %i[create update destroy], Outing
  end

  def reporter_permissions
    can :manage, Metric
  end

  def admin_permissions(user)
    can %i[update destroy lock unlock suspend reinstate], User
    cannot %i[update destroy lock unlock suspend reinstate], User, id: user.id

    can :manage, Category
    can :manage, CategoryInterest
    can :manage, Event
    can :manage, Outing
    can :manage, BugReport
    can :manage, Comment
  end
end
