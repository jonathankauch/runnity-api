# app/services/AwsUploadFile

class AwsUploadFile
  def initialize(picture)
    @picture = picture
  end

  def upload
    begin
      bucket = ENV['S3_BUCKET']
      pic = @picture
      content_type = pic.content_type.split('/').last

      if content_type == 'jpeg'
        content_type = 'jpg'
      end

      s3 = Aws::S3::Client.new(region: 'us-west-2')
      md5 = Digest::MD5.file(@picture.tempfile).hexdigest
      filename = md5 + '.' + content_type
      s3.put_object(bucket: bucket, key: 'pictures/' + filename, body: pic,
                    acl: 'public-read', content_type: pic.content_type)
      link = 'https://s3-us-west-2.amazonaws.com/' + bucket + '/pictures/' + filename

      {
        status: true,
        url: link,
        name: filename
      }
    rescue Exception => e
      logger.error(e)
      Raven.capture_exception(e)
    end
  end
end
