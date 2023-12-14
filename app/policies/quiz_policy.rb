# frozen_string_literal: true

class QuizPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    true
  end

  def new?
    @user.role == 'admin'
  end

  def edit?
    @user.role == 'admin'
  end

  def create?
    @user.role == 'admin'
  end

  def update?
    @user.role == 'admin'
  end

  def destroy?
    @user.role == 'admin'
  end
end
