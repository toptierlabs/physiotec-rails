class NotificationsController < ApplicationController

  def create
    aws_request_body = JSON.parse(request.body.read())
    puts '='*50
    puts aws_request_body
    puts '\n','-'*50
    aws_message = JSON.parse(aws_request_body["Message"])
    #get video by jobid
    aws_et_job_id= aws_message["jobId"]
    video = Video.where(job_id: aws_et_job_id).first
    puts aws_message["state"]


    if ((aws_message["state"].upcase == "COMPLETED") || (aws_message["state"].upcase ==  "WARNING"))   
      #video.conversion_status = completed
      puts 'adsadsdas'
      video.status = Video::STATES[:completed]
    elsif (aws_message["state"].upcase == "ERROR")
      #get video by jobid
      puts 'asddsaadsdas'
      video.status = Video::STATES[:failed]
    end
    video.save

    render :nothing=>true, :status => 200, :content_type => 'text/html'
  end	

end


# {
#    "Type"   =>"Notification",
#    "MessageId"   =>"456a8094-85ee-53a1-8c1a-ca77fb8db457",
#    "TopicArn"   =>"arn:   aws:   sns:   us-west-2:339006013144:videonotifier",
#    "Subject"   =>"The Amazon Elastic Transcoder job 1382644766696-2di5iz has failed.",
#    "Message"   =>"   {
#       \n  \"state\":\"ERROR\",
#       \n  \"version\":\"2012-09-25\",
#       \n  \"jobId\":\"1382644766696-2di5iz\",
#       \n  \"pipelineId\":\"1382548852289-kax4vo\",
#       \n  \"input\":{
#          \n    \"key\":\"uploads/video/file/42/angularjs.rtf\",
#          \n    \"frameRate\":\"auto\",
#          \n    \"resolution\":\"auto\",
#          \n    \"aspectRatio\":\"auto\",
#          \n    \"interlaced\":\"auto\",
#          \n    \"container\":\"auto\"\n
#       },
#       \n  \"outputs\":[
#          {
#             \n    \"id\":\"1\",
#             \n    \"presetId\":\"1351620000001-000030\",
#             \n    \"key\":\"uploads/video/file/42/converted_angularjs.rtf\",
#             \n    \"thumbnailPattern\":\"uploads/video/file/42/thumbnail_            {
#                count
#             }            \",
#             \n    \"rotate\":\"0\",
#             \n    \"status\":\"Error\",
#             \n    \"statusDetail\":            \"4000 68c8117b-a562-42a7-8cd7-ad6d4e74b885:Amazon Elastic Transcoder could not interpret the video file.\",
#             \n    \"errorCode\":4000            \n
#          },
#          {
#             \n    \"id\":\"2\",
#             \n    \"presetId\":\"1351620000001-000040\",
#             \n    \"key\":\"uploads/video/file/42/converted_360_angularjs.rtf\",
#             \n    \"thumbnailPattern\":\"\",
#             \n    \"rotate\":\"0\",
#             \n    \"status\":\"Error\",
#             \n    \"statusDetail\":            \"4000 501e2eda-4ee5-4507-a9c5-b02f7121feb4:Amazon Elastic Transcoder could not interpret the video file.\",
#             \n    \"errorCode\":4000            \n
#          }
#       ]      \n
#    }   ", "   Timestamp"=>"2013-10-24T19:59:31.768   Z",
#    "SignatureVersion"   =>"1",
#    "Signature"   =>"BBInn24PcRWpuaYtHMuM2YoWDFWCBqUhanCPZY+5xLg/g5plNlkPCi2dkQmYiduoXSZOTkz9AdLxfpre6f/RKPgoplXge6CrVfibm1NasyhX9QHbNf8qmCP6ZVVHwdBRMBCmCBqlkq/BXLT9gASkp3ncRRKTOWwMvBq0wyEtThJeR/4IFxr3/aypGBKXXkAuynbiB2Sh9kKGGFxJpZ50zeTrNH+w0Meb26mxcnPaY2NJi2wIlBAf7WlSOOMkIgBzRg+2+8HN6rM55qh+Zxi9amSB2pf9hLvleRHHnKL3Q1SkpeJxvZxw6FMTsEYlUNLTs/42cpIx+NVtkU1lyTK4zw==",
#    "SigningCertURL"   =>"https://sns.us-west-2.amazonaws.com/SimpleNotificationService-e372f8ca30337fdb084e8ac449342c77.pem",
#    "UnsubscribeURL"   =>"https:   //sns.us-west-2.amazonaws.com/?Action=Unsubscribe&SubscriptionArn=arn:   aws:   sns:   us-west-2:339006013144:   videonotifier:034   aa3c1-31f5-4a77-99bc-37e7789c2711"
# }