#
# generate_server_names.rb
#

module Puppet::Parser::Functions
  newfunction(:generate_server_names, :type => :rvalue, :doc => <<-EOS

This function applies a suffix and a prefix to all elements in an array.

*Examples:*
  $server_names = [ 'test1.ch', 'test2.ch' ]
  $supre = {
    'suffix' => [ '.server1', '.server2' ],
    'prefix' => [ 'www.', 'dev.' ],
  }
  generate_server_names($server_names,$supre)

Will return:
["test1.ch", "test2.ch", "www.test1.ch", "dev.test1.ch", "www.test2.ch",
 "dev.test2.ch", "test1.ch.server1", "test1.ch.server2", "test2.ch.server1", "test2.ch.server2"]

  EOS
) do |arguments|

    # Two arguments are required
    raise(Puppet::ParseError, "generate_server_names(): Wrong number of arguments " +
      "given (#{arguments.size} for 2)") if arguments.size != 2

    input = arguments[0]
    unless input.is_a?(Array)
       raise Puppet::ParseError, "generate_server_names(): expected first argument to be an Array, got #{array.inspect}"
    end

    unless arguments[1].is_a?(Hash)
       raise Puppet::ParseError, "generate_server_names(): expected second argument to be a Hash, got #{array.inspect}"
    end

    suffix = arguments[1]['suffix']
    prefix = arguments[1]['prefix']

    suffixed = []
    input.each do |i|
      suffix.each do |s|
       suffixed << i + s
      end
    end

    prefixed = []
    input.each do |i|
      prefix.each do |s|
       prefixed << s + i
      end
    end

    unioned1 = input | prefixed
    unioned = unioned1 | suffixed

    return unioned

  end
end

# vim: set ts=2 sw=2 et :
