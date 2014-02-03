desc 'Pretty print out all defined routes in match order, with names. Target specific controller with CONTROLLER=x.'

task :api_routes => :environment do
if ENV['CONTROLLER']
  all_routes = PhysiotecV3::Application.routes.select { |route| route.defaults[:controller] == ENV['CONTROLLER'] }
else
  all_routes = PhysiotecV3::Application.routes
end
require 'syntax/convertors/html'
convertor = Syntax::Convertors::HTML.for_syntax "ruby"

File.open(File.join(Rails.root, "routes.html"), "w") do |f|
  f.puts "<html><head><title>Your APP</title>
         <style type='text/css'>
         body { background-color: #333; color: #FFF; }
         table { border: 1px solid #777; background-color: #111; }
         td, th { font-size: 11pt; text-align: left; padding-right: 10px; }
         th { font-size: 12pt; }
         pre { maring: 0; padding: 0; }
         .contrl_head { font-size: 14pt; padding: 15px 0 5px 0; }
         .contrl_name { color: #ACE; }
         .punct { color: #99F; font-weight: bold; }
         .symbol { color: #7DD; }
         .regex { color: #F66; }
         .string { color: #F99; }4
         </style></head>
         <body>"

  last_contrl = nil

  routes = all_routes.routes.collect do |route|
    if !route.requirements.empty?
      if route.requirements[:controller].start_with?('api/v1')
        if route.requirements[:controller] != last_contrl
          f.puts "</table>" if last_contrl
          last_contrl = route.requirements[:controller]
          f.puts "<div class='contrl_head'><b>Controller: <span class='contrl_name'>#{last_contrl}</span></b></div>" 
          f.puts "<table width='100%' border='0'><tr><th>Name</th><th>Verb</th><th>Path</th><th>Description</th></tr>" 
        end

        reqs = route.requirements.inspect
        verb = route.verb.source
        verb = verb[1..(verb.length-2)] if verb
        r = { :name => route.name, :verb => verb, :path => route.path, :reqs => reqs }
        if route.name.nil? ||  (!route.name.start_with?('new') && !route.name.start_with?('edit'))
          f.puts "  <tr><td width='12%' class='string'><b>#{r[:name]}</b></td>"
          f.puts "  <td width='5%' class='symbol'><b>#{r[:verb]}</b></td>" 
          f.puts "  <td width='3%' class='regex'>#{r[:path].spec.to_s}</td>"
          f.puts "  <td width='80%'>{Insert description here}</td></tr>"
        end
        
      end
    end
  end

  f.puts "</table></body></html>"
end
end