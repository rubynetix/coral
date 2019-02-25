require 'digest'
require_relative 'watch_command'

class WatchAlter < WatchCommand

  USAGE = <<~EOS.freeze
    Usage: watch_alter
      ...

    [options]
  EOS

  BUFFER_SIZE = 8

  def initialize(input)
    super input
    @file_hashes = Hash.new # A hashtable to store file hashes, appropriate
  end

  def check_for_alterations
    until @files.empty?
      @files.each do |file|
        next if @file_hashes[file] == md5_hash(file)

        @files.delete(file)
        execute_action(file)
      end
    end
  end

  def execute
    return if nil_or_help?

    @files.each do |file|
      @files.delete(file) unless File.exists?(file)
    end

    @files.each do |file|
      @file_hashes[file] = md5_hash(file)
    end

    check_for_alterations
  end

  def md5_hash(file)
    Digest::MD5.hexdigest(file + File.read(file))
  end
end
