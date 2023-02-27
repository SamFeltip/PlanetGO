# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)

    if user.blank?
      guest_permissions
      return
    end

    if user.admin?
      admin_permissions(user)
      reporter_permissions
      user_permissions
      guest_permissions
    elsif user.reporter?
      reporter_permissions
      user_permissions
      guest_permissions
    elsif user.user?
      user_permissions
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
    can :read, Review
    can :read, Faq
    can :create, RegisterInterest
  end

  def user_permissions
    can %i[create like unlike], Review
    can %i[create like unlike], Faq
  end

  def reporter_permissions
    can :manage, Metric
  end

  def admin_permissions(user)
    can %i[read update destroy], User
    cannot %i[update destroy], User, id: user.id

    can :manage, RegisterInterest
    can :manage, Review
    can :manage, Faq
  end
end
