ActiveAdmin.register Video do
  show do
    h2 "Video Description"
    h4 resource.description
    video :width => "853", :height => "480", :controls => nil do #, :Poster => "http://vdemo2.software7.com/poster.jpg" 
      source :src => resource.file, :type => "video/mp4"
      params = '<param name="movie" value="flashfox.swf"/>
      <param name="allowFullScreen" value="true"/>
      <param name="wmode" value="transparent" />
      <param name="flashVars" value="controls=true&amp;poster=poster.jpg&amp;src=' + Rack::Utils.escape(resource.file.to_s) + '" />'
      object :type => "application/x-shockwave-flash", :data =>"http://vdemo2.software7.com/flashfox.swf", :width => "853", :height => "480" do
        params.html_safe
        #param :name => "movie", :value => "flashfox.swf"
        #param :name => "allowFullScreen", :value => "true"
        #param :name => "wmode", :value => "transparent"
        #param :name => "flashVars", :value => "controls=true&amp;poster=poster.jpg&amp;src=#{resource.file}"
        #<img alt="MyTitle" src="poster.jpg" width="640" height="360" title="Upps, no video playback capabilities??" />
      end
    end
  end
end
