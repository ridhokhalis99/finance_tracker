class TransactionController < ApplicationController
  before_action :authenticate_user!

  def index
    @transactions = Transaction.where(user: current_user)
  end

end
