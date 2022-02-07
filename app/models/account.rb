class Account < ApplicationRecord
  def self.get_account_balances_arry
    Account.all.pluck("balance").sort
  end
end