module TokyoPI
  class Configured
    attr_accessor :config
    def initialize(*args)
      if args.length > 0
        @config = args[0]
        # Pass the rest of the args down
        if args.length > 1
          setup(*args[1..-1])
        else
          setup
        end
      end
    end

    # Override me for extra arg handling
    def setup(*args) ; end
  end
end
