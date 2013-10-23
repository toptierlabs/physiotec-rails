ActiveAdmin.register Video do

  show do
    params1 = '<param name="movie" value="flashfox.swf"/>
    <param name="allowFullScreen" value="true"/>
    <param name="wmode" value="transparent" />
    <param name="flashVars" value="controls=true&amp;poster=poster.jpg&amp;src=' + Rack::Utils.escape(resource.file.to_s) + '" />'

    h2 "Video Description"
    h4 resource.description
    video :width => "854", :height => "480", :controls => nil do #, :Poster => "http://vdemo2.software7.com/poster.jpg" 
      
      
      #rack::Utils.escape is used to encode the string to url format
      object :type => "application/x-shockwave-flash", :data =>asset_path('flashfox.swf'), :width => "854", :height => "480" do
        params1.html_safe
        #param :name => "movie", :value => "flashfox.swf"
        #param :name => "allowFullScreen", :value => "true"
        #param :name => "wmode", :value => "transparent"
        #param :name => "flashVars", :value => "controls=true&amp;poster=poster.jpg&amp;src=#{resource.file}"
        #<img alt="MyTitle" src="poster.jpg" width="640" height="360" title="Upps, no video playback capabilities??" />
      end
      source :src => resource.file, :type => "video/mp4"

    end
  end
end
