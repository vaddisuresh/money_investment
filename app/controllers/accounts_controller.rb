class AccountsController < ApplicationController

  def index
    @accounts = Account.all
  end

  def update_accounts
    account_balances_arry = Account.get_account_balances_arry
    if account_balances_arry.sum.to_f != params["amount"].to_f
      balance_hash = get_balance_accounts(account_balances_arry.reverse, params["amount"].to_f)
      accounts = Account.where("balance in (?)", balance_hash.keys)
      accounts.each do |acnt|
        acnt.balance = acnt.balance - balance_hash[acnt.balance]
        acnt.save!
      end
    else
      Account.all.update_all("balance = ?", 0.0)
    end
    @accounts = Account.all
  end

  def get_closest_amount(arr, amount)
    arr.find {|num| num > amount}
  end

  def get_balance_accounts(array, sum)
    rem_amt = sum
    a = {}
    array.each do |amt|
      next if rem_amt == 0.0
      if rem_amt >= amt
        if array.include?(rem_amt).blank?
          a[amt] = amt
          rem_amt -= amt
        else
          a[rem_amt] = rem_amt
          rem_amt -= rem_amt
        end
      else
        closest_amt = get_closest_amount(Account.get_account_balances_arry, rem_amt)
        if array.include?(rem_amt).blank?
          if closest_amt.present?
            a[closest_amt] = rem_amt
            rem_amt -= rem_amt
          else
            a[amt] = rem_amt
            rem_amt -= rem_amt
          end
        else
          a[rem_amt] = rem_amt
          rem_amt -= rem_amt
        end
      end
    end
    a
  end
end
