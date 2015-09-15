require 'paperclip'
require 'paperclip-s3/version'
require 'paperclip-s3/railtie'


module Paperclip
  module S3

    # Use Paperclip::S3::Glue to keep the original gem style
    module Glue
      def self.included base
        base.extend ClassMethods
      end
    end

    module ClassMethods
      # Extends the paperclips has_attached_file method
      # It will use S3 Storage. The credentials will be read from the environment
      def has_attached_file(name, options = {})
        s3_protocol = !!ENV["S3_PROTOCOL"] ? ENV["S3_PROTOCOL"] : "http"
        options[:storage] = :s3
        options[:bucket]  ||= ENV["S3_BUCKET"]
        options[:s3_protocol] ||= s3_protocol
        options[:s3_credentials] ||= {
                                        :access_key_id => ENV['S3_KEY'],
                                        :secret_access_key => ENV['S3_SECRET']
                                    }
        # Allow creating S3_REGION env var to configure the target domain s3
        #
        if (region = ENV["S3_REGION"])
          options[:s3_host_name] ||= "#{ region }.amazonaws.com"
        end

        super(name, options)
      end
    end
  end
end
