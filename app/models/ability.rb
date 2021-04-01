# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    @user = user

    if @user
      @user.admin? ? admin_abilities : user_abilities
    else
      guest_abilities
    end
  end

  private

  def guest_abilities
    can :read, :all
  end

  def admin_abilities
    can :manage, :all
  end

  def user_abilities
    guest_abilities

    user_question_abilities
    user_answer_abilities
    user_vote_abilities

    can :create, Comment

    can :destroy, ActiveStorage::Attachment, record: { author_id: @user.id }
    can :destroy, Link, linkable: { author_id: @user.id }
  end

  def user_answer_abilities
    can :create, Answer
    can %i[update destroy], Answer, author_id: @user.id
  end

  def user_vote_abilities
    can :create, Vote
    can :destroy, Vote, author_id: @user.id
  end

  def user_question_abilities
    can :create, Question
    can %i[update destroy set_best_answer], Question, author_id: @user.id
  end
end
