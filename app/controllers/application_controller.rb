class ApplicationController < ActionController::Base
  #protect_from_forgery

  #before_filter
  #hsh.delete_if { |k, v| v.empty? }

  def test(x)
  	hash_queue = Queue.new	
  	hash_queue << x
  	remove_keys = []
  	loop do
  		elem = hash_queue.pop
  		elem.keys.each do |v|
  			if elem[v].class == Hash
  				hash_queue << elem[v]
  			elsif elem[v].nil?
  				remove_keys << v
  			end
  			elem.except!(remove_keys)
  			remove_keys = []
  		end
  		break if hash_queue.empty?
  	end
  end

end
