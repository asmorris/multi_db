class Current < ActiveSupport::CurrentAttributes
  attribute :account

  def user
    account
  end

  def user=(account)
    self.account = account
  end
end
