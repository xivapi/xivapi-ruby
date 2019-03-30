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
    # @param poll_rate [Integer] Frequency at which to poll when waiting for data to cache
    # @param staging [true, false] Whether or not to query the staging API instead of production
    def initialize(api_key: nil, language: :en, poll_rate: 5, staging: false)
      @api_key = api_key

      self.language = language
      self.poll_rate = poll_rate
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

    # @return [Integer] The rate at which cached requests are polled
    def poll_rate
      @poll_rate
    end

    # @param rate [Integer] The rate at which to poll cached requests
    # @return [Integer] The poll rate
    def poll_rate=(rate)
      raise ArgumentError, 'Poll rate must be a positive integer' unless rate.is_a?(Integer) && rate > 0
      @poll_rate = rate
    end

    # @return [Hash] The default parameters for the client
    def default_params
      { private_key: @api_key, language: @language }
    end
  end
end
