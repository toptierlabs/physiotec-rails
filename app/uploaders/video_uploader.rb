# encoding: utf-8

class VideoUploader < CarrierWave::Uploader::Base

  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  # include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
  # storage :file
  storage :fog

  #after :store, :convert_video

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{model.token}/"
  end

  def convert_video(filename)
    
    pipelineid = Rails.env.production? ? "1390495175517-be5lxg" : "1390495175517-be5lxg"
    
    puts '*'* 50
    puts  "uploads/#{model.class.to_s.underscore}/#{model.token}/#{filename}"

    #web_mp4_480_preset_id = "1351620000001-000030"
    web_mp4_360_preset_id = "1390494482545-d67snb"
    #convert the uploaded video
    transcoder = AWS::ElasticTranscoder::Client.new
    aws_et_job = transcoder.create_job(options = {
      pipeline_id: pipelineid,
      input: {  
        key: "uploads/#{model.class.to_s.underscore}/#{model.token}/#{filename}",
        frame_rate: 'auto',
        resolution: 'auto',
        aspect_ratio: 'auto',
        interlaced: 'auto',
        container: 'auto'
      },
      outputs: [{ 
        key: "uploads/#{model.class.to_s.underscore}/#{model.token}/encoded_#{filename}",
        preset_id: web_mp4_360_preset_id,
        thumbnail_pattern: "uploads/#{model.class.to_s.underscore}/#{model.token}/thumbnail_{count}",
        rotate: '0'
      }
      ]
      }
    )
   
    #add converted_ prefix to video's filenam e attribute
    model.update_column(:video, "encoded_#{filename}")
    
    #link the aws elastic transcoder job id with the video
    model.update_column(:job_id, aws_et_job.job[:id])
    
    #set to convering the video status
    model.update_column(:status, ExerciseVideo::STATES[:converting])

  end


  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url
  #   # For Rails 3.1+ asset pipeline compatibility:
  #   # ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  #
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  # Process files as they are uploaded:
  # process :scale => [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  # Create different versions of your uploaded files:
  # version :thumb do
  #   process :scale => [50, 50]
  # end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  # def extension_white_list
  #   %w(jpg jpeg gif png)
  # end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end

end
