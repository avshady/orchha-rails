module Admin
  class DashboardController < BaseController
    def index
      @blocks = ContentBlock.order(:key)
    end
  end
end
