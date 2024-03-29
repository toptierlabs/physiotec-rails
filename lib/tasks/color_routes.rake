desc 'Pretty print out all defined routes in match order, with names. Target specific controller with CONTROLLER=x.'
task :color_routes => :environment do
  all_routes = ENV['CONTROLLER'] ? PhysiotecV3::Application.routes.select { |route| route.defaults[:controller] == ENV['CONTROLLER'] } : PhysiotecV3::Application.routes
  routes = all_routes.routes.collect do |route|
    reqs = route.requirements.empty? ? "" : route.requirements.inspect
    {:name => route.name, :verb => route.verb, :path => route.path, :reqs => reqs}
  end
  File.open(File.join(Rails.root, "routes.html"), "w") do |f|
    f.puts "<html><head><title>Rails 3 Routes</title></head><body><table border=1>"
    f.puts "<tr><th>Name</th><th>Verb</th><th>Path</th><th>Requirements</th></tr>"
    routes.each do |r|
      f.puts "<tr><td>#{r[:name]}</td><td>#{r[:verb]}</td><td>#{r[:path]}</td><td>#{r[:reqs]}</td></tr>"
    end
    f.puts "</table></body></html>"
  end
end