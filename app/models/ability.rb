# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    # Guard check to make sure user exists
    if user.blank?
      guest_permissions
      return
    end

    if user.admin?
      admin_permissions(user)
      reporter_permissions
      advertiser_permissions(user)
      user_permissions(user)
      guest_permissions
    elsif user.reporter?
      reporter_permissions
      guest_permissions
    elsif user.advertiser?
      advertiser_permissions(user)
      guest_permissions
    elsif user.user?
      user_permissions(user)
      guest_permissions
    end

    # Define abilities for the user here. For example:
    #
    #   return unless user.present?
    #   can :read, :all
    #   return unless user.admin?
    #   can :manage, :all
    #
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, published: true
    #
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/blob/develop/docs/define_check_abilities.md
  end

  def guest_permissions
    can :create, RegisterInterest
  end

  def user_permissions(user)
    commercial_permissions(user)
  end

  def advertiser_permissions(user)
    commercial_permissions(user)
  end

  def commercial_permissions(user)
    can :read, User
    can :create, Event
    can %i[index show edit read update destroy], Event, user_id: user.id
    can :create, Outing
    can %i[index show edit read update destroy set_details send_invites], Outing, creator_id: user.id
    can %i[index search requests follow unfollow accept decline cancel], :friend
    can %i[index set_interest], CategoryInterest, user_id: user.id
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

    can :manage, RegisterInterest
    can :manage, Category
    can :manage, CategoryInterest
    can :manage, Event
    can :manage, Outing
  end
end
