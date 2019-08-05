require 'xivapi/version'

require 'xivapi/errors'
require 'xivapi/http'
require 'xivapi/page'
require 'xivapi/paginator'
require 'xivapi/request'

require 'rest-client'
require 'json'
require 'ostruct'

# Base module for the XIVAPI library
module XIVAPI
  include XIVAPI::Errors

  # The allowed language options
  LANGUAGE_OPTIONS = %w(en ja de fr cn kr).freeze

  # Client for making requests to XIVAPI
  class Client
    include XIVAPI::Request

    # @return [String] The API key
    attr_accessor :api_key

    # @return [true, false] Whether or not to query the staging API instead of production
    attr_accessor :staging

    # Initializes a new client for querying XIVAPI
    # @param api_key [String] API key provided by XIVAPI
    # @param language [String] Requested response langauge
    # @param staging [true, false] Whether or not to query the staging API instead of production
    def initialize(api_key: nil, language: :en, staging: false)
      @api_key = api_key

      self.language = language
      self.staging = staging
    end

    # @return [String] The language
    def language
      @language
    end

    # @param language [String, Symbol] The language to set for the client
    # @return The language
    def language=(language)
      lang = language.to_s.downcase
      raise ArgumentError, 'Unsupported language' unless LANGUAGE_OPTIONS.include?(lang)
      @language = lang
    end

    # @return [Hash] The default parameters for the client
    def default_params
      { private_key: @api_key, language: @language }
    end
  end
end
