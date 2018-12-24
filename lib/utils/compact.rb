class Hash
  unless Hash.instance_methods(false).include?(:compact)
    def compact
      select { |_, value| !value.nil? }
    end
  end
end
