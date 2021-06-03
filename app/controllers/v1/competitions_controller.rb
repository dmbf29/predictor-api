class V1::CompetitionsController < ApplicationController
  skip_before_action :authenticate_user!, only: :index

  def index
    @competitions = policy_scope(Competition)
  end
end
