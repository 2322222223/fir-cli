# encoding: utf-8

require_relative './common'

module FIR
  module Parser
    class Apk
      include Parser::Common

      def initialize(path)
        Zip.warn_invalid_date = false
        @apk = ::Android::Apk.new(path)
      end

      def full_info(options)
        if options.fetch(:full_info, false)
          basic_info.merge!(icons: tmp_icons)
        end

        basic_info
      end

      def basic_info
        @basic_info ||= {
          type:       'android',
          identifier: @apk.manifest.package_name,
          name:       @apk.label,
          build:      @apk.manifest.version_code.to_s,
          version:    @apk.manifest.version_name.to_s
        }
      end

      # @apk.icon is a hash, { icon_name: icon_binary_data }
      def tmp_icons
        begin
          @apk.icon.map { |_, data| generate_tmp_icon(data, :apk) }
        rescue
          []
        end
      end
    end
  end
end
