class ApplicationController < ActionController::Base
  #protect_from_forgery
  #before_filter :sanitize_params_nil_values

  def sanitize_params_nil_values
    params.deep_reject!{ |k, v| v.nil? }
  end

end
