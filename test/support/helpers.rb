# frozen_string_literal: true

require 'active_support/test_case'

class ActiveSupport::TestCase

  def wait_for_ajax
    Timeout.timeout(::Capybara.default_max_wait_time) do
      loop until finished_all_ajax_requests?
    end
  end

  def finished_all_ajax_requests?
    page.evaluate_script('jQuery.active').zero?
  end


end
