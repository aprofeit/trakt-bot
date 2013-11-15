class PagesController < ApplicationController
  def home
    @episodes = trakt.episodes
  end

  private

  def trakt
    @trakt ||= Trakt::Client.new
  end
end
