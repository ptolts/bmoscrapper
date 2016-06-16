class IndexController < ApplicationController
  def index
    @notes = Note.q_model
  end
end
